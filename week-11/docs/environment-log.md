# Week 11 Environment Log

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 6  
**Week:** 11

## Environment Status at Start of Week

- k3d cluster version: 
- Incident data platform status: 
- Flask service namespace: 
- PostgreSQL service namespace: 
- Existing observability stack (Prometheus, Grafana): 

## Week 11 Build Progress

### Monday-Tuesday: Linkerd Control Plane Installation

**Tasks:**
- [ ] Linkerd CLI version selected and installed
- [ ] Pre-installation checks completed (CRD validation, RBAC)
- [ ] Linkerd control plane manifests applied
- [ ] Linkerd namespace created (typically `linkerd` or `linkerd-system`)

**Status:** 

**Observations:**
- Installation time: 
- Resource utilization impact: 
- Any issues encountered: 

**Verification:**
```bash
linkerd check
```
Output: (paste relevant sections)

---

### Wednesday-Thursday: Service Meshing

**Tasks:**
- [ ] Flask namespace annotated with `linkerd.io/inject: enabled`
- [ ] Flask deployment pods restarted and sidecars confirmed running
- [ ] PostgreSQL namespace annotated for sidecar injection
- [ ] PostgreSQL pods restarted and sidecars confirmed running

**Status:** 

**Observations:**
- Sidecar injection took: (time per service)
- Pod restart behavior: 
- Sidecar startup logs: 

**Verification:**
```bash
kubectl get pods -n <flask-namespace> -o wide
kubectl get pods -n <postgres-namespace> -o wide
kubectl logs <pod-name> -c linkerd-proxy -n <namespace>
```
Output: (key observations)

---

### Thursday-Friday: End-to-End Verification

**Tasks:**
- [ ] Test Flask-to-PostgreSQL connectivity through mesh
- [ ] Verify mTLS handshakes in proxy logs
- [ ] Confirm incident data query still works
- [ ] Run `linkerd check` on full system

**Status:** 

**Test Results:**
- Flask to PostgreSQL latency (baseline meshed): 
- Query success rate through mesh: 
- mTLS verification: 

**Verification Output:**
```bash
linkerd check
```
Status: PASS / FAIL / PARTIAL

If FAIL, document:
- [ ] Which checks failed: 
- [ ] Remediation steps: 

---

## Configuration Snapshots

### Linkerd Version
Version: 
Release notes: (any breaking changes noted)

### mTLS Configuration
```yaml
# Document any custom mTLS settings
# e.g., certificate expiration policy, rotation interval
```

### Namespace Annotations
Flask namespace annotation time: 
PostgreSQL namespace annotation time: 

## Resource Usage

Capture after meshing is complete:
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
- [ ] Linkerd control plane installed and verified
- [ ] Flask service meshed with mTLS
- [ ] PostgreSQL service meshed with mTLS
- [ ] End-to-end traffic confirmed working
- [ ] `linkerd check` output shows all systems operational

**Blockers for Week 12:**
- (List any issues that will impact Week 12 dashboard setup or policy integration)

## Sign-Off

- Date: 
- Recorded by: 
- Reviewed by: 
