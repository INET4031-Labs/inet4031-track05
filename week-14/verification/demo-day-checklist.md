# Demo Day Verification Checklist

**Track:** 5 - Network and Cloud Infrastructure  
**Week:** 14 - Demo Day  
**Date:** 

Use this checklist before, during, and after the demo to ensure all systems are operational.

---

## Pre-Demo Verification (1 hour before)

### Cluster Health

- [ ] k3d cluster running: `k3d cluster list`
- [ ] All nodes Ready: `kubectl get nodes`
- [ ] Linkerd namespace exists: `kubectl get namespace linkerd`
- [ ] Linkerd pods running: `kubectl get pods -n linkerd`
- [ ] Flask namespace exists: `kubectl get namespace <flask-namespace>`
- [ ] Flask pods running: `kubectl get pods -n <flask-namespace>`
- [ ] PostgreSQL namespace exists: `kubectl get namespace <postgres-namespace>`
- [ ] PostgreSQL pods running: `kubectl get pods -n <postgres-namespace>`

### Service Connectivity

- [ ] Flask can reach PostgreSQL:
  ```bash
  kubectl exec -it <flask-pod> -n <flask-namespace> -- curl http://postgres:5432
  # or run your test query
  ```
  Expected: Connection successful (may show connection refused from HTTP, but connection established)

- [ ] Prometheus collecting Linkerd metrics:
  ```bash
  curl -s http://localhost:9090/api/v1/query?query=up | jq '.data.result | length'
  ```
  Expected: Non-zero number of metrics

### Grafana Dashboards

- [ ] Grafana accessible: http://localhost:3000
- [ ] Grafana login successful (admin/admin or your password)
- [ ] Linkerd Prometheus datasource working: Data Sources -> Linkerd -> Test Data Source
- [ ] Latency dashboard loads: Dashboard -> Linkerd Service-to-Service Latency
- [ ] Latency dashboard displays data (may take 1-2 minutes):
  - P50 latency visible
  - P95 latency visible
  - P99 latency visible
- [ ] Success rate dashboard loads: Dashboard -> Linkerd Service-to-Service Success Rate
- [ ] Success rate dashboard displays data:
  - Success rate percentage visible
  - Error breakdown visible

### Network Policies

- [ ] Test blocking policy YAML prepared: `week-12/network-policies/test-blocking-policy.yaml`
- [ ] Test allow policy YAML prepared: `week-12/network-policies/test-allow-policy.yaml`
- [ ] No active blocking policies (to avoid demo disruption):
  ```bash
  kubectl get networkpolicy --all-namespaces
  ```
  Expected: No blocking policies currently applied

### Demo Readiness

- [ ] Demo script reviewed: `week-13/demo-script.md` (if created) or backlog
- [ ] Presenter has practiced demo at least once
- [ ] Backup presenter identified
- [ ] Fallback procedures reviewed
- [ ] All demo commands tested on current cluster
- [ ] Timing verified (should be < 15 minutes total)

---

## During Demo Execution

### Linkerd Verification Step

Command:
```bash
linkerd check 2>/dev/null | tail -3
```

Expected output:
```
Status check results are [OK]
(or similar indicating all checks passed)
```

Fallback: If check fails, show previous week's check output as reference

---

### Meshed Traffic Test

Command: (your incident data query via Flask)
```bash
# Example: kubectl exec -it <flask-pod> -n <flask-namespace> -- \
#   python3 -c "import requests; r = requests.get('http://localhost:5000/api/incidents'); print(r.status_code, len(r.json()))"
```

Expected: HTTP 200 or equivalent success, data returns

Fallback: If test fails, explain mTLS verification and show proxy logs

---

### Grafana Latency Dashboard

1. Navigate to Grafana: http://localhost:3000
2. Click: Dashboards -> Linkerd Service-to-Service Latency
3. Show: P50, P95, P99 latency graphs
4. Explain: Latencies show communication overhead with mTLS enabled
5. Expected: Graphs display 1-5ms typical latencies (varies by system)

Fallback: If dashboard doesn't load, refresh browser or restart Grafana pod

---

### Grafana Success Rate Dashboard

1. Navigate to: Dashboards -> Linkerd Service-to-Service Success Rate
2. Show: Success rate and error breakdown
3. Explain: 99-100% baseline success rate indicates healthy mTLS
4. Expected: Success rate > 99%

Fallback: If slow to load, explain that metrics refresh every 30 seconds

---

### NetworkPolicy Blocking Demonstration

**Step 1: Apply Blocking Policy**
```bash
kubectl apply -f week-12/network-policies/test-blocking-policy.yaml
# Verify: kubectl get networkpolicy -n <postgres-namespace>
```

**Step 2: Show Success Rate Drop**
- Watch Grafana success rate dashboard
- Wait 1-2 minutes for metrics to update
- Success rate should drop to 0% or near 0%
- Explain: The network policy is blocking all ingress to PostgreSQL pods

**Step 3: Remove Blocking Policy**
```bash
kubectl delete networkpolicy flask-to-postgres-block -n <postgres-namespace>
# Verify: kubectl get networkpolicy -n <postgres-namespace> (should be empty or show only new policy)
```

**Step 4: Show Recovery**
- Watch Grafana success rate dashboard
- Wait 1-2 minutes for recovery
- Success rate should return to > 99%
- Explain: Traffic flows again immediately after policy removal

Fallback: If policy doesn't block traffic, check pod labels in policy match the actual pod labels used in cluster

---

### Demo Completion

- [ ] All steps executed successfully
- [ ] Audience understood the concepts
- [ ] Questions answered satisfactorily
- [ ] Technical issues noted for post-demo resolution
- [ ] Overall timing acceptable (< 15 minutes)

---

## Post-Demo: Cluster Wipe

### Pre-Wipe Backup (if needed)

```bash
# If any persistent data needs to be preserved, back it up now
# Example: kubectl get all --all-namespaces -o yaml > backup.yaml
```

### Cluster Deletion

Command:
```bash
k3d cluster delete <cluster-name>
```

Expected:
- Cluster removed from `k3d cluster list`
- No errors or warnings
- Time: 1-2 minutes

Verification:
```bash
k3d cluster list
# Cluster should not be listed
```

---

## Post-Demo: Cluster Rebuild

### Cluster Recreation

Command:
```bash
k3d cluster create <cluster-name> \
  --servers 1 \
  --agents 2 \
  --volume /path/to/data:/mnt/data@all \
  --port 80:80@loadbalancer \
  --port 443:443@loadbalancer
```

(Adjust options based on your initial cluster configuration)

Expected:
- Cluster created and appears in `k3d cluster list`
- Status: "Running"
- Time: 2-3 minutes

Verification:
```bash
k3d cluster list
kubectl get nodes
# All nodes should be in Ready state
```

### Ansible Playbook Rebuild

Command:
```bash
ansible-playbook -i inventory ansible/site.yml
```

Expected:
- All tasks complete without critical errors
- Exit code 0
- Time: 30-45 minutes

Verification:
```bash
# Check final task counts in playbook output
# Should show something like:
# PLAY RECAP
# <host> : ok=<total> changed=<n> unreachable=0 failed=0
```

---

## Post-Rebuild Verification

### All Services Running

```bash
# Check all namespaces
kubectl get pods --all-namespaces

# Should show:
# - linkerd system pods
# - Flask pods with 2/2 containers
# - PostgreSQL pods with 2/2 containers
# - Prometheus, Grafana, etc.
```

### Linkerd Verification

```bash
linkerd check 2>/dev/null | tail -3
# Should show: Status check results are [OK]
```

### Connectivity Test

```bash
# Test Flask to PostgreSQL through mesh
kubectl exec -it <flask-pod> -n <flask-namespace> -- \
  python3 -c "import requests; r = requests.get('http://localhost:5000/api/incidents'); print('Success' if r.status_code == 200 else 'Failed')"
```

Expected: "Success"

### Grafana Dashboards

```bash
# Open Grafana and check dashboards
# http://localhost:3000

# Wait 2-3 minutes for metrics to populate
# Latency and success rate dashboards should display data
```

Expected: Dashboards show Flask->PostgreSQL metrics with normal baselines

---

## Troubleshooting Quick Reference

### Linkerd pods not starting
- Check logs: `kubectl logs -n linkerd <pod-name> -c <container>`
- Verify CRD installation: `kubectl get crds | grep linkerd`
- Restart pods: `kubectl delete pod -n linkerd --all`

### Flask or PostgreSQL not meshed
- Check namespace annotation: `kubectl get namespace <ns> -o jsonpath='{.metadata.labels}'`
- Verify annotation: should include `linkerd.io/inject=enabled`
- Restart pods: `kubectl rollout restart deployment -n <ns> --all` or `statefulset`

### Grafana dashboards show no data
- Verify datasource connectivity: Grafana Data Sources -> Linkerd -> Test
- Check if metrics exist: Go to Prometheus and query `up{job="linkerd-proxy"}`
- Wait for metrics: Initial data may take 2-3 minutes to appear post-rebuild

### NetworkPolicy blocking doesn't work
- Verify pod labels in policy match actual pod labels: `kubectl get pods -n <ns> -o wide`
- Check policy applied: `kubectl get networkpolicy -n <ns> -o yaml`
- Test connectivity manually: `kubectl exec <flask-pod> -- curl postgres:5432`

### Ansible playbook fails
- Check error message in playbook output
- Run in check mode first: `ansible-playbook -i inventory ansible/site.yml --check`
- Review specific role logs if available
- Escalate to TA if critical error

---

## Success Criteria

By end of Demo Day, confirm:

- [ ] Linkerd check output: PASS
- [ ] Flask to PostgreSQL connectivity: WORKING
- [ ] Grafana latency dashboard: DISPLAYING DATA
- [ ] Grafana success rate dashboard: DISPLAYING DATA
- [ ] NetworkPolicy blocking demo: SUCCESSFUL
- [ ] Cluster wipe: SUCCESSFUL
- [ ] Cluster rebuild: SUCCESSFUL
- [ ] Post-rebuild services: ALL RUNNING
- [ ] Post-rebuild Linkerd: VERIFIED
- [ ] Post-rebuild Grafana: DATA POPULATING
- [ ] Demo presentation: COMPLETED

---

## Sign-Off

- Demo Date: 
- Demo Presenter: 
- Technical Support: 
- Verification Completed: (yes/no)
- Issues Encountered: (yes/no)
- All Criteria Met: (yes/no)
- Overall Status: SUCCESS / PARTIAL / FAILED

---

## Final Notes

Track 5: Network and Cloud Infrastructure successfully demonstrates:
1. Linkerd service mesh installation and configuration
2. Automatic mTLS for inter-service communication
3. Request-level observability and latency metrics
4. Service-to-service traffic visualization
5. Network policy enforcement on meshed services
6. Full infrastructure-as-code reproducibility via Ansible

This completes the INET 4031 Challenge Tracks - Weeks 10-14.
