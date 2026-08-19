# Week 13: Finalization and Demo Preparation

**Sprint 7 | Synchronous**

---

## IMPORTANT: Week 9 Dependency

**Before proceeding with this week's validation loop, ensure your Week 9 repository is available.** This week's check scripts reference scripts from your Weeks 1-9 work.

### Set up Week 9 Symlink

Create a symlink to your Week 9 repository:

**On Linux/macOS:**
```bash
ln -s ../Solved\ Repositories/week-09 week-09-ref
```

**On Windows (PowerShell with admin/developer mode):**
```powershell
New-Item -ItemType SymbolicLink -Path "week-09-ref" -Target "..\Solved Repositories\week-09"
```

Or use `mklink /D` in CMD:
```bash
mklink /D week-09-ref "..\Solved Repositories\week-09"
```

### Demo Day Requirement

**Your final demonstration must prove that the Ansible playbook created in Week 11 (extended in Week 12) can rebuild your entire environment from scratch, including Weeks 1-9 infrastructure.**

The rebuild involves:
1. Wiping the container/environment clean
2. Running the Ansible playbook from scratch
3. Verifying Linkerd mesh is operational
4. Confirming Grafana dashboards display correctly
5. Demonstrating NetworkPolicy enforcement

---

## Overview

Week 13 shifts back to synchronous work. Your team will finalize all infrastructure deliverables, perform Ansible playbook dry-run testing, and rehearse for Demo Day.

## Deliverables

By the end of Week 13, you should have:

1. **Polished Grafana Dashboards:** All dashboards are production-ready with proper formatting
2. **Ansible Dry-Run Complete:** Playbook tested on clean cluster, idempotent verified
3. **NetworkPolicy Testing Complete:** Policies tested for allow and deny scenarios
4. **Demo Rehearsal Done:** Team has practiced the demo presentation
5. **All Verifications Passing:** Ansible can deploy the full infrastructure from scratch
6. **Demo Day Ready:** Team confident and prepared

## Key Tasks

- Review and refine all Grafana dashboards
- Ensure dashboard queries are correct and metrics display clearly
- Run Ansible playbook dry-run on fresh/clean cluster
- Verify idempotence: second playbook run shows changed=0
- Test NetworkPolicy enforcement in live cluster
- Document any known issues or edge cases
- Run through full demo presentation with timing
- Identify and fix any issues found during dry-run

## Ansible Dry-Run Process

1. Start with a clean k3d cluster (wipe and recreate if needed)
2. Run: `ansible-playbook -i ansible/inventory ansible/site.yml`
3. Record output and verify no errors
4. Verify Linkerd mesh is operational
5. Verify Grafana dashboards are accessible and showing data
6. Run playbook again to verify idempotence (changed=0)
7. Fix any tasks that show changed=0 on second run
8. Document total execution time

## Demo Rehearsal Checklist

- [ ] Who presents which part?
- [ ] What is the demo script/talking points?
- [ ] How long is the demo (5-7 minutes)?
- [ ] Can the demo be run live or should it be pre-recorded?
- [ ] What if something fails during live demo?
- [ ] Are backups (screenshots, recordings) available?
- [ ] Has the team practiced it?

## Demo Content (Suggested Flow)

1. **Container Wipe:** Show initial clean state (or describe what was wiped)
2. **Ansible Playbook:** Run the playbook that builds the full infrastructure
3. **Linkerd Verification:** Show `linkerd check` output and verify mesh is operational
4. **Service Meshing:** Demonstrate mTLS between Flask and PostgreSQL
5. **Grafana Access:** Show browser accessing Grafana dashboards
6. **Dashboard Analysis:** Display latency and success rate dashboards
7. **NetworkPolicy Demo:** Show allow policy working, then demonstrate blocked traffic
8. **Automation Story:** Explain how this all comes together via Ansible

## Acceptance Criteria

See `../week-13/docs/week-13-acceptance-criteria.md` for the full checklist.

## Sprint Closure Preparation

At the end of Week 13, prepare to close out Week 14 (which is just Demo Day). Make sure:

- All code is committed to Git
- All documentation is complete
- Team is confident in the demo
- Contingency plans are in place

## Next Week: Demo Day

Week 14 is Demo Day. The actual demonstration of the infrastructure mesh will happen in a synchronous class session. The cluster will be wiped, Ansible will rebuild everything, and the team will present the results.

Good luck with the demo! You've built an impressive service mesh infrastructure.
