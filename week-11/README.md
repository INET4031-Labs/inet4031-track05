---
**Week 1-9 Prerequisite**

Weeks 10-14 assume your completed Weeks 1-9 repositories are available as peer directories in `Student Repositories/`. This track's Ansible playbook (`ansible/site.yml`) rebuilds the Weeks 1-4 baseline (baseline packages, `app-stack`, `k3d-setup`, `opentofu-setup`) and then layers the `linkerd` role on top, targeting the same `myapp` k3d cluster and `default` namespace your Week 1-9 work already established.

---

## Week 11: Core Build — Linkerd Installation and Service Meshing

**Sprint 6 | Asynchronous**

### Overview

Week 11 is the core implementation sprint. Your team installs the Linkerd control plane on your `myapp` k3d cluster, meshes the Flask and PostgreSQL deployments (both in the `default` namespace) with automatic mTLS, and starts turning the manual steps into an idempotent Ansible role — `week-11/ansible/roles/linkerd/` — that Week 14's Demo Day rebuild will depend on. By the end of the week you should have a mesh that passes `linkerd check`, two services with visible sidecars, and a first working (if rough) version of the Ansible automation.

### Learning Objectives

- Install and verify a Linkerd control plane against a live k3d cluster
- Mesh existing Kubernetes workloads via namespace-level auto-injection annotation, without modifying application code
- Verify mTLS is actually happening (not just installed) by inspecting proxy logs and Linkerd's own metrics
- Write an idempotent Ansible role that installs and verifies a non-trivial piece of infrastructure
- Diagnose the Week 1-9-specific `KUBECONFIG` gotcha that trips up most Ansible-driven k3d workflows

### Prerequisites

- Week 10 complete: architecture decision (`week-10/adr.md`) finalized, backlog reviewed
- `myapp` k3d cluster running with the Week 1-9 incident platform healthy in the `default` namespace
- `kubectl` access to the cluster
- Helm 3+ installed locally, if your Week 10 decision was to install via Helm
- ~2-4 GB of free cluster memory for the Linkerd control plane

---

### Part 1: Install the Linkerd CLI and Control Plane

**Step 1.** Verify cluster compatibility before installing anything:

```bash
kubectl cluster-info
kubectl version --short
```

**Step 2.** Install the Linkerd CLI (`https://linkerd.io/2/getting-started/#step-1-install-the-cli`) and confirm it's on your `PATH`:

```bash
curl -sL https://run.linkerd.io/install | sh
export PATH=$PATH:~/.linkerd2/bin
linkerd version
```

**Step 3.** Run `linkerd check --pre` and resolve anything it flags before moving on — RBAC permission issues or CRD conflicts here will resurface later as confusing pod-level failures if you skip past them.

**Step 4.** Deploy the control plane using **the installation approach your team decided on in Week 10** — Helm, or the CLI's own `linkerd install | kubectl apply -f -` path. Both work; use whichever your ADR committed to, since Part 6 of this week automates that same choice.

**Step 5.** Verify: `kubectl get pods -n linkerd` should show all control-plane pods Running, and `linkerd check` (no `--pre`) should pass. Don't move to Part 2 until this is green — a shaky control plane makes every downstream mesh failure ambiguous.

> **Enterprise Pattern:** Production platform teams treat `<tool> check` (or the equivalent health-check command) as a hard gate before rollout, not a nice-to-have. Skipping straight to meshing workloads on top of an unverified control plane is how a Tuesday afternoon becomes a Wednesday morning.

---

### Part 2: Mesh the Flask Application

**Step 1.** Annotate the `default` namespace for Linkerd auto-injection:

```bash
kubectl annotate namespace default linkerd.io/inject=enabled --overwrite
```

**Step 2.** Restart the Flask pod(s) to trigger sidecar injection, and confirm each pod now runs two containers (`flask` + `linkerd-proxy`):

```bash
kubectl rollout restart deployment flask -n default
kubectl get pod -l app=flask -n default -o jsonpath='{.items[0].spec.containers[*].name}'
```

**Step 3.** Check the `linkerd-proxy` container's logs for a clean startup with no connection errors back to the control plane.

---

### Part 3: Mesh the PostgreSQL Service

Same pattern as Part 2, applied to your PostgreSQL deployment (label `app: db` — the actual label used by this track's manifests, not `app: postgres`). Since Flask and PostgreSQL share the `default` namespace, the namespace annotation from Part 2 already covers PostgreSQL — you only need to trigger the restart and verify the sidecar:

```bash
kubectl rollout restart deployment db -n default
kubectl get pod -l app=db -n default -o jsonpath='{.items[0].spec.containers[*].name}'
```

---

### Part 4: Verify End-to-End mTLS and Metrics

**Step 1.** Confirm both services show up as meshed, and pull a first look at live traffic stats:

```bash
linkerd viz install | kubectl apply -f -   # if you haven't already
linkerd viz stat pods -n default
linkerd viz top
```

**Step 2.** Confirm mTLS is actually active — not just that sidecars are present. Check `linkerd identity`, and grep proxy logs for TLS handshake evidence between the Flask and PostgreSQL sidecars.

**Step 3.** Run a real incident-data query from Flask through the meshed connection and confirm it still succeeds. If your Week 1-9 platform has a `/api/incidents` endpoint or equivalent, exercise it now — a mesh that blocks your own application traffic is a demo-day disaster waiting to happen.

**Step 4.** Capture the `linkerd check` output and a `linkerd viz stat` snapshot in `docs/sprint-11-retrospective.md` under **Notes** — this becomes your baseline for comparing against the Week 14 post-rebuild state.

---

### Part 5: Build the Linkerd Ansible Role

This is the deliverable that carries you through to Demo Day: everything you just did by hand in Parts 1-3 needs to also happen via `ansible-playbook -i inventory ansible/site.yml`, idempotently.

**Step 1.** The role skeleton already exists at `week-11/ansible/roles/linkerd/tasks/main.yml`, wired into `ansible/site.yml` as the last play, with `flask_namespace` and `postgres_namespace` both defaulting to `default` (matching your Week 1-9 baseline — there's no reason to override these unless your team deliberately split namespaces). Read through it before making changes; it already implements CLI install, pre-checks, control-plane deploy, namespace annotation, pod restart, and verification as separate tagged blocks (`linkerd`, `install`, `deploy`, `inject`, `verify`, `status`).

**Step 2.** Pay close attention to how the role resolves `KUBECONFIG`. Because this play runs with `become: yes`, a naive default of `/root/.kube/config` will fail — k3d writes its kubeconfig to the *invoking, non-root* user's `$HOME/.kube/config`, not root's. The role resolves this the same way the Week 1-9 baseline check scripts do: `REAL_USER=${SUDO_USER:-$USER}`, then `getent passwd "$REAL_USER" | cut -d: -f6` for that user's real home directory, and defaults `KUBECONFIG` to `<that home>/.kube/config` rather than assuming root's path. If you add new tasks that talk to the cluster, reuse the `default_kubeconfig_path` fact this role already computes — don't reintroduce a hardcoded `/root/.kube/config`.

**Step 3.** Validate syntax and dry-run before applying:

```bash
ansible-playbook -i ansible/inventory ansible/site.yml --syntax-check
ansible-playbook -i ansible/inventory ansible/site.yml --check
```

**Step 4.** Run it for real, then run it again — the second run should show `changed=0` for tasks that are already satisfied. Fix any task that isn't idempotent now; it's much cheaper to fix in Week 11 than to discover during the Week 13 dry-run.

---

### Validation Checks

**QA runs all validation checks.** Confirm each of the following against a live cluster, not from memory.

#### Validation Check: Control Plane Healthy

`linkerd check` returns all checks passed — no manual interpretation needed, the tool's own exit code and output say pass or fail.

#### Validation Check: Both Services Meshed

`kubectl get pods -n default -o jsonpath='{.items[*].spec.containers[*].name}'` includes `linkerd-proxy` for both the Flask and PostgreSQL pods.

#### Validation Check: Traffic Actually Flows Through the Mesh

A real incident-data query from Flask to PostgreSQL succeeds, and `linkerd viz stat pods -n default` shows non-zero request counts with a healthy success rate — not just "pods are running."

#### Validation Check: Ansible Role Is Idempotent

Two consecutive runs of `ansible-playbook -i ansible/inventory ansible/site.yml` — the second run reports `changed=0` for the Linkerd role's steady-state tasks.

---

### Deliverables

- [ ] Linkerd control plane installed and passing `linkerd check`
- [ ] Flask deployment meshed (`linkerd-proxy` sidecar present, healthy startup logs)
- [ ] PostgreSQL deployment meshed (`linkerd-proxy` sidecar present, healthy startup logs)
- [ ] mTLS verified via `linkerd identity` and proxy logs, not just assumed
- [ ] End-to-end incident-data query succeeds through the meshed connection
- [ ] `week-11/ansible/roles/linkerd/tasks/main.yml` installs and verifies the mesh, using the resolved (non-root) `KUBECONFIG` path
- [ ] `docs/sprint-11-retrospective.md` (Notes section) completed with Linkerd version, meshed services, and baseline metrics

---

### Sprint Backlog: Preparing for Week 12

- **Story 3.1** — Add a Grafana datasource pointed at Linkerd's Prometheus metrics (your existing `kube-prometheus-stack` Grafana, NodePort `30080` — not a new Grafana instance)
- **Story 3.2** — Build a latency dashboard (P50/P95/P99) for Flask-to-PostgreSQL
- **Story 3.3** — Build a success-rate dashboard with error breakdown
- **Story 4.1** — Document how your existing Week 7 NetworkPolicy rules interact with meshed traffic
- **Story 4.2** — Draft a test NetworkPolicy that demonstrates blocking a meshed path on demand

---
