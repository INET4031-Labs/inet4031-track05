# Week 14 Acceptance Criteria

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 7 (Continued)  
**Week:** 14 - Demo Day

## Challenge Track Completion and Demo Day

### Demo Execution

- [ ] Challenge track demo presented to audience
  - Duration: < 15 minutes
  - All core components demonstrated

- [ ] Linkerd installation verified
  - Command: `linkerd check 2>/dev/null | tail -3`
  - Output shows all checks passed or OK
  - mTLS status confirmed

- [ ] Flask-to-PostgreSQL meshed traffic demonstrated
  - Live query executed through meshed connection
  - Query successful and returns incident data
  - Proxied through Linkerd sidecars

#### Acceptance Criteria Detail

Linkerd check output should show:
```
Status check results are [OK]
(or similar indicating full system health)
```

Meshed traffic test should:
- Query incident data from Flask
- Data returns successfully
- Connection flows through Linkerd proxy
- No application errors

---

### Grafana Dashboards Demonstrated

- [ ] Latency dashboard displayed
  - P50, P95, P99 latency metrics visible
  - Flask-to-PostgreSQL service pair shown
  - Time series data displaying correctly
  - Audience can see metric trends

- [ ] Success rate dashboard displayed
  - Success rate percentage visible
  - Error breakdown shown
  - Connection state distribution visible
  - Dashboard responsive to time range

#### Acceptance Criteria Detail

Dashboards should:
- Load within 5 seconds
- Display data with < 1 minute of freshness
- Show Flask-to-PostgreSQL metrics clearly
- Be understandable to audience without extensive explanation

---

### NetworkPolicy Integration Demonstration

- [ ] Blocking policy successfully applied
  - Command executed on live cluster
  - Policy appears in `kubectl get networkpolicy` output
  - Traffic from Flask to PostgreSQL blocked

- [ ] Blocking effect visible in Grafana
  - Success rate drops to 0% or near 0%
  - Error rate spikes
  - Change visible within 1-2 minutes

- [ ] Policy removed and traffic restored
  - Command executed to delete policy
  - Traffic resumes immediately
  - Grafana metrics return to normal baseline

- [ ] Audience understands the demonstration
  - Explanation provided for each step
  - Impact on meshed traffic explained
  - Benefit of network policies clarified

#### Acceptance Criteria Detail

NetworkPolicy demo sequence:
1. Apply blocking policy: `kubectl apply -f test-blocking-policy.yaml`
2. Observe success rate drop in Grafana (wait 1-2 minutes)
3. Remove policy: `kubectl delete networkpolicy <policy-name>`
4. Observe recovery in Grafana (wait 1-2 minutes)

All steps should execute without errors.

---

### Cluster Wipe and Rebuild

- [ ] k3d cluster successfully deleted
  - Command: `k3d cluster delete <cluster-name>`
  - Cluster removed from `k3d cluster list`
  - No errors during deletion

- [ ] k3d cluster successfully recreated
  - Command: `k3d cluster create <cluster-name> [options]`
  - New cluster appears in `k3d cluster list`
  - Cluster nodes in Ready state
  - No errors during creation

- [ ] Ansible playbook successfully rebuilds environment
  - Command: `ansible-playbook -i inventory ansible/site.yml`
  - All tasks execute without critical failures
  - Exit code 0 (success)
  - No manual intervention required

#### Acceptance Criteria Detail

Post-rebuild verification:
```bash
kubectl get pods --all-namespaces
# Should show all Week 1-9 services plus linkerd control plane

kubectl get pods -n linkerd
# Should show Linkerd control plane pods (identity, controller, etc.)

linkerd check 2>/dev/null | tail -3
# Should show status check passed
```

---

### Post-Rebuild Verification

- [ ] All Week 1-9 services operational
  - Docker/Docker Compose infrastructure: (running / verify)
  - Kubernetes cluster: (running / verify)
  - Flask application: (running / verify)
  - PostgreSQL database: (running / verify)
  - Prometheus monitoring: (running / verify)
  - Grafana: (running / verify)

- [ ] Linkerd control plane fully operational
  - Linkerd namespace exists: `kubectl get namespace linkerd`
  - Control plane pods running: `kubectl get pods -n linkerd`
  - mTLS certificates issued

- [ ] Services properly meshed
  - Flask namespace annotated: `kubectl get namespace <flask-namespace> -o jsonpath='{.metadata.labels}'`
  - PostgreSQL namespace annotated: `kubectl get namespace <postgres-namespace> -o jsonpath='{.metadata.labels}'`
  - Sidecars injected in all pods

- [ ] End-to-end connectivity verified
  - Flask can query PostgreSQL through mesh
  - mTLS handshakes successful
  - Incident data accessible

#### Acceptance Criteria Detail

Verification commands should all return success:
```bash
linkerd check                  # All checks pass
kubectl get pods -n linkerd    # All control plane pods Running
kubectl get pods -n <flask>    # All Flask pods with 2/2 containers
kubectl get pods -n <postgres> # All PostgreSQL pods with 2/2 containers
```

---

### Grafana Post-Rebuild Verification

- [ ] Grafana instance accessible
  - Accessible at configured URL
  - Admin login successful

- [ ] Linkerd Prometheus datasource connected
  - Datasource health check passing
  - Sample queries return data

- [ ] Latency dashboard data populating
  - Metrics visible (may take 1-2 minutes to populate)
  - Flask-to-PostgreSQL latencies displayed

- [ ] Success rate dashboard data populating
  - Metrics visible (may take 1-2 minutes to populate)
  - Success rate and error rate displayed

#### Acceptance Criteria Detail

Post-rebuild, allow 2-3 minutes for Linkerd to generate and export metrics to Prometheus, then verify dashboards display data. Initial data may be sparse due to the rebuild, but dashboards should be functional.

---

### Demo Documentation

- [ ] Week 14 environment log completed
  - Pre-demo checklist documented
  - Demo execution timeline recorded
  - Cluster wipe and rebuild logged
  - All commands and outputs captured
  - Issues and resolutions documented

- [ ] All demo commands documented
  - Linkerd check command and output
  - Meshed traffic test and result
  - Dashboard access procedures
  - NetworkPolicy demo steps
  - Rebuild commands

- [ ] Post-demo findings recorded
  - Demo timing actual vs. planned
  - Technical issues encountered and resolved
  - Audience questions and answers
  - Final status of all deliverables

#### Acceptance Criteria Detail

Week 14 environment log should include:
- Exact timestamps for each demo step
- Full output of verification commands
- Screenshots or dashboard descriptions (if captured)
- Any manual troubleshooting steps taken
- Final verification that all systems operational

---

### Failure Criteria

- [ ] k3d cluster deletion fails
- [ ] Ansible playbook returns errors on rebuild
- [ ] Linkerd control plane fails to deploy during rebuild
- [ ] Flask or PostgreSQL services not operational after rebuild
- [ ] mTLS not established after rebuild
- [ ] Grafana dashboards show no data 5+ minutes after rebuild
- [ ] Demo not completed or incompletely demonstrated
- [ ] Major technical issues during demo not resolved

---

## Dependencies

- All Week 10-13 deliverables met
- Ansible playbook fully tested in check mode
- Demo script rehearsed and verified
- Grafana dashboards ready
- NetworkPolicy test scenarios prepared

---

## Deliverables Summary

By end of Week 14 (Demo Day):

1. **Demo Execution:**
   - Linkerd service mesh demonstrated and verified
   - Flask-to-PostgreSQL meshed traffic working
   - Grafana dashboards displaying latency and success rate metrics
   - NetworkPolicy blocking/allowing demonstration successful

2. **Environment Rebuild:**
   - k3d cluster wiped cleanly
   - Cluster recreated successfully
   - Ansible playbook rebuilt all services without manual intervention
   - All Week 1-9 services operational
   - Linkerd installed and meshed services verified

3. **Documentation:**
   - Week 14 environment log complete with full demo execution details
   - All commands and outputs captured
   - Issues and resolutions documented
   - Post-rebuild verification complete

---

## Key Success Indicators

- Demo completes within 15 minutes
- All technical steps execute without errors
- Audience understands the Linkerd service mesh capabilities
- Environment rebuild demonstrates full automation
- No manual steps required for platform deployment

---

## Notes

- This is the final week of the challenge track; all deliverables should be complete and demonstrated
- Demo Day is the culmination of Weeks 10-14 work; all systems should be fully operational
- Any remaining issues should be escalated to instructor before final sign-off
- Congratulations on completing the Network and Cloud Infrastructure challenge track!
