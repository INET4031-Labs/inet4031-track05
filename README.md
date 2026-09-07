# Track 5: Network and Cloud Infrastructure

## Overview

This challenge track extends the Weeks 1-9 container platform with advanced networking and service-to-service observability using Linkerd.

## Goal

Implement advanced network controls and service-to-service observability beyond the basic NetworkPolicy introduced in Week 7. Deploy a service mesh on the k3d cluster to provide mTLS encryption, latency metrics, and traffic visualization for the Flask and PostgreSQL services.

## Architecture

This track builds on the existing incident data platform established in Weeks 1-9. You will:

1. Install and configure Linkerd as the service mesh control plane
2. Mesh the Flask application and PostgreSQL services for automatic mTLS
3. Implement Grafana dashboards for service-to-service latency and success rate metrics
4. Demonstrate network policy enforcement on meshed services

## Status Caveat

Weeks 10-14 were flagged in the source lab directions as needing re-evaluation with the professor before being finalized. The six tracks and the overall week structure are correct as written; specific deliverables and integration points may still change. This repository is a framework, not a finished deliverable.

## Prerequisites

- Completion of Weeks 1-9 (k3d cluster, incident data platform, basic networking)
- Linkerd CLI compatible with the k3d Kubernetes version
- Ansible for automated deployment
- Docker and Docker Compose for local development

## Week Structure

| Week | Sprint | Type | Focus |
|---|---|---|---|
| Week 10 | Sprint 5 (cont.) | Synchronous | Challenge kickoff, architecture decision, backlog |
| Week 11 | Sprint 6 | Asynchronous | Core build: Linkerd installation and service meshing |
| Week 12 | Sprint 6 (cont.) | Asynchronous | Dashboard implementation and policy integration testing |
| Week 13 | Sprint 7 | Synchronous | Finalize, Ansible dry run, demo rehearsal |
| Week 14 | Sprint 7 (cont.) | Synchronous | Demo Day: container wipe and playbook rebuild |

## Key Deliverables

**Week 11:**
- Linkerd installed and verified with `linkerd check`
- Flask-to-PostgreSQL traffic meshed with mTLS enabled

**Week 12:**
- Grafana dashboard displaying service-to-service latency and success rates
- Demonstration of NetworkPolicy blocking on a meshed path

**Week 13:**
- Ansible playbook for Linkerd control plane installation verified via dry-run
- Demo rehearsal of the full deployment

**Week 14:**
- Full environment wipe and rebuild using the playbook
- Demo Day verification

## Important Notes

Linkerd support should be confirmed for your k3d Kubernetes version before starting Week 11. If Linkerd is not supported, flag this issue with the TA rather than substituting with an alternative service mesh.

## Repository Structure

```
track-05-network-and-cloud-infrastructure/
├── README.md (this file)
├── docs/
│   ├── qa-report-10.md
│   ├── qa-report-11.md
│   ├── qa-report-12.md
│   ├── qa-report-13.md
│   ├── qa-report-14.md
│   ├── sprint-10-retrospective.md
│   ├── sprint-11-retrospective.md
│   ├── sprint-12-retrospective.md
│   ├── sprint-13-retrospective.md
│   └── sprint-14-retrospective.md
├── week-10/
│   └── backlog.md
├── week-11/
│   └── ansible/
│       ├── site.yml
│       └── roles/
│           └── linkerd/
│               └── tasks/
├── week-12/
│   └── grafana/
│       └── dashboards/
├── week-13/
│   └── ansible/
├── week-14/
│   └── verification/
└── .gitignore
```

Per-week QA reports and sprint retrospectives now live centrally under the top-level `docs/` directory (e.g. `docs/qa-report-11.md`, `docs/sprint-11-retrospective.md`) rather than in a `week-N/docs/` folder.
