# Week 12 Environment Log

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 6 (Continued)  
**Week:** 12

## Environment Status at Start of Week

- Linkerd control plane: (operational / issues)
- Flask service: (meshed / not meshed)
- PostgreSQL service: (meshed / not meshed)
- mTLS status: (verified / not verified)
- Grafana instance: (running / not running)
- Prometheus instance: (running / not running)

## Week 12 Build Progress

### Monday-Tuesday: Grafana Datasource Configuration

**Tasks:**
- [ ] Linkerd Prometheus endpoint identified
- [ ] Grafana datasource created or updated for Linkerd Prometheus
- [ ] Datasource connectivity tested
- [ ] Sample Prometheus queries verified

**Status:** 

**Configuration Details:**
- Grafana URL: 
- Prometheus datasource name: 
- Prometheus endpoint: 
- Authentication: (none / token / basic)

**Test Query Results:**
```
# Example: Request rate by destination
sum(rate(request_total[1m])) by (dst)
```
Result: (data returned / query error)

**Observations:**
- Datasource creation time: 
- Any connectivity issues: 
- Metric availability: 

---

### Tuesday-Wednesday: Latency Dashboard Implementation

**Tasks:**
- [ ] Dashboard created in Grafana (or imported from template)
- [ ] Latency metrics queries added (p50, p95, p99)
- [ ] Visualizations configured (time series, gauges, etc.)
- [ ] Source/destination breakdown implemented
- [ ] Historical data retention verified

**Status:** 

**Prometheus Queries Used:**
1. P50 Latency:
   ```
   histogram_quantile(0.50, sum(rate(latency_ms_bucket[1m])) by (le, src, dst))
   ```

2. P95 Latency:
   ```
   histogram_quantile(0.95, sum(rate(latency_ms_bucket[1m])) by (le, src, dst))
   ```

3. P99 Latency:
   ```
   histogram_quantile(0.99, sum(rate(latency_ms_bucket[1m])) by (le, src, dst))
   ```

**Dashboard Panels:**
- Flask to PostgreSQL P50 latency: 
- Flask to PostgreSQL P95 latency: 
- Flask to PostgreSQL P99 latency: 
- Latency trends over time: 

**Observations:**
- Time to build dashboard: 
- Query accuracy and data relevance: 
- Any missing or unexpected metrics: 

---

### Wednesday-Thursday: Success Rate Dashboard Implementation

**Tasks:**
- [ ] Success rate metrics queries added to Grafana
- [ ] Error breakdown panels created
- [ ] Status distribution visualizations configured
- [ ] Alert thresholds defined (if applicable)

**Status:** 

**Prometheus Queries Used:**
1. Success Rate:
   ```
   sum(rate(request_total{tls="true"}[1m])) by (dst) / sum(rate(request_total[1m])) by (dst)
   ```

2. Error Rate by Type:
   ```
   sum(rate(request_total{status=~"5.."}[1m])) by (status, dst)
   ```

**Dashboard Panels:**
- Flask to PostgreSQL success rate: 
- Error rate breakdown: 
- Connection state transitions: 

**Observations:**
- Expected success rate (baseline): 
- Observed error patterns: 
- Any anomalies or concerns: 

---

### Thursday-Friday: NetworkPolicy Integration Testing

**Tasks:**
- [ ] Week 7 NetworkPolicy rules reviewed and documented
- [ ] Test NetworkPolicy rule created (blocking rule)
- [ ] Policy applied to cluster
- [ ] Mesh behavior with blocked policy verified
- [ ] Metrics observed during blocked state
- [ ] Policy removed and traffic restored
- [ ] Allow policy created and tested

**Status:** 

**NetworkPolicy Configuration:**
Policy name: 
Namespace: 
Blocked path: (source -> destination)

```yaml
# Paste your test NetworkPolicy manifest here
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-block-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: postgres
  policyTypes:
    - Ingress
  ingress: []  # Blocks all ingress
```

**Testing Timeline:**
1. Policy applied at: (time)
2. Blocked traffic observed at: (time)
   - Connection errors in proxy logs: (paste sample)
   - Grafana success rate dropped to: 
3. Policy removed at: (time)
   - Traffic resumed at: (time)
   - Grafana success rate recovered to: 

**Observations:**
- Impact on meshed traffic: 
- Proxy behavior during policy enforcement: 
- Linkerd metrics accuracy during blocking: 

---

## Grafana Dashboard Export

Save your dashboards for reproducibility:

**Latency Dashboard:**
- Dashboard ID or name: 
- Export location: (e.g., `week-12/grafana/dashboards/linkerd-latency.json`)
- Number of panels: 

**Success Rate Dashboard:**
- Dashboard ID or name: 
- Export location: (e.g., `week-12/grafana/dashboards/linkerd-success-rate.json`)
- Number of panels: 

## Resource Usage

Capture after dashboards are live:
```bash
kubectl top nodes
kubectl top pods -n linkerd
kubectl top pods -n <flask-namespace>
kubectl top pods -n <postgres-namespace>
```

(paste output here)

## Known Issues and Workarounds

- Issue: 
  - Root cause: 
  - Workaround: 
  - Status: (open / resolved / escalated)

## End-of-Week Status

**Deliverables Met:**
- [ ] Grafana datasource for Linkerd Prometheus working
- [ ] Latency dashboard displaying Flask to PostgreSQL metrics
- [ ] Success rate dashboard displaying request health
- [ ] NetworkPolicy blocking rule tested and documented
- [ ] Mesh integration with NetworkPolicy verified
- [ ] Week 12 environment log complete

**Blockers for Week 13:**
- (List any issues that will impact Weeks 13-14)

## Sign-Off

- Date: 
- Recorded by: 
- Reviewed by: 
