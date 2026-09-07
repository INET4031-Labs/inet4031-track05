## Week 12: Core Build Continued — Grafana Dashboards and NetworkPolicy

**Sprint 6 (Continuation) | Asynchronous**

### Overview

Week 12 continues Sprint 6. With Linkerd installed and both services meshed, your team now makes that mesh *observable* and demonstrates that it plays well with the network controls you already built in Week 7. You'll wire Linkerd's Prometheus metrics into your existing Grafana instance and build two dashboards (latency, success rate), then write and test a pair of NetworkPolicy manifests that prove you can block — and selectively allow — meshed traffic to PostgreSQL on demand. This is the pairing that carries your Week 13 demo script: dashboards that visibly react when you apply and remove a policy.

### Learning Objectives

- Wire an existing Grafana instance to a new Prometheus metrics source without standing up a second monitoring stack
- Build Prometheus-query-backed dashboards for service-mesh latency percentiles and request success rate
- Write Kubernetes NetworkPolicy manifests that target the correct pod labels for your actual workloads
- Demonstrate, with live metrics, the difference between "the policy applied" and "the policy actually blocked traffic"
- Export dashboard configuration as JSON so it survives a Week 14 cluster rebuild

### Prerequisites

- Week 11 complete: Linkerd control plane healthy, Flask and PostgreSQL meshed and passing traffic
- Your existing Grafana instance (`kube-prometheus-stack`, namespace `monitoring`, deployed since Week 5) accessible
- Familiarity with your Week 7 NetworkPolicy rules

---

### Accessing Grafana

Grafana already exists in your cluster — it was deployed as part of the `kube-prometheus-stack` Helm release back in Week 5. You do **not** need to install or deploy a new Grafana instance for this track; you are adding a datasource and dashboards to the existing one.

- **URL:** `http://localhost:30080` (Grafana's Service is exposed as a NodePort on port `30080`)
- **Login:** username `admin`, password `changethis` (the placeholder value set in `prometheus-values.yaml`; never rotated in this lab environment)

If you'd rather work against `localhost:3000` (e.g., to match tooling or muscle memory from other labs), you can port-forward instead of using the NodePort directly:

```bash
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80
```

Then browse to `http://localhost:3000` with the same `admin` / `changethis` credentials.

---

### Part 1: Connect Grafana to Linkerd's Metrics

**Step 1.** Identify Linkerd's own Prometheus endpoint (Linkerd viz ships its own Prometheus instance scraping the mesh's proxies) and add it as a datasource in your existing Grafana — Configuration → Data Sources → Add data source.

**Step 2.** Test the connection, then confirm a basic query returns data before building dashboards on top of it:

```
up{job="linkerd-proxy"}
```

**Step 3.** Document the datasource name and endpoint in `docs/sprint-12-retrospective.md` under **Notes**.

---

### Part 2: Build the Latency and Success Rate Dashboards

**Decide as a team:** Linkerd's own `linkerd-viz` dashboards (imported wholesale) vs. hand-built panels tailored to Flask-to-PostgreSQL specifically. Either satisfies the acceptance criteria below — pick based on how much time your team wants to spend on dashboard polish vs. functional correctness this week.

**Latency dashboard** should show, at minimum:
- P50, P95, and P99 request latency, broken down by source and destination service
- A time series view over at least a 1-hour window, with a sensible refresh interval (30s is a reasonable default)
- Labels clear enough that someone unfamiliar with the track can read "Flask → PostgreSQL" off the panel without asking

**Success rate dashboard** should show, at minimum:
- Overall success rate as a percentage
- Error breakdown by type (connection errors, timeouts, non-2xx responses)
- A visible baseline so a viewer can tell "healthy" from "degraded" at a glance

**Step 1.** Build both dashboards against your new Linkerd datasource.

**Step 2.** Export each as JSON so they survive the Week 14 rebuild:
- `week-12/grafana/dashboards/linkerd-latency.json`
- `week-12/grafana/dashboards/linkerd-success-rate.json`

> **Enterprise Pattern:** Dashboards that only live in a running Grafana instance disappear the moment that instance is rebuilt. Exporting dashboard JSON and treating it as a build artifact — not tribal knowledge in someone's browser bookmarks — is what makes observability part of your infrastructure-as-code story instead of a one-off demo prop.

---

### Part 3: Test NetworkPolicy Against the Meshed Path

Two test policies already exist in `week-12/network-policies/`: `test-blocking-policy.yaml` and `test-allow-policy.yaml`. Both target PostgreSQL pods via `matchLabels: {app: db}` — matching this track's actual Deployment/Service label (not `app: postgres`). Read through both files before applying anything; understand what each one does and why the blocking policy's empty `ingress: []` is what makes it deny-all.

**Step 1.** Document your existing Week 7 NetworkPolicy rules and confirm they don't already conflict with meshed traffic — a stale `default-deny` without an explicit allow rule for the Linkerd proxy's control-plane traffic is a common surprise here.

**Step 2.** Apply the blocking policy and watch your Grafana success-rate dashboard. Give it a minute or two for metrics to update, then confirm the success rate visibly drops.

```bash
kubectl apply -f week-12/network-policies/test-blocking-policy.yaml
```

**Step 3.** Remove the blocking policy and confirm recovery:

```bash
kubectl delete networkpolicy flask-to-postgres-block -n default
```

**Step 4.** Apply the allow policy and confirm it produces the same healthy state as no policy at all — this is what proves fine-grained control, not just an on/off switch:

```bash
kubectl apply -f week-12/network-policies/test-allow-policy.yaml
```

**Step 5.** Document the before/after timeline (when applied, when the dashboard reacted, when it recovered) in `docs/sprint-12-retrospective.md` under **Notes**. This timeline becomes your Week 13 demo script's timing reference.

---

### Validation Checks

**QA runs all validation checks.** Confirm each of these against the live cluster and a working Grafana session — not from a description of what should happen.

#### Validation Check: Grafana Datasource Connectivity

"Test Data Source" in Grafana returns success for the Linkerd Prometheus datasource, and a sample query returns non-empty results.

#### Validation Check: Dashboards Display Real Data

Both the latency and success-rate dashboards load and show data for actual Flask-to-PostgreSQL traffic — not "No data" panels — within a couple of minutes of opening them.

#### Validation Check: NetworkPolicy Labels Match Real Pods

`kubectl get pods -n default --show-labels` confirms the PostgreSQL pod carries `app: db`. `week-12/network-policies/test-blocking-policy.yaml` and `test-allow-policy.yaml` both select on `app: db` — if these ever drift out of sync, the "blocking" demo silently does nothing.

#### Validation Check: Blocking Demonstrably Blocks

Applying `test-blocking-policy.yaml` produces a visible drop in the Grafana success-rate dashboard within 1-2 minutes; removing it produces a visible recovery within 1-2 minutes.

---

### Deliverables

- [ ] Grafana datasource for Linkerd Prometheus metrics configured and verified
- [ ] Latency dashboard (P50/P95/P99, Flask-to-PostgreSQL) built and exported to `week-12/grafana/dashboards/linkerd-latency.json`
- [ ] Success rate dashboard (with error breakdown) built and exported to `week-12/grafana/dashboards/linkerd-success-rate.json`
- [ ] Week 7 NetworkPolicy rules documented and confirmed compatible with meshed traffic
- [ ] `test-blocking-policy.yaml` and `test-allow-policy.yaml` applied, tested, and confirmed to target the real `app: db` pod label
- [ ] Before/after blocking timeline documented in `docs/sprint-12-retrospective.md` (Notes section)

---

### Sprint Closure

At the end of Week 12, Sprint 6 closes. Fill in `docs/sprint-12-retrospective.md` and `docs/qa-report-12.md` to reflect on the core build phase — what went right installing and observing the mesh, and what you'd do differently.

---

### Sprint Backlog: Preparing for Week 13

- **Story 5.1** — Confirm the Linkerd Ansible role (from Week 11) is fully idempotent and passes a `--check` dry-run cleanly
- **Story 5.2** — Fold namespace annotation and pod-restart steps into the role if not already automated
- **Story 6.2 (start)** — Draft the demo script: which commands, in what order, with what expected output

---
