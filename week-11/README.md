---
**Week 1-9 Prerequisite**

Weeks 10-14 assume your completed Weeks 1-9 repositories are available as peer directories in `Student Repositories/`. This track's Ansible roles reference your prior work:
- `linkerd` role uses your k3d cluster from Week 5 (`../week-05/`)
- `linkerd` role meshes your Flask application from Week 2 (`../week-02/`) and PostgreSQL from Week 4 (`../week-04/` or `../infrastructure/`)

Your track repo does NOT copy these — it integrates with them. Ensure your Week 1-9 work is complete and accessible before Week 11.

---

# Week 11: Core Build - Linkerd Installation and Service Meshing

**Sprint 6 | Asynchronous**

## Overview

Week 11 is the core implementation sprint for the Network and Cloud Infrastructure track. Your team will install Linkerd as the service mesh control plane, mesh the Flask and PostgreSQL services with automatic mTLS, and validate that traffic encryption and metrics are working.

By the end of Week 11, you will have:

1. Linkerd control plane running on the k3d cluster
2. Flask and PostgreSQL services injected with Linkerd data plane proxies
3. Automatic mTLS established between meshed services
4. Linkerd CLI verification showing healthy mesh
5. Initial Ansible role for Linkerd installation

## Prerequisites

- Week 10 complete: Architecture decision and backlog finalized
- k3d cluster running with incident platform (Flask and PostgreSQL from Weeks 1-9)
- kubectl access to the cluster
- Helm 3+ installed locally (for Helm deployment)
- Sufficient cluster resources for Linkerd control plane (2-4 GB memory available)

## Part 1: Install Linkerd Control Plane

### Step 1: Verify Cluster Compatibility

```bash
# Check k3d cluster is running
kubectl cluster-info

# Verify cluster version
kubectl version --short
```

### Step 2: Install Linkerd CLI

Download and install the Linkerd CLI from https://linkerd.io/2/getting-started/#step-1-install-the-cli

```bash
# Example for Linux/macOS
curl -sL https://run.linkerd.io/install | sh

# Add to PATH
export PATH=$PATH:~/.linkerd2/bin
linkerd version
```

### Step 3: Pre-Installation Checks

```bash
# Run Linkerd pre-install checks
linkerd check --pre

# Output should show green checkmarks for all pre-installation checks
```

### Step 4: Install Linkerd using Helm

```bash
# Add Linkerd Helm repository
helm repo add linkerd https://helm.linkerd.io
helm repo update

# Create linkerd namespace
kubectl create namespace linkerd

# Install Linkerd control plane
helm install linkerd2 linkerd/linkerd2 \
  --namespace linkerd \
  --set installNamespace=false \
  --wait

# Wait for installation to complete (~2 minutes)
kubectl rollout status deployment/linkerd-controller -n linkerd
```

### Step 5: Verify Linkerd Installation

```bash
# Check Linkerd pods
kubectl get pods -n linkerd

# Run Linkerd post-install checks
linkerd check

# Expected output: All checks pass (green checkmarks)
```

Expected output:
```
> version
  stable-2.14.x
> proxy-init
  ✓ ready on node-0
> install-config
  ✓ install config is valid
...
```

### Step 6: Access Linkerd Dashboard (Optional)

```bash
# Start port-forward to Linkerd web UI
linkerd viz install | kubectl apply -f -
kubectl -n linkerd-viz port-forward svc/web 8084:8084

# Open browser: http://localhost:8084
```

## Part 2: Mesh the Flask Application

### Step 1: Annotate Flask Namespace

```bash
# Identify the namespace where Flask is running (e.g., default or app)
kubectl get pods --all-namespaces | grep flask

# Annotate the namespace for Linkerd auto-injection
# Example: if Flask is in 'default' namespace
kubectl annotate namespace default linkerd.io/inject=enabled --overwrite
```

### Step 2: Restart Flask Pod

```bash
# Delete the Flask pod to trigger re-creation with Linkerd sidecar
kubectl delete pod -l app=flask

# Verify new pod has two containers (Flask + linkerd-proxy)
kubectl get pod -l app=flask -o jsonpath='{.items[0].spec.containers[*].name}'

# Expected output: flask linkerd-proxy
```

### Step 3: Verify Linkerd Sidecar Injection

```bash
# Check sidecar logs
kubectl logs -l app=flask -c linkerd-proxy

# Should show proxy startup messages without errors
```

## Part 3: Mesh the PostgreSQL Service

### Step 1: Identify PostgreSQL Service

```bash
# Find PostgreSQL service
kubectl get svc | grep postgres

# Example: statustracker-postgres
```

### Step 2: Annotate PostgreSQL Namespace

```bash
# If PostgreSQL is in a different namespace, annotate it
kubectl annotate namespace <postgres-namespace> linkerd.io/inject=enabled --overwrite
```

### Step 3: Restart PostgreSQL Pod

```bash
# Delete PostgreSQL pod to trigger re-creation with sidecar
kubectl delete pod -l app=postgres

# Verify sidecar injection
kubectl get pod -l app=postgres -o jsonpath='{.items[0].spec.containers[*].name}'

# Expected output: postgres linkerd-proxy
```

## Part 4: Verify End-to-End mTLS

### Step 1: Check Mesh Status

```bash
# View all meshed services
kubectl get all -A | grep linkerd

# Check service mesh pods
linkerd viz stat pods

# Expected output: Shows all meshed pods with mTLS status
```

### Step 2: Verify mTLS Certificate

```bash
# Check Linkerd certificates
linkerd identity

# Verify pod certificates
kubectl exec -it <flask-pod> -c linkerd-proxy -- \
  curl -s localhost:4191/metrics | grep tls_cert

# Expected output: tls_cert metrics showing certificate status
```

### Step 3: Test Traffic Between Services

```bash
# From Flask pod, test connection to PostgreSQL
kubectl exec -it <flask-pod> -- psql \
  -h <postgres-service> \
  -U appuser \
  -d statustracker \
  -c "SELECT COUNT(*) FROM incidents;"

# Connection should succeed with mTLS encryption
```

## Part 5: Verify Traffic Metrics

```bash
# Check live traffic between services
linkerd viz top

# View deployment stats (replicas, success rates)
linkerd viz stat deploy

# Expected output: Shows Flask and PostgreSQL with 0% error rates
```

## Part 6: Implement Ansible Role for Linkerd

### Step 1: Create Role Tasks

Create `ansible/roles/linkerd/tasks/main.yml`:

```yaml
---
- name: Install Linkerd CLI
  shell: |
    curl -sL https://run.linkerd.io/install | sh
  creates: "{{ ansible_env.HOME }}/.linkerd2/bin/linkerd"

- name: Create linkerd namespace
  kubernetes.core.k8s:
    name: linkerd
    api_version: v1
    kind: Namespace
    state: present

- name: Add Linkerd Helm repository
  kubernetes.core.helm_repository:
    name: linkerd
    repo_url: https://helm.linkerd.io

- name: Deploy Linkerd control plane
  kubernetes.core.helm:
    name: linkerd2
    chart_ref: linkerd/linkerd2
    release_namespace: linkerd
    values:
      installNamespace: false
    state: present
    wait: yes

- name: Enable auto-injection for Flask namespace
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: default
        annotations:
          linkerd.io/inject: enabled

- name: Restart Flask pods for sidecar injection
  kubernetes.core.k8s:
    state: absent
    api_version: v1
    kind: Pod
    namespace: default
    label_selectors:
      - app=flask
```

### Step 2: Create Ansible Handler

Create `ansible/roles/linkerd/handlers/main.yml`:

```yaml
---
- name: Wait for Linkerd pods
  kubernetes.core.k8s_info:
    kind: Pod
    namespace: linkerd
    label_selectors:
      - control-plane
    wait: yes
    wait_condition:
      type: Ready
      status: "True"
```

## Part 7: Test Ansible Role

```bash
# Validate syntax
ansible-playbook -i ansible/inventory ansible/site.yml --syntax-check

# Dry-run
ansible-playbook -i ansible/inventory ansible/site.yml --check

# Apply
ansible-playbook -i ansible/inventory ansible/site.yml

# Verify
linkerd check
```

## Part 8: Document in Environment Log

Update `docs/environment-log.md` with:

1. Linkerd version and installation date
2. Cluster version and node count
3. Namespaces configured for auto-injection
4. Services meshed and their status
5. Metrics collection status
6. Any errors or blockers encountered

Template entry:

```markdown
### Week 11: Linkerd Installation and Service Meshing

**Linkerd Control Plane:**
- Version: [output of linkerd version]
- Namespace: linkerd
- Status: Running
- Installation date: [date]

**Meshed Services:**
- Flask (namespace: default, status: ✓ injected)
- PostgreSQL (namespace: default, status: ✓ injected)

**mTLS Status:**
- Certificates: Issued by Linkerd CA
- Verification: linkerd identity output attached

**Metrics Collection:**
- Prometheus: [status]
- Grafana: [status - configured or pending]

**Known Issues:**
[Document any issues encountered]
```

## Part 9: Commit and Verify

```bash
git add week-11/ ansible/ docs/
git commit -m "Week 11: Linkerd installation, service meshing, Ansible role"
git push origin main
```

## Verification Checklist

- [ ] Linkerd control plane pods running in linkerd namespace
- [ ] `linkerd check` passes all checks
- [ ] Flask pod has linkerd-proxy sidecar injected
- [ ] PostgreSQL pod has linkerd-proxy sidecar injected
- [ ] Traffic between Flask and PostgreSQL flows without errors
- [ ] mTLS certificates issued and valid
- [ ] Linkerd tap/metrics show live traffic
- [ ] Ansible role creates Linkerd without errors
- [ ] All files committed to git

## Troubleshooting

### "Failed to connect to cluster"
- Verify kubectl is configured: `kubectl cluster-info`
- Check k3d cluster is running: `k3d cluster list`

### "Insufficient resources for control plane"
- Check cluster memory: `kubectl describe node`
- Scale down other workloads or increase cluster size

### "Sidecar injection not working"
- Verify namespace annotation: `kubectl get ns -o jsonpath='{.items[*].metadata.annotations.linkerd\.io/inject}'`
- Restart pod: `kubectl delete pod <pod-name>`

### "Certificate verification failed"
- Check Linkerd CA: `kubectl get secret -n linkerd issuer-tls`
- Review sidecar logs: `kubectl logs <pod> -c linkerd-proxy`

## Next Steps

Week 12 continues with:

1. Installing Grafana and creating dashboards for latency and success rates
2. Implementing NetworkPolicy on meshed services
3. Demonstrating traffic blocking and allow policies
4. Verifying end-to-end demo readiness

Refer to `../week-12/README.md` for detailed instructions.
