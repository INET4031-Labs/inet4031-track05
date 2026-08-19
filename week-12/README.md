# Week 12: Core Build Continued - Grafana Dashboards and NetworkPolicy

**Sprint 6 (Continuation) | Asynchronous**

## Overview

Week 12 continues Sprint 6 asynchronous work. You will deploy Grafana dashboards to visualize Linkerd metrics (latency and success rates) and implement Kubernetes NetworkPolicy rules to demonstrate traffic control between meshed services.

## Deliverables

By the end of Week 12, you should have:

1. **Grafana Dashboard for Latency:** Displays request latency over time for Flask-to-PostgreSQL traffic
2. **Grafana Dashboard for Success Rate:** Shows error rates and successful requests per service
3. **NetworkPolicy Allow Rule:** Permits traffic between Flask and PostgreSQL only
4. **NetworkPolicy Deny Rule:** Blocks unauthorized access attempts
5. **Evidence of Policy Effectiveness:** Demonstrated that policies work as expected

## Key Tasks

- Deploy Grafana (via Helm or manifests) on the k3d cluster
- Configure Linkerd Prometheus as datasource for Grafana
- Create dashboards showing:
  - Request latency (p50, p95, p99)
  - Success rate (percentage of successful requests)
  - Error rate by service and namespace
  - Top services by traffic volume
- Implement NetworkPolicy manifests:
  - Allow policy: Flask ingress from PostgreSQL, PostgreSQL ingress from Flask
  - Deny all policy: Default deny traffic, then allow specific routes
- Test policies by attempting to connect across policy boundaries

## Grafana Dashboard Guidelines

**Latency Dashboard:**
- X-axis: Time
- Y-axis: Latency (milliseconds)
- Display p50, p95, p99 percentiles
- Show trends over 1-hour window
- Label: "Flask-to-PostgreSQL Latency Metrics"

**Success Rate Dashboard:**
- Display overall success rate (%)
- Show error rate by service
- Breakdown by response code (200, 500, etc.)
- Include time series over 1-hour window
- Alert threshold: 95% success rate minimum

## NetworkPolicy Implementation

**Allow Policy Example:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-flask-postgres
spec:
  podSelector:
    matchLabels:
      app: postgres
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: flask
```

**Testing:**
- From Flask pod, verify connection to PostgreSQL works
- From unauthorized pod, verify connection fails
- Document with screenshot or command output

## Acceptance Criteria

See `../week-12/docs/week-12-acceptance-criteria.md` for the full checklist.

## Sprint Closure

At the end of Week 12, sprint 6 closes. Fill in `../docs/sprint-6-retrospective.md` and `../docs/qa-report-6.md` to reflect on the core build phase.

## Next Week

Week 13 (Sprint 7) shifts to synchronous work: Ansible dry-run, demo rehearsal, and final preparations for Demo Day.
