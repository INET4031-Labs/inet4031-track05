---
**Week 1-9 Prerequisite**

Weeks 10-14 assume your completed Weeks 1-9 repositories are available as peer directories in `Student Repositories/`. This track's Ansible roles reference your prior work:
- `linkerd` role uses your k3d cluster from Week 5 (`../week-05/`)
- `linkerd` role meshes your Flask application from Week 2 (`../week-02/`) and PostgreSQL from Week 4 (`../week-04/` or `../infrastructure/`)

Your track repo does NOT copy these — it integrates with them. Ensure your Week 1-9 work is complete and accessible before Week 11.

---

# Week 10: Challenge Kickoff and Architecture Decision

**Sprint 5 (continued) | Synchronous Challenge Kickoff**

## Overview

Week 10 is the synchronous kickoff for the Network and Cloud Infrastructure track. Your team will review the challenge goal of implementing service mesh observability using Linkerd, decide on architecture and tooling, and prepare the sprint backlog for the core implementation in Weeks 11-12.

## Challenge Goal

Extend the existing k3d cluster with advanced networking and observability by deploying Linkerd as the service mesh. By Demo Day, the infrastructure must provide:
- Automatic mTLS encryption for service-to-service communication
- Service latency and success rate metrics
- Traffic visualization via Grafana dashboards
- Integration with NetworkPolicy for traffic enforcement

## Core Decisions This Week

By end of week, your team must document:

1. **Linkerd Installation Approach**
   - Helm deployment or manual kubectl apply?
   - High-availability mode or minimal mode?
   - Namespace strategy for data plane?
   - Decide and document rationale

2. **Service Meshing Strategy**
   - Which services to mesh first: Flask and PostgreSQL?
   - Annotation-based auto-injection vs. manual sidecar injection?
   - Any services to exclude from meshing?
   - Decide the phasing approach

3. **Observability and Metrics**
   - Use Prometheus for metrics collection?
   - Grafana for dashboards: existing or new deployment?
   - What KPIs to track: latency percentiles, success rates, error rates?
   - Dashboard layout and alert strategy?

4. **Integration with Ansible**
   - How will Linkerd installation be automated in the playbook?
   - What Ansible role structure: single role or split?
   - Idempotency: how will re-running handle existing installations?

5. **Risk and Prerequisites**
   - Linkerd version compatibility with k3d cluster version?
   - Resource requirements for Linkerd control plane?
   - Any networking or firewall considerations?

## Deliverables

- [ ] Architecture decision document (why Linkerd, installation approach, phasing)
- [ ] Service mesh topology diagram (which services, which namespaces)
- [ ] Sprint backlog for Weeks 11-12 (features, tasks, estimated points)
- [ ] Environment status snapshot (current k3d cluster state)
- [ ] Test plan for observability validation

## Week Structure

**Synchronous work** (in-class or scheduled meetings):
- Day 1: Challenge briefing and Linkerd overview
- Day 2-3: Architecture decision and tool evaluation
- Day 4-5: Backlog refinement and Sprint 5 retrospective closure

## Verification

At end of week:
1. Architecture decision document is complete and team-reviewed
2. Backlog items are defined with acceptance criteria
3. No Linkerd installation attempts yet (Week 11 task)

## Acceptance Criteria

See `docs/acceptance-criteria.md` for the formal acceptance checklist.

## Next Steps (Week 11)

Week 11 is the core build sprint. You will:
- Install Linkerd control plane in the cluster
- Mesh Flask and PostgreSQL services with automatic mTLS
- Verify traffic encryption and metrics collection
- Prepare Grafana dashboard configuration

For detailed instructions, see `../week-11/README.md`.
