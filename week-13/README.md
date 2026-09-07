## Week 13: Finalization and Demo Preparation

**Sprint 7 | Synchronous**

### Overview

Week 13 shifts back to synchronous work. With Linkerd installed, both services meshed, dashboards live, and NetworkPolicy tests passing, your team's job this week is to prove the whole thing is reproducible — not just working right now, on the cluster you've been iterating on all along. You'll dry-run the full Ansible playbook (`ansible/site.yml`, which now includes Weeks 1-4's baseline roles plus the Week 11 `linkerd` role) against a clean cluster, verify it's idempotent, polish your Grafana dashboards, and rehearse the Demo Day script end to end. Week 14 has no room for first-time surprises — anything that's going to break should break this week, in front of your own team, not in front of the class.

### Learning Objectives

- Validate that a multi-role Ansible playbook rebuilds a non-trivial environment (Weeks 1-9 baseline + Linkerd mesh) with zero manual intervention
- Distinguish a playbook that "ran without errors" from one that's actually idempotent (`changed=0` on a second run)
- Turn a working system into a timed, rehearsed demo script that survives a live failure
- Set up a working reference to your team's own Week 9 repository so this week's validation scripts can run

### Prerequisites

- Weeks 11-12 complete: Linkerd meshed, dashboards live, NetworkPolicy tests passing
- `myapp` k3d cluster available for a dry-run rebuild (or the ability to stand up a throwaway one)
- Your team's own Week 9 repository accessible as described below

---

### Set Up the Week 9 Reference

This week's validation checks reference scripts and content from your own Weeks 1-9 work. Since this track repo doesn't copy that work in, link to it instead — pointing at your own team's sibling repository (there is no shared instructor solved-repo checkout for this; each team references their own prior work):

**On Linux/macOS:**
```bash
ln -s ../../week-09 week-09-ref
```

**On Windows (PowerShell with admin/developer mode):**
```powershell
New-Item -ItemType SymbolicLink -Path "week-09-ref" -Target "..\..\week-09"
```

Or use `mklink /D` in CMD:
```bash
mklink /D week-09-ref "..\..\week-09"
```

(These paths are relative to `week-13/`: up one level to the track repo root, up one more to `Student Repositories/`, then into your team's `week-09` repo.)

---

### Part 1: Ansible Dry-Run on a Clean Cluster

The whole point of Demo Day is that `ansible-playbook -i inventory ansible/site.yml` rebuilds everything from nothing. This week is where you find out if that's actually true.

**Step 1.** Start from a clean k3d cluster — wipe and recreate if your current one has drifted from what the playbook would produce.

**Step 2.** Run the full playbook and record the output:

```bash
ansible-playbook -i ansible/inventory ansible/site.yml
```

**Step 3.** Verify the result, not just the exit code:
- `linkerd check` passes
- Grafana dashboards (from Week 12) are accessible and showing data
- Flask and PostgreSQL are both meshed and can reach each other

**Step 4.** Run the playbook a second time. This is the idempotency check — the second run should report `changed=0` for tasks that already reflect the desired state. Any task that shows `changed` on the second run is either not idempotent or its `changed_when` condition is wrong; fix it now.

**Step 5.** Document total execution time in `docs/sprint-13-retrospective.md` under **Notes** — you'll need this number for your Week 14 demo timing.

> **Enterprise Pattern:** "It worked when I ran it" and "it's idempotent" are different claims. Production configuration-management pipelines are graded on the second one — a playbook that breaks or duplicates resources on a re-run is a liability the moment two engineers touch the same environment in the same day.

---

### Part 2: Polish the Grafana Dashboards

Revisit the latency and success-rate dashboards from Week 12 with a demo audience in mind, not just a functional one.

**Step 1.** Check that panel titles, axis labels, and legends are legible at presentation resolution — a laptop screen shared over video call is less forgiving than your own monitor.

**Step 2.** Re-export both dashboards' JSON (`week-12/grafana/dashboards/linkerd-latency.json`, `linkerd-success-rate.json`) if you made any changes, so the exported version matches what you'll actually demo.

---

### Part 3: Test NetworkPolicy Enforcement Live

Re-run the Week 12 blocking/allow sequence one more time against the freshly-rebuilt cluster, timing it as if it were the real demo:

```bash
kubectl apply -f week-12/network-policies/test-blocking-policy.yaml
# watch Grafana success rate drop
kubectl delete networkpolicy flask-to-postgres-block -n default
# watch it recover
kubectl apply -f week-12/network-policies/test-allow-policy.yaml
```

If the labels or timing don't behave the way your demo script assumes, fix the script now — not live on stage.

---

### Part 4: Write and Rehearse the Demo Script

**Step 1.** Draft a demo script — step, command, expected output, timing — for each of these beats: cluster wipe, Ansible rebuild, Linkerd verification, mTLS demonstration, Grafana dashboards, NetworkPolicy block/allow, wrap-up. Aim for 5-7 minutes total; leave room for Q&A within a 15-minute slot.

**Step 2.** Assign roles: who presents which section, who runs the keyboard, who's the backup presenter if someone can't make it.

**Step 3.** Decide as a team whether the demo runs live or from a recording as a fallback, and prepare that fallback now (screenshots or a screen recording of a successful run) rather than during Week 14 itself.

**Step 4.** Run through the entire demo at least once, live, with timing. Fix anything that surprises you.

---

### Validation Checks

**QA runs all validation checks.** These are the gate before your team can call itself demo-ready.

#### Validation Check: Playbook Runs Clean

`ansible-playbook -i inventory ansible/site.yml` against a wiped cluster completes with `failed=0` and produces a fully working environment (verified per Part 1, Step 3).

#### Validation Check: Playbook Is Idempotent

A second consecutive run reports `changed=0` for steady-state tasks.

#### Validation Check: Demo Script Is Realistic

A live, timed run-through of the full demo script completes within the target window, using the actual commands in the script — not a paraphrase of them.

#### Validation Check: Fallback Materials Exist

Screenshots or a recording of a successful run exist and are accessible, in case the live demo hits an issue on the day.

---

### Deliverables

By the end of Week 13, you should have:

1. **Polished Grafana Dashboards:** production-ready formatting, re-exported JSON if changed
2. **Ansible Dry-Run Complete:** playbook tested on a clean cluster, idempotence verified (`changed=0` on second run)
3. **NetworkPolicy Testing Complete:** blocking and allow scenarios both tested live post-rebuild
4. **Demo Rehearsal Done:** full run-through completed with timing, roles assigned
5. **Fallback Materials Ready:** screenshots or recording available
6. **Demo Day Ready:** team confident, contingency plans in place

---

### Sprint Closure Preparation

At the end of Week 13, prepare to close out Week 14 (which is Demo Day itself). Make sure:

- All code is committed to Git
- All documentation is complete: the Deliverables checklist above, `docs/sprint-13-retrospective.md`, and `docs/qa-report-13.md`
- The team is confident in the demo
- Contingency plans are in place and everyone knows what they are

---

### Next Week: Demo Day

Week 14 is Demo Day. The cluster will be wiped, Ansible will rebuild everything from scratch, and the team will present the results live. Everything you verified this week is what makes that possible.

Good luck with the demo — you've built a real service mesh infrastructure on top of the platform you started in Week 1.

---
