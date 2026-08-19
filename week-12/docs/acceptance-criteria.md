# Week 12 Acceptance Criteria

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 6 (Continued)  
**Week:** 12

## Challenge Build Continued: Dashboards and Network Policy Integration

### Grafana Datasource Setup

- [ ] Grafana instance accessible
  - URL: 
  - Admin account available

- [ ] Linkerd Prometheus datasource created
  - Datasource name: `Linkerd` or similar
  - Endpoint: http://linkerd-prometheus:9090 (or equivalent)
  - Health check passing

- [ ] Prometheus queries working in Grafana
  - Test query: `up{job="linkerd-proxy"}`
  - Result: returns data points

#### Acceptance Criteria Detail

- Datasource connectivity test passes
  - Command in Grafana: "Test Data Source" button shows success
- Prometheus metrics available for the last 24+ hours
- Time series data points present for Flask-to-PostgreSQL communication

---

### Latency Dashboard Implementation

- [ ] Dashboard created or imported
  - Dashboard name: 
  - Dashboard UID or ID: 

- [ ] P50 latency panel present
  - Metric: Linkerd-provided request latency percentile
  - Time range: configurable (5m, 1h, 24h default)
  - Displays source and destination service breakdown

- [ ] P95 latency panel present
  - Same metric and visualization as P50
  - Shows tail latency trends

- [ ] P99 latency panel present
  - Highest percentile for extreme latency visibility
  - Useful for identifying worst-case scenarios

- [ ] Dashboard panels include labels
  - Each panel labeled with metric name and percentile
  - Time range selector functional
  - Refresh interval set (e.g., 30 seconds)

#### Acceptance Criteria Detail

- Latency values displayed in milliseconds
- Source and destination clearly labeled (Flask -> PostgreSQL)
- Baseline latencies captured and documented:
  - P50: __ ms
  - P95: __ ms
  - P99: __ ms
- Historical trends visible over at least 24 hours

---

### Success Rate Dashboard Implementation

- [ ] Success rate panel present
  - Calculation: successful requests / total requests
  - Time range: configurable
  - Expressed as percentage

- [ ] Error breakdown panels present
  - Errors grouped by type (e.g., connection reset, timeout, TLS failure)
  - Each error type visible as separate series or stacked bar
  - Trends over time shown

- [ ] Connection state visualization
  - Shows mTLS handshake success rate
  - Displays dropped connections or resets

- [ ] Dashboard includes baseline metrics
  - Baseline success rate: ___%
  - Baseline error rate: ___%
  - Any alert thresholds defined

#### Acceptance Criteria Detail

- Success rate query uses Linkerd metrics:
  - `request_total{tls="true"}` for successful mTLS connections
  - `request_total` for all requests
- Error rate query returns meaningful categorization
- Graphs remain readable with multiple error types
- Dashboard responsive to time range changes

---

### NetworkPolicy Integration Testing

- [ ] Week 7 NetworkPolicy rules documented
  - List of existing policies: 
  - Rules affecting Flask: 
  - Rules affecting PostgreSQL: 
  - Rules affecting other services: 

- [ ] Test NetworkPolicy created and applied
  - Policy name: 
  - Blocks traffic from: __ to __
  - Policy successfully applied to cluster
  - `kubectl get networkpolicy` returns the test policy

- [ ] Traffic blocking verified
  - Meshed traffic fails when policy applied
  - Flask to PostgreSQL connection refused or timed out
  - Application logs show connection errors

- [ ] Grafana metrics show blocking
  - Success rate drops to 0% or near 0%
  - Error rate spikes
  - Latency may show no data (no successful requests)

- [ ] Policy removal and traffic restoration tested
  - Policy deleted from cluster
  - `kubectl get networkpolicy` no longer shows blocking rule
  - Traffic flows again immediately
  - Grafana metrics return to normal baseline

- [ ] Allow policy tested
  - Alternative policy allowing specific traffic created
  - Demonstrates fine-grained control (not just blocking)
  - Traffic flows under allow policy
  - Metrics show success when allow is applied

#### Acceptance Criteria Detail

- NetworkPolicy YAML documented in environment-log or separate file
- Before/after screenshots of Grafana dashboard during policy change (if possible)
- Command sequence documented for reproducibility:
  1. `kubectl apply -f test-block-policy.yaml` -> traffic fails
  2. `kubectl delete networkpolicy test-block-policy` -> traffic resumes
  3. `kubectl apply -f test-allow-policy.yaml` -> traffic flows with specific rule

---

### Documentation and Export

- [ ] Grafana dashboards exported as JSON
  - Location: `week-12/grafana/dashboards/linkerd-latency.json`
  - Location: `week-12/grafana/dashboards/linkerd-success-rate.json`
  - Files can be imported into fresh Grafana instance

- [ ] Week 12 environment log completed
  - All Prometheus queries documented
  - Dashboard configurations recorded
  - NetworkPolicy tests and results captured

- [ ] NetworkPolicy YAML files saved
  - Test blocking policy: `week-12/network-policies/blocking-policy.yaml`
  - Test allow policy: `week-12/network-policies/allow-policy.yaml`
  - Comments explain each rule

---

### Failure Criteria

- [ ] Grafana datasource connectivity fails
- [ ] Prometheus returns no metrics for Linkerd components
- [ ] Dashboards show "no data" for more than 5 minutes after Grafana loads
- [ ] Latency or success rate metrics are absent or incorrect
- [ ] NetworkPolicy blocking fails (traffic continues through blocked policy)
- [ ] NetworkPolicy breaks non-meshed services or Week 1-9 functionality

---

## Dependencies

- Week 11 core deliverables met (Linkerd installed, services meshed, mTLS verified)
- Grafana instance available and accessible
- Prometheus compatible with Linkerd metrics format
- k3d cluster stable and Linkerd functioning

---

## Deliverables Summary

By end of Week 12:

1. Grafana datasource for Linkerd Prometheus configured and tested
2. Latency dashboard showing P50, P95, P99 latencies for Flask-to-PostgreSQL
3. Success rate dashboard showing request health and error breakdown
4. NetworkPolicy blocking test completed and documented
5. NetworkPolicy allow test completed and documented
6. Dashboard JSON exports saved for reproducibility
7. Week 12 environment log complete with all queries and test results

---

## Metrics to Document

- **Baseline Latencies:** P50, P95, P99 in milliseconds
- **Baseline Success Rate:** percentage of successful requests
- **Baseline Error Rate:** percentage of failed requests by type
- **Network Policy Impact:** before/after metrics when blocking rule applied

---

## Notes

- Dashboards should be readable at a glance during demo presentation (font sizes, colors, etc.)
- Consider adding legend and title to each dashboard panel
- Export dashboards before starting Week 13 for backup and version control
- If using Grafana alerts, document threshold values and alert names in environment-log
