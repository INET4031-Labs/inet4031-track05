## Week 10: Challenge Kickoff and Architecture Decision

**Sprint 5 (Continued) | Synchronous Challenge Kickoff**

### Overview

Week 10 opens Challenge Track 5: Network and Cloud Infrastructure. Your team takes the incident data platform you built in Weeks 1-9 — Flask, PostgreSQL, nginx, and the Week 7 NetworkPolicy rules, all running in the `default` namespace of your `myapp` k3d cluster — and extends it with a service mesh. Over Weeks 11-14 you will install Linkerd, mesh Flask and PostgreSQL for automatic mTLS, visualize service-to-service metrics in Grafana, and demonstrate fine-grained NetworkPolicy control on meshed traffic. Week 10 itself is a planning week: no Linkerd installation happens yet. Instead, your team makes the architecture decisions that Weeks 11-14 depend on, and turns the track's Epics into a sprint-ready backlog. After this week, you will have a documented architecture decision, a topology sketch of what gets meshed and in what order, and a backlog your team can execute against without re-litigating basic questions mid-sprint.

### Learning Objectives

- Explain what a service mesh (mTLS, latency/success-rate telemetry, traffic splitting) adds on top of the Kubernetes-native NetworkPolicy controls built in Week 7
- Evaluate Linkerd installation and service-meshing strategy tradeoffs and record a decision with rationale, not just a choice
- Confirm Linkerd's compatibility with your team's existing k3d Kubernetes version before committing engineering time to it
- Translate an Epic/Story-level backlog into a sprint plan with dependencies and priorities your team can actually execute
- Close out Sprint 5 on the Week 1-9 core platform and open Sprint 6 with a clear Definition of Ready

### Prerequisites

- Completed Weeks 1-9 (k3d cluster `myapp`, the incident data platform, and Week 7 NetworkPolicy rules) available and healthy — either in this repo's history or as a sibling `week-09` repository under `Student Repositories/`
- `kubectl` access to your team's k3d cluster
- Familiarity with your own Week 7 NetworkPolicy rules and Week 5 Prometheus/Grafana stack (`kube-prometheus-stack`, namespace `monitoring`) — you'll be building on both, not replacing them

### Sprint 5 Kickoff — Challenge Briefing

This session is synchronous: get the team in a room (or a call) together. Walk through the challenge goal as a group, argue about the architecture questions below out loud, and leave the session with decisions written down — not just discussed. A decision that only exists in someone's head doesn't survive to Week 13 when a different teammate is running the Ansible dry-run.

---

### Part 1: Understand the Challenge Goal and Current State

Before deciding anything, get the team aligned on two things: what Linkerd adds, and what you're starting from.

**Step 1.** As a team, read through this track's `README.md` goal statement and the Epic list in `backlog.md`. Make sure everyone can answer: why a service mesh, on top of NetworkPolicy we already have?

**Step 2.** Inventory what's actually running before you touch anything. At minimum, confirm:

```bash
k3d cluster list                       # cluster "myapp" running
kubectl get pods -n default            # flask, db, nginx pods healthy
kubectl get networkpolicy -n default   # Week 7 rules still in place
kubectl get pods -n monitoring         # kube-prometheus-stack (Grafana/Prometheus) healthy
```

Record the output in `docs/sprint-10-retrospective.md` under **Notes**, labeled "Environment Status at Start of Week." This snapshot is what you compare against after the Week 14 rebuild to prove the automation actually reproduces this state.

> **Enterprise Pattern:** Real platform teams don't add a service mesh to "see what happens" — they baseline current behavior first (latency, error rate, existing security posture) so they have something to compare against once the mesh is live. Your Week 10 environment snapshot is that baseline.

---

### Part 2: Make and Document Architecture Decisions

This track intentionally leaves several implementation choices to your team — there is no single "correct" Linkerd deployment shape, and part of the challenge is defending the one you pick. Work through `week-10/adr.md` (currently a TODO template) and fill in a real decision for each of the following. Don't leave any section as a placeholder — a half-filled ADR is not a decision.

**Decide as a team:**
- **Installation approach** — Helm install vs. the Linkerd CLI's own `linkerd install | kubectl apply -f -` path. Both are legitimate; document which one your Ansible role in Week 11 will automate and why.
- **Control plane sizing** — HA mode (multiple replicas of each control-plane component) vs. minimal/single-replica mode. Given this is a teaching cluster with limited resources, most teams choose minimal — but justify it.
- **Meshing phasing** — mesh Flask and PostgreSQL together in one pass, or mesh one service first, verify it's healthy, then mesh the second? A staged rollout is safer and easier to debug; a single pass is faster. Either is defensible.
- **Dashboard and alert strategy** — what KPIs matter most for your Week 12 Grafana work (latency percentiles, success rate, both), and what would trigger an alert in a real environment?

**What's already fixed for you** (do not re-decide these — they're set by your Week 1-9 baseline and this track's own scaffolding, and Weeks 11-14 assume them): your k3d cluster is named `myapp`; Flask and PostgreSQL both run in the single `default` namespace (not separate namespaces — there's no reason to split them for this track); your existing Grafana instance (deployed via `kube-prometheus-stack` since Week 5) lives in the `monitoring` namespace and is reachable at NodePort `30080`; you are adding a datasource and dashboards to it, not deploying a second Grafana.

**Step 1.** Fill in every section of `week-10/adr.md`: Context, Decision, Options Considered, Rationale, Consequences, and an Ansible Integration Plan sketch (which role, what it needs to automate).

**Step 2.** Sketch your service mesh topology — which services get the `linkerd.io/inject: enabled` annotation, in the `default` namespace, and in what order. A whiteboard photo or a simple diagram is enough; this becomes your Week 13 demo narrative.

---

### Part 3: Build the Sprint 6 Backlog

`backlog.md` already gives you Epics 1-6 mapped across Weeks 11-14, each with Stories, acceptance criteria, and dependencies. Your job this week isn't to invent a backlog from scratch — it's to make it yours: confirm priorities, adjust story point estimates, and make sure every Week 11 story has no unresolved dependency before Sprint 6 opens.

**Step 1.** Read through Epics 1 and 2 (Linkerd control plane installation, service meshing) closely — these are Week 11's Must-Have items and block everything after them.

**Step 2.** As a team, confirm or revise the Priority and Dependencies section at the bottom of `backlog.md`. If your architecture decisions from Part 2 change a story's scope (e.g., you chose manual kubectl apply over Helm), update the story's Task list to match.

**Step 3.** Assign the team roles called out in the acceptance criteria — a Network/Infrastructure lead, an Ansible/Automation lead, and a Verification/Testing lead — and record them in `docs/sprint-10-retrospective.md` under **Notes**.

> **Enterprise Pattern:** A backlog that isn't revisited after the template is created is decoration, not planning. Real sprint planning always includes a pass where the team pressure-tests estimates and dependencies against what they now know about the environment — which is exactly what Part 1's inventory step was for.

---

### Validation Checks

**QA runs all validation checks.** Before Sprint 5 closes, the Verification/Testing lead confirms the following — not by asking "did we do this?" but by opening the files and checking.

#### Validation Check: Architecture Decision Is Actually Decided

Open `week-10/adr.md`. Every `**TODO:**` placeholder should be replaced with real content. A decision document that still says "TODO: State the architecture/approach chosen" has not made a decision.

#### Validation Check: Environment Snapshot Captured

Open `docs/sprint-10-retrospective.md`. The "Notes" section should contain a labeled "Environment Status at Start of Week" entry with real output from Part 1's commands — cluster name, pod status, existing NetworkPolicy names — not a blank or missing entry.

#### Validation Check: Backlog Is Sprint-Ready

Open `backlog.md`. Every Week 11 story (Epics 1 and 2) should have no `Dependencies: None (ready to start Week 11)` items left unverified, and the "Open Questions" section should either be empty or contain real, answered questions — not the placeholder prompt.

---

### Deliverables

- [ ] Architecture decision document (`week-10/adr.md`) fully completed — no TODO placeholders remain
- [ ] Service mesh topology sketch (which services, which namespace, which order)
- [ ] Sprint 6 backlog reviewed and confirmed in `backlog.md` (priorities, estimates, dependencies)
- [ ] Environment status snapshot recorded in `docs/sprint-10-retrospective.md` (Notes section)
- [ ] Team roles assigned (Network/Infrastructure lead, Ansible/Automation lead, Verification/Testing lead)
- [ ] Sprint 5 retrospective closed (`docs/sprint-10-retrospective.md`) and QA sign-off recorded (`docs/qa-report-10.md`)

---

### Sprint Backlog: Preparing for Week 11

The Scrum Master should open the following tickets, pulled directly from `backlog.md` Epics 1 and 2, before Week 11 begins:

- **Story 1.1** — Install Linkerd CLI and control plane; confirm `linkerd check` passes pre-install checks
- **Story 1.2** — Configure and verify automatic mTLS and certificate rotation
- **Story 2.1** — Annotate the `default` namespace and mesh the Flask deployment
- **Story 2.2** — Mesh the PostgreSQL deployment
- **Story 2.3** — Verify end-to-end meshed traffic (Flask → PostgreSQL) with `linkerd check` and a live incident query

---
