# Week 14: Demo Day - Cluster Rebuild and Presentation

**Sprint 7 (Continuation) | Synchronous**

## Overview

Week 14 is Demo Day. The k3d cluster environment will be wiped completely. Your Ansible playbook will then rebuild the entire infrastructure from scratch. The team will demonstrate that the service mesh (Linkerd), monitoring (Grafana), and network policies work end-to-end with full automation.

## Deliverables

By the end of Week 14, you should have:

1. **Successful Cluster Rebuild:** Ansible playbook builds full infrastructure from scratch
2. **Successful Demo Presentation:** Team demonstrates the service mesh infrastructure
3. **All Verifications Passing:** Linkerd, Grafana dashboards, and NetworkPolicy all work post-rebuild
4. **Sprint 7 Retrospective Complete:** Team reflection on Weeks 13-14
5. **QA Sign-Off:** QA verifies everything is working

## The Demo Process

### Cluster Wipe (Beginning of Week 14)

1. k3d cluster is completely wiped/reset to baseline state
2. No Linkerd, no Grafana, no services meshes
3. Clean slate for Ansible to build on

### Ansible Playbook Rebuild

1. Run: `ansible-playbook -i ansible/inventory ansible/site.yml`
2. Playbook installs all required baseline infrastructure (Weeks 1-4)
3. Playbook deploys Linkerd service mesh
4. Playbook configures Grafana dashboards
5. Playbook applies NetworkPolicy rules
6. No manual steps required - everything is automated
7. Playbook completes successfully with no errors

### Post-Rebuild Verification

1. Linkerd mesh is operational: `linkerd check` passes all checks
2. Grafana dashboards are accessible at http://localhost:3000/
3. Dashboards display live Linkerd metrics (latency, success rate)
4. Flask and PostgreSQL services are meshed with mTLS
5. NetworkPolicy rules are enforced correctly
6. Traffic flows between Flask and PostgreSQL successfully

### Demo Presentation

1. Show the cluster wipe (initial clean state)
2. Run the Ansible playbook (live or pre-recorded)
3. Verify Linkerd mesh is operational with `linkerd check`
4. Show mTLS certificates and mesh status
5. Access Grafana and display metrics dashboards
6. Demonstrate NetworkPolicy enforcement (allow and deny scenarios)
7. Show live traffic metrics in Grafana
8. Explain how automation ties it all together

## Success Criteria

- [ ] Ansible playbook runs with zero manual intervention
- [ ] Linkerd mesh comes up automatically
- [ ] Grafana dashboards are accessible and displaying data
- [ ] Flask and PostgreSQL services are meshed
- [ ] NetworkPolicy is enforced correctly
- [ ] `linkerd check` passes all checks
- [ ] Demo presentation is clear and professional
- [ ] Team can explain the full infrastructure

## What If Something Goes Wrong?

**Backup Plans:**
- Pre-recorded demo showing the full infrastructure deployment
- Screenshots of working dashboards and mesh status
- Documented proof that everything works (from Week 13 testing)

If the live playbook fails during demo, you can show pre-recorded evidence that the automation works. The key is proving that the infrastructure is fully automated and reproducible.

## Team Roles During Demo

- **Network Engineer:** Explain Linkerd mesh architecture and mTLS
- **Infrastructure/DevOps:** Explain Ansible automation and deployment
- **QA/Testing:** Verify all checks pass post-rebuild
- **Optional 4th Member:** Support as needed

## Acceptance Criteria

See `../week-14/docs/week-14-acceptance-criteria.md` for the full checklist.

## Sprint 7 Closure

At the end of Week 14, the entire challenge track is complete. Fill in:
- `../docs/sprint-7-retrospective.md` - Team reflection on Weeks 13-14 and the entire track
- `../docs/qa-report-7.md` - QA sign-off on Demo Day success

## Reflection Questions

1. How well did the Ansible automation work?
2. Was the demo successful?
3. What would you do differently if you started this track again?
4. What did you learn about service meshes, Kubernetes networking, and Ansible?
5. Are you proud of the infrastructure you built?

Congratulations on completing the Network and Cloud Infrastructure challenge track!
