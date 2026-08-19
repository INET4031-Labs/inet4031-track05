# Week 14 Environment Log - Demo Day

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 7 (Continued)  
**Week:** 14 - Demo Day

## Pre-Demo Environment Status

- Pre-demo cluster status: (running / issues)
- All services healthy: (yes / no)
- Linkerd check output: (PASS / FAIL / WARNINGS)
- Grafana dashboards: (accessible / issues)
- Demo script last rehearsed: (date/time)

---

## Demo Day Execution Log

### Pre-Demo Checklist

- [ ] k3d cluster confirmed running
- [ ] All pods in linkerd namespace healthy
- [ ] All pods in Flask namespace healthy
- [ ] All pods in PostgreSQL namespace healthy
- [ ] Grafana accessible and dashboards loading
- [ ] NetworkPolicy test files ready to deploy
- [ ] Demo script reviewed with presenter(s)
- [ ] Fallback procedures reviewed with team

**Pre-Demo Verification Time:** (time started)

---

### Demo Execution Timeline

**Step 1: Linkerd Verification**
- Time started: 
- Command executed: `linkerd check 2>/dev/null | tail -3`
- Expected output: (status check results)
- Actual output: 
```
(paste output here)
```
- Status: PASS / FAIL / PARTIAL
- Time elapsed: __ seconds

---

**Step 2: Meshed Traffic Test**
- Time started: 
- Test method: (query Flask to PostgreSQL)
- Expected result: (successful query)
- Actual result: 
```
(paste output here)
```
- Status: SUCCESS / FAILURE
- Time elapsed: __ seconds

---

**Step 3: Grafana Latency Dashboard**
- Time started: 
- Dashboard accessed: (URL or path)
- Data visible: (yes / no)
- P50 latency shown: __ ms
- P95 latency shown: __ ms
- P99 latency shown: __ ms
- Load time: __ seconds
- Status: WORKING / ISSUES
- Time elapsed: __ seconds

---

**Step 4: Grafana Success Rate Dashboard**
- Time started: 
- Dashboard accessed: (URL or path)
- Data visible: (yes / no)
- Success rate shown: ___%
- Error rate shown: ___%
- Load time: __ seconds
- Status: WORKING / ISSUES
- Time elapsed: __ seconds

---

**Step 5: NetworkPolicy Blocking Demo**
- Time started: 
- Blocking policy applied: `kubectl apply -f test-blocking-policy.yaml`
- Policy application time: __ seconds
- Expected effect: success rate drops to 0%
- Actual effect: success rate = ___%
- Grafana update lag: __ seconds
- Status: WORKED / ISSUES
- Time elapsed: __ seconds

---

**Step 6: Policy Removal and Recovery**
- Time started: 
- Policy removed: `kubectl delete networkpolicy flask-to-postgres-block -n <namespace>`
- Policy removal time: __ seconds
- Expected recovery: success rate returns to normal
- Actual recovery: success rate = ___%
- Grafana update lag: __ seconds
- Status: RECOVERED / ISSUES
- Time elapsed: __ seconds

---

### Total Demo Time
- Planned: __ minutes
- Actual: __ minutes
- Variance: +/- __ seconds

---

### Audience and Q&A

- Estimated audience size: 
- Questions asked: (list topics)
- Answers provided satisfactorily: (yes / no / partial)
- Any clarifications needed: (describe)

---

## Post-Demo: Cluster Wipe and Rebuild

### Cluster Wipe Phase

**Pre-wipe snapshot:**
- Cluster name: 
- Cluster status: 
- Estimated pod count before wipe: 

**Wipe command executed:**
```bash
k3d cluster delete <cluster-name>
```

**Wipe execution:**
- Time started: 
- Time completed: 
- Total wipe time: __ minutes
- Status: SUCCESS / PARTIAL / FAILURE
- Any issues: 

**Post-wipe verification:**
```bash
k3d cluster list
```
Output: (cluster should not be listed)

---

### Cluster Rebuild Phase

**Cluster creation command:**
```bash
k3d cluster create <cluster-name> [options]
```

**Cluster creation:**
- Time started: 
- Time completed: 
- Total creation time: __ minutes
- Status: SUCCESS / PARTIAL / FAILURE
- Any issues: 

**Cluster readiness verification:**
```bash
kubectl get nodes
kubectl get pods --all-namespaces
```
Output:
```
(paste output)
```

---

### Ansible Playbook Rebuild

**Playbook execution command:**
```bash
ansible-playbook -i inventory ansible/site.yml
```

**Playbook execution:**
- Time started: 
- Time completed: 
- Total rebuild time: __ minutes
- Status: SUCCESS / PARTIAL / FAILURE

**Execution summary:**
- Total tasks executed: 
- Tasks changed: 
- Tasks failed: 
- Skipped tasks: 

**Failed tasks (if any):**
1. (task name and error)
2. (task name and error)

---

### Post-Rebuild Verification

**Service Status Checks:**

```bash
# Check all namespaces
kubectl get pods --all-namespaces

# Linkerd control plane
kubectl get pods -n linkerd

# Flask service
kubectl get pods -n <flask-namespace>

# PostgreSQL service
kubectl get pods -n <postgres-namespace>
```

Output:
```
(paste output)
```

**Linkerd Verification:**
```bash
linkerd check 2>/dev/null | tail -3
```
Output:
```
(paste output)
```
Status: PASS / FAIL / PARTIAL

**Flask-to-PostgreSQL Connectivity Test:**
```bash
# (run your test command)
```
Output:
```
(paste output)
```
Status: SUCCESS / FAILURE

**Grafana Dashboard Access:**
- Grafana URL: 
- Latency dashboard: (accessible / not accessible)
- Success rate dashboard: (accessible / not accessible)
- Data populating: (yes / no / delayed)

---

## Post-Demo Issues and Resolutions

### Issue 1
- **Time discovered:** 
- **Description:** 
- **Impact on demo:** (critical / high / medium / low)
- **Root cause:** 
- **Resolution:** 
- **Time to resolve:** __ minutes

---

### Issue 2
- **Time discovered:** 
- **Description:** 
- **Impact on demo:** 
- **Root cause:** 
- **Resolution:** 
- **Time to resolve:** 

---

## Final Status

**Demo Day Result:** SUCCESS / PARTIAL SUCCESS / FAILED

**Deliverables Demonstrated:**
- [ ] Linkerd installed and verified
- [ ] Flask and PostgreSQL meshed with mTLS
- [ ] Grafana latency dashboard
- [ ] Grafana success rate dashboard
- [ ] NetworkPolicy blocking demonstration
- [ ] Ansible playbook rebuild successful

**Environment Rebuild Result:** SUCCESS / PARTIAL / FAILED

**Overall Track Completion:** SUCCESSFUL / ISSUES REMAIN

---

## Sign-Off

- Date: 
- Demo presented by: 
- Technical support by: 
- Recorded by: 
