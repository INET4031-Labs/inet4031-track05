# Week 13 Acceptance Criteria

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 7  
**Week:** 13

## Finalization and Demo Preparation

### Ansible Playbook Integration

- [ ] Weeks 1-9 roles all present in site.yml
  - All existing roles still functional
  - No role was removed or broken
  - File path: `ansible/site.yml`

- [ ] Linkerd role integrated into playbook
  - Role included in site.yml after all existing roles
  - Proper role name and path: `roles/linkerd`
  - Tags applied: `[track5, challenge, networking]`

- [ ] Playbook variables defined
  - Flask namespace specified in role variables or site.yml
  - PostgreSQL namespace specified in role variables or site.yml
  - Linkerd namespace documented (typically `linkerd` or `linkerd-system`)

- [ ] Playbook documentation complete
  - Comments explain Linkerd role purpose
  - Comments explain key deployment steps
  - Variable descriptions documented

#### Acceptance Criteria Detail

Site.yml should include:
```yaml
- role: linkerd
  tags: [track5, challenge, networking]
  vars:
    flask_namespace: <your-flask-namespace>
    postgres_namespace: <your-postgres-namespace>
```

---

### Ansible Dry-Run Verification

- [ ] Playbook runs without errors in check mode
  - Command: `ansible-playbook -i inventory ansible/site.yml --check`
  - Exit code: 0
  - No failed tasks

- [ ] Linkerd role dry-run executes correctly
  - Tasks show `[CHECK MODE] - ...` in output
  - No actual changes made to cluster
  - All tasks show they would execute successfully

- [ ] Warnings reviewed and documented
  - Any deprecation warnings noted
  - Any informational messages understood
  - No blocking issues identified

#### Acceptance Criteria Detail

Dry-run output should show:
- All tasks in check mode without errors
- Specific Linkerd tasks (CLI install, control plane deploy, annotation, etc.)
- Successful completion with summary like:
  ```
  PLAY RECAP
  <host> : ok=<n> changed=0 unreachable=0 failed=0
  ```

---

### Demo Script Preparation

- [ ] Demo script written with step-by-step commands
  - Each step documented with command and expected output
  - Timing for each section recorded
  - Total demo time < 10 minutes

- [ ] Linkerd verification included in demo
  - Command: `linkerd check 2>/dev/null | tail -3`
  - Expected output documented
  - Fallback if check fails documented

- [ ] Grafana dashboards prepared for demo
  - Latency dashboard accessible and displaying data
  - Success rate dashboard accessible and displaying data
  - Both dashboards bookmarked or pre-loaded

- [ ] NetworkPolicy demo scenario documented
  - Blocking policy YAML prepared
  - Allow policy YAML prepared
  - Expected Grafana changes documented
  - Commands to apply/remove policies listed

- [ ] Meshed traffic verification included
  - Test command (e.g., query incident data through Flask)
  - Expected result documented
  - Failure recovery plan documented

#### Acceptance Criteria Detail

Demo script format:
```
Step 1: Verify Linkerd Installation
Command: linkerd check 2>/dev/null | tail -3
Expected: 
  Status check results are [OK]
Time: 30 seconds

Step 2: Test Flask to PostgreSQL Traffic
Command: (your test command)
Expected: (data returns successfully)
Time: 30 seconds

...
```

---

### Demo Rehearsal and Timing

- [ ] Complete demo run-through performed
  - Live cluster used for rehearsal
  - All commands tested and working
  - Timing measured for each section

- [ ] Demo timing acceptable for presentation
  - Total time fits within allocated slot (typically 10-15 minutes)
  - Sections appropriately paced
  - No step takes longer than expected

- [ ] Presentation flow reviewed
  - Logical progression from infrastructure to metrics to policy
  - Transition between steps smooth
  - Audience engagement points identified

- [ ] Fallback procedures documented
  - If Grafana unavailable: (plan)
  - If Linkerd check fails: (plan)
  - If NetworkPolicy demo fails: (plan)
  - If meshed traffic down: (plan)

#### Acceptance Criteria Detail

Rehearsal checklist:
- [ ] All demo commands execute without errors
- [ ] Grafana dashboards respond quickly to access
- [ ] NetworkPolicy blocking/allowing works as demonstrated
- [ ] Timing allows for Q&A at end
- [ ] Presenter feels comfortable with flow

---

### Cluster Wipe and Rebuild Procedures

- [ ] k3d cluster deletion procedure documented
  - Command to delete cluster: 
  - Expected time for deletion: __ minutes
  - Backup procedure if data preservation needed: 

- [ ] k3d cluster creation procedure documented
  - Command to create cluster: 
  - Expected time for cluster creation: __ minutes
  - Any cluster configuration (CPU, memory, registry): 

- [ ] Ansible full rebuild procedure documented
  - Command to run full playbook: `ansible-playbook -i inventory ansible/site.yml`
  - Expected time for rebuild: __ minutes
  - Verification commands after rebuild: 

#### Acceptance Criteria Detail

Rebuild testing (optional for Week 13, required for Week 14):
- [ ] Can delete cluster: `k3d cluster delete <cluster-name>`
- [ ] Can recreate cluster: `k3d cluster create <cluster-name> [options]`
- [ ] Can run playbook to rebuild: `ansible-playbook -i inventory ansible/site.yml`
- [ ] All services operational after rebuild

---

### Documentation Completeness

- [ ] Week 13 environment log filled out
  - Ansible playbook review documented
  - Dry-run results captured
  - Demo script attached or referenced
  - Rehearsal observations recorded

- [ ] Demo script finalized and saved
  - Location: `week-13/demo-script.md` or similar
  - All commands included
  - Timing documented
  - Fallback procedures included

- [ ] Grafana dashboards exported and saved
  - Latency dashboard: `week-12/grafana/dashboards/linkerd-latency.json`
  - Success rate dashboard: `week-12/grafana/dashboards/linkerd-success-rate.json`
  - Both files should be ready for import into fresh Grafana on rebuild

- [ ] NetworkPolicy test files finalized
  - Blocking policy: `week-12/network-policies/test-blocking-policy.yaml`
  - Allow policy: `week-12/network-policies/test-allow-policy.yaml`
  - Commands to apply/remove policies documented

---

### Team Readiness for Demo Day

- [ ] All team members have reviewed demo script
- [ ] Demo presenter(s) have rehearsed at least once
- [ ] Backup presenter identified in case primary unavailable
- [ ] Fallback procedures communicated to team
- [ ] Roles for demo day clearly assigned
  - Primary presenter: 
  - Technical support (cluster management): 
  - Questioner (prepared for Q&A): 

---

### Failure Criteria

- [ ] Ansible playbook fails in check mode
- [ ] Linkerd role has errors or is not included
- [ ] Demo script missing or incomplete
- [ ] Demo rehearsal shows timing > 15 minutes
- [ ] Any critical fallback scenario not documented
- [ ] Team not prepared for demo day

---

## Dependencies

- Week 11-12 deliverables met (Linkerd installed, dashboards working, policy testing complete)
- Ansible playbook with all Weeks 1-9 roles functional
- Live k3d cluster available for rehearsal
- Grafana instance accessible

---

## Deliverables Summary

By end of Week 13:

1. Ansible playbook integrated with Linkerd role and tested in check mode
2. Demo script written, timed, and rehearsed (< 10 minutes)
3. Grafana dashboards bookmarked and ready for presentation
4. NetworkPolicy blocking/allow demo scenario documented
5. Cluster wipe and rebuild procedures documented
6. Team rehearsed and ready for Demo Day
7. Fallback procedures documented for common issues
8. Week 13 environment log complete

---

## Demo Day Readiness Checklist

Before Week 14 Demo Day, verify:

- [ ] k3d cluster healthy and accessible
- [ ] Ansible playbook in git and ready to run
- [ ] Demo script printed or on second screen
- [ ] Grafana dashboards pre-loaded or bookmarked
- [ ] NetworkPolicy YAML files ready to apply
- [ ] Fallback procedures reviewed with team
- [ ] Presentation slides/materials (if required) prepared
- [ ] Live demonstration rehearsed within 24 hours of Demo Day

---

## Notes

- Week 13 is the last major preparation week; Week 14 is execution and demo
- All issues should be resolved by end of Week 13; escalate any blockers immediately
- Demo script should be practiced by primary presenter multiple times for confidence
- Ensure backup plan for each demo scenario in case of unexpected issues
