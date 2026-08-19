# Week 13 Environment Log

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 7  
**Week:** 13

## Environment Status at Start of Week

- Linkerd control plane: (operational / issues)
- Flask service: (meshed / not meshed)
- PostgreSQL service: (meshed / not meshed)
- Grafana dashboards: (ready for demo / incomplete)
- NetworkPolicy test scenarios: (documented / needs work)
- Ansible playbook: (all roles included / missing roles)

## Week 13 Build Progress

### Monday-Tuesday: Ansible Playbook Finalization

**Tasks:**
- [ ] Review Weeks 1-9 Ansible roles in site.yml
- [ ] Verify Linkerd role included in playbook
- [ ] Update Flask and PostgreSQL namespaces in Linkerd role variables
- [ ] Add any missing comments or documentation to playbook
- [ ] Verify file permissions and idempotency flags

**Status:** 

**Playbook Review Findings:**
- Total roles included: 
- Linkerd role position in playbook: 
- Tag coverage: 
- Any deprecated or broken roles: 

**Updates Made:**
- Linkerd role variables updated: (yes/no)
- Comments added to clarify integration: (yes/no)
- Error handling reviewed: (yes/no)

---

### Tuesday-Wednesday: Ansible Dry-Run Testing

**Tasks:**
- [ ] Run playbook in check mode (dry-run) without making changes
- [ ] Verify all tasks execute without errors in check mode
- [ ] Document any warnings or informational messages
- [ ] Confirm Linkerd role tasks would execute correctly

**Status:** 

**Dry-Run Command:**
```bash
ansible-playbook -i inventory ansible/site.yml --check
```

**Dry-Run Results:**
- Overall status: (passed / failed)
- Number of tasks: 
- Tasks with changes detected: 
- Failed tasks: (list any)
- Warnings: 

**Sample Output (first 50 lines):**
```
(paste dry-run output here)
```

**Issues Found and Resolved:**
1. Issue: 
   - Resolution: 
2. Issue: 
   - Resolution: 

---

### Wednesday-Thursday: Demo Script Preparation

**Tasks:**
- [ ] Create demo script with step-by-step commands
- [ ] Document expected outputs for each step
- [ ] Time each section of the demo
- [ ] Prepare fallback procedures for common issues

**Status:** 

**Demo Script Outline:**
1. Show Linkerd check output
   - Command: `linkerd check 2>/dev/null | tail -3`
   - Expected output: (describe)
   - Time: __ seconds

2. Show meshed traffic
   - Command: (describe Flask to PostgreSQL test)
   - Expected output: (describe)
   - Time: __ seconds

3. Display Grafana latency dashboard
   - Navigate to: (URL or dashboard name)
   - Explain: (what metrics are shown)
   - Time: __ seconds

4. Display Grafana success rate dashboard
   - Navigate to: (URL or dashboard name)
   - Explain: (what metrics are shown)
   - Time: __ seconds

5. Demonstrate NetworkPolicy blocking
   - Apply blocking policy: `kubectl apply -f test-blocking-policy.yaml`
   - Show Grafana success rate drop
   - Remove policy: `kubectl delete networkpolicy flask-to-postgres-block -n <namespace>`
   - Show recovery in Grafana
   - Time: __ seconds

**Total Demo Time:** __ minutes

**Fallback Procedures:**
- If Grafana unavailable: (plan)
- If NetworkPolicy demo fails: (plan)
- If meshed traffic down: (plan)

---

### Thursday: Demo Rehearsal

**Tasks:**
- [ ] Run through complete demo script with live cluster
- [ ] Time each section and adjust as needed
- [ ] Verify all commands execute correctly
- [ ] Test fallback procedures
- [ ] Practice presentation flow

**Status:** 

**Rehearsal Observations:**
- Actual demo time: __ minutes
- Sections that needed timing adjustment: 
- Commands that had issues: 
- Presentation clarity: (good / needs improvement / excellent)

**Timing Breakdown:**
| Step | Planned (sec) | Actual (sec) | Notes |
|------|---------------|-------------|-------|
| Linkerd check | | | |
| Meshed traffic test | | | |
| Latency dashboard | | | |
| Success rate dashboard | | | |
| NetworkPolicy demo | | | |
| **TOTAL** | | | |

---

## Ansible Playbook Status

**File:** `ansible/site.yml`

**Roles Included (in order):**
1. (list all roles from Weeks 1-9)
...
N. linkerd (Track 5)

**Linkerd Role Configuration:**
```yaml
- role: linkerd
  tags: [track5, challenge, networking]
  vars:
    flask_namespace: (value)
    postgres_namespace: (value)
```

**Variables Defined:**
- Linkerd namespace: 
- Flask namespace: 
- PostgreSQL namespace: 
- Any other track-specific variables: 

**Known Issues or Workarounds:**
- (list any)

---

## Demo Readiness Checklist

- [ ] Ansible playbook tested in check mode
- [ ] All tasks execute without errors
- [ ] Linkerd role properly integrated
- [ ] Demo script written and timed
- [ ] Grafana dashboards accessible
- [ ] NetworkPolicy test scenarios prepared
- [ ] Fallback procedures documented
- [ ] Team has rehearsed demo at least once

---

## Resource Usage (Current Cluster)

Capture at end of Week 13:
```bash
kubectl top nodes
kubectl top pods -n linkerd
kubectl top pods -n <flask-namespace>
kubectl top pods -n <postgres-namespace>
```

(paste output here)

---

## Known Issues and Workarounds

- Issue: 
  - Root cause: 
  - Workaround: 
  - Status: (open / resolved / will address in Week 14)

---

## Week 14 Preparation

**Cluster Wipe Procedure:**
- k3d cluster delete command: 
- Data backup: (any persistent data to preserve)
- Expected wipe time: __ minutes

**Rebuild Procedure:**
- k3d cluster create command: 
- Ansible playbook run: 
- Expected rebuild time: __ minutes
- Verification commands: 

**Demo Day Logistics:**
- Presentation time: 
- Demo environment: (live cluster / pre-recorded / hybrid)
- Equipment needed: (projector, network, etc.)
- Backup plan if cluster fails: 

---

## Sign-Off

- Date: 
- Recorded by: 
- Reviewed by: 
