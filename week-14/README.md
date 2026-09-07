## Week 14: Demo Day — Cluster Rebuild and Presentation

**Sprint 7 (Continuation) | Synchronous**

### Overview

Week 14 is Demo Day, and the culmination of the entire Network and Cloud Infrastructure track. Your k3d cluster gets wiped completely, your Ansible playbook rebuilds the whole environment from scratch — Weeks 1-4 baseline plus the Week 11 Linkerd role — and your team demonstrates live that the service mesh, observability, and NetworkPolicy enforcement all come back working, with zero manual steps. This is the week where "infrastructure as code" stops being a phrase in your backlog and becomes something you watch happen in real time in front of an audience.

### Learning Objectives

- Execute a full environment teardown and automated rebuild under time pressure, with an audience watching
- Verify a rebuilt service mesh, dashboard stack, and NetworkPolicy configuration against the baseline you captured in Weeks 11-13
- Present a technical system clearly to an audience that hasn't been living in your repo for five weeks
- Recover gracefully from a live failure using a rehearsed fallback plan

### Prerequisites

- Week 13 complete: Ansible dry-run passed and confirmed idempotent, demo script rehearsed, fallback materials ready
- All code committed to Git
- A live `myapp` k3d cluster and cluster host available for the wipe-and-rebuild

---

### The Demo Process

#### Cluster Wipe (Beginning of Week 14)

The cluster is completely wiped and reset to baseline state — no Linkerd, no mesh, no dashboards, no services meshed. This is the honest starting point: the same "clean slate" your Ansible playbook is supposed to be able to build on from nothing.

```bash
k3d cluster delete myapp
k3d cluster list   # confirm it's gone
```

> **Troubleshooting:** If the cluster re-create step hangs and
> `docker logs k3d-myapp-server-0` shows repeated `"too many open files"` /
> `"error creating fsnotify watcher"` errors, the host has run out of inotify watch
> instances — a common RHEL default (`fs.inotify.max_user_instances=128`) is too low
> for a fresh k3s cluster. Fix: `sudo sysctl -w fs.inotify.max_user_instances=1024`,
> then retry cluster creation.

#### Ansible Playbook Rebuild

```bash
ansible-playbook -i ansible/inventory ansible/site.yml
```

This single command should install the Weeks 1-4 baseline, stand up the `myapp` cluster, deploy the app stack and OpenTofu-managed Flask resources, and then install and configure the Linkerd service mesh — with no manual steps in between. If it isn't fully automated by now, that's the gap Week 13 was supposed to have already found; treat any surprise here as a fallback-plan trigger, not something to debug live.

#### Post-Rebuild Verification

Before presenting, confirm each of these against the freshly rebuilt cluster:

1. `linkerd check` passes all checks
2. Grafana is reachable at `http://localhost:30080` (NodePort) — or via `kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80` for `http://localhost:3000` — logging in with `admin` / `changethis`
3. Both dashboards (latency, success rate) display live data for Flask-to-PostgreSQL traffic (allow a couple of minutes post-rebuild for metrics to populate)
4. Flask and PostgreSQL are meshed with mTLS confirmed
5. NetworkPolicy rules are enforced correctly: `test-blocking-policy.yaml` and `test-allow-policy.yaml` both target the real `app: db` pod label and behave as expected

---

### Demo Presentation

Follow the script your team wrote and rehearsed in Week 13. The suggested flow:

1. **Cluster Wipe:** show the clean starting state (or describe what was wiped, if done ahead of the live session for time)
2. **Ansible Playbook:** run the rebuild (live if your Week 13 timing supports it within the demo window; pre-recorded as fallback)
3. **Linkerd Verification:** `linkerd check` output, explained
4. **Service Meshing:** demonstrate mTLS between Flask and PostgreSQL — proxy logs or `linkerd identity` output
5. **Grafana Access:** show the dashboards live at `http://localhost:30080`
6. **Dashboard Analysis:** walk through the latency and success-rate panels
7. **NetworkPolicy Demo:** apply the blocking policy, show the success-rate dashboard react, remove it, show recovery, then apply the allow policy
8. **Automation Story:** tie it back to the single Ansible command that did all of this

### Success Criteria

- [ ] Ansible playbook runs with zero manual intervention
- [ ] Linkerd mesh comes up automatically
- [ ] Grafana dashboards are accessible (`http://localhost:30080`) and displaying data
- [ ] Flask and PostgreSQL services are meshed
- [ ] NetworkPolicy is enforced correctly, targeting the real `app: db` label
- [ ] `linkerd check` passes all checks
- [ ] Demo presentation is clear and stays within the timed window
- [ ] Team can explain the full infrastructure, not just narrate a script

---

### What If Something Goes Wrong?

Use the fallback materials your team prepared in Week 13:

- Pre-recorded demo showing the full infrastructure deployment
- Screenshots of working dashboards and mesh status
- Documented proof (from Week 13's dry-run) that everything works end to end

If the live playbook run fails during the demo, switch to the pre-recorded or screenshot evidence rather than debugging live. The point being demonstrated is that the infrastructure is fully automated and reproducible — that claim is just as well-supported by yesterday's successful dry-run as by a live run that happens to work.

### Team Roles During Demo

- **Network Engineer:** explain Linkerd mesh architecture and mTLS
- **Infrastructure/DevOps:** explain Ansible automation and the rebuild sequence
- **QA/Testing:** verify all post-rebuild checks pass, in real time
- **Optional 4th Member:** support as needed, handle Q&A

---

### Validation Checks

**QA runs all validation checks**, live, immediately after the rebuild and before the presentation continues.

#### Validation Check: Full Stack Post-Rebuild

`kubectl get pods --all-namespaces` shows Linkerd control-plane pods, Flask and PostgreSQL pods (2/2 containers each, sidecar included), and the `kube-prometheus-stack` pods — all Running.

#### Validation Check: Mesh Health

`linkerd check 2>/dev/null | tail -3` reports all checks passed.

#### Validation Check: Meshed Connectivity

A live incident-data query from Flask to PostgreSQL succeeds through the mesh.

#### Validation Check: Dashboards Populated

Both Grafana dashboards show non-empty data for the rebuilt environment within a few minutes of the rebuild completing.

#### Validation Check: NetworkPolicy Demo Reproducible

Applying and removing the test policies produces the same visible Grafana reaction as it did in Week 13's rehearsal.

---

### Deliverables

By the end of Week 14, you should have:

1. **Successful Cluster Rebuild:** Ansible playbook builds the full infrastructure from scratch
2. **Successful Demo Presentation:** the team demonstrates the service mesh infrastructure live
3. **All Verifications Passing:** Linkerd, Grafana dashboards, and NetworkPolicy all confirmed working post-rebuild
4. **Sprint 7 Retrospective Complete:** team reflection on Weeks 13-14, filed as `docs/sprint-14-retrospective.md`
5. **QA Sign-Off:** recorded in `docs/qa-report-14.md`

---

### Track Wrap-Up

This is the last week of Challenge Track 5 — there is no Week 15. Before closing out:

- Fill in `docs/sprint-14-retrospective.md` with the team's reflection on Weeks 13-14 and the track as a whole
- Fill in `docs/qa-report-14.md` with QA's sign-off on Demo Day results
- Make sure `docs/sprint-14-retrospective.md` (Notes section) captures the actual demo timeline, command outputs, and any issues encountered and how they were resolved — this is the artifact that proves what happened, independent of how the live demo felt in the room
- Confirm every deliverable across Weeks 10-14 is committed to Git and the repository is in the state you want graded

**Reflection Questions:**

1. How well did the Ansible automation actually work — end to end, not just in the parts you rehearsed most?
2. Was the demo successful, and if it needed the fallback plan, what triggered that?
3. What would your team do differently if you started this track again?
4. What did you learn about service meshes, Kubernetes networking, and infrastructure automation that you didn't know at Week 10?
5. Looking at the whole arc from Week 1's baseline setup to today's meshed, observable, policy-enforced platform — what are you proudest of?

Congratulations on completing the Network and Cloud Infrastructure challenge track.

---
