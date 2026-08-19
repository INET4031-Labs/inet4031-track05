# Week 11 Acceptance Criteria

**Track:** 5 - Network and Cloud Infrastructure  
**Sprint:** 6  
**Week:** 11

## Core Build: Linkerd Installation and Service Meshing

### Acceptance Criteria

#### Linkerd Control Plane Installation

- [ ] Linkerd CLI installed and accessible on control host
  - Command: `linkerd version` returns version number

- [ ] Linkerd control plane deployed to k3d cluster
  - Linkerd namespace created (default: `linkerd` or `linkerd-system`)
  - Control plane pods running: identity, controller, destination, proxy-injector, etc.
  - Command: `kubectl get pods -n linkerd` returns all pods in Running state

- [ ] Linkerd pre-installation checks passed
  - No CRD conflicts
  - RBAC permissions available
  - Command: `linkerd check --pre` returns no critical errors

- [ ] Linkerd post-installation checks passed
  - Command: `linkerd check` returns no critical errors
  - All checks in output marked as PASS or OK

#### Flask Service Meshing

- [ ] Flask namespace identified and documented
  - Namespace: 
  - Deployment/StatefulSet name: 
  - Number of replicas: 

- [ ] Flask namespace annotated for sidecar injection
  - Annotation: `linkerd.io/inject: enabled`
  - Applied via: kubectl annotate or manifest update

- [ ] Flask pods restarted and sidecars confirmed
  - All Flask pods running and Ready (2/2 containers)
  - Linkerd proxy container present in each pod
  - Command: `kubectl get pods -n <flask-namespace> -o jsonpath='{.items[*].spec.containers[*].name}'` includes linkerd-proxy

- [ ] Flask sidecar logs show successful startup
  - No errors in linkerd-proxy container logs
  - Sidecar connected to control plane
  - Command: `kubectl logs <flask-pod> -c linkerd-proxy | tail -20` shows healthy startup

#### PostgreSQL Service Meshing

- [ ] PostgreSQL namespace identified and documented
  - Namespace: 
  - Deployment/StatefulSet name: 
  - Number of replicas: 

- [ ] PostgreSQL namespace annotated for sidecar injection
  - Annotation: `linkerd.io/inject: enabled`
  - Applied via: kubectl annotate or manifest update

- [ ] PostgreSQL pods restarted and sidecars confirmed
  - All PostgreSQL pods running and Ready (2/2 containers for sidecar)
  - Linkerd proxy container present
  - Command: `kubectl get pods -n <postgres-namespace> -o jsonpath='{.items[*].spec.containers[*].name}'` includes linkerd-proxy

- [ ] PostgreSQL sidecar logs show successful startup
  - No errors in linkerd-proxy container logs
  - Healthy connection to control plane

#### End-to-End Traffic Verification

- [ ] Flask can reach PostgreSQL through the mesh
  - Test query (e.g., incident data query) executed from Flask
  - Query returns successful result (200 OK or equivalent)
  - No connection timeouts or protocol errors

- [ ] mTLS communication verified
  - Test: `kubectl logs <flask-pod> -c linkerd-proxy | grep -i tls`
  - Output shows successful TLS handshake with PostgreSQL sidecar
  - Client certificates exchanged and validated

- [ ] Linkerd check confirms full system health
  - Command: `linkerd check 2>/dev/null | tail -3`
  - Output: Three status lines confirming checks passed
  - Example output:
    ```
    Status check results are [OK]
    ```

#### Metrics Collection

- [ ] Linkerd Prometheus is scraping metrics
  - Linkerd data plane metrics available
  - Command: `linkerd stat pods -n <flask-namespace>` returns latency and request rate

- [ ] Service-to-service metrics visible
  - Command: `linkerd stat -n <postgres-namespace> --to-namespace <flask-namespace>` shows traffic from Flask to PostgreSQL
  - Output includes: Source, Destination, Requests, Success, P50, P95, P99 latencies

#### Documentation

- [ ] Week 11 environment log completed
  - Linkerd version documented
  - Configuration decisions recorded
  - Any custom settings noted

- [ ] Linkerd check output captured for later reference
  - Saved to environment-log.md or separate file
  - Baseline metrics captured for performance tracking

### Failure Criteria

- [ ] `linkerd check` returns FAIL on any critical check
- [ ] Flask-to-PostgreSQL traffic does not flow through mesh
- [ ] mTLS handshake fails or shows errors
- [ ] Any Flask or PostgreSQL pod fails to start or has multiple restarts
- [ ] Incident data query fails through meshed connection

## Dependencies

- Week 1-9 incident data platform fully operational
- Flask and PostgreSQL services stable and responding
- k3d cluster with sufficient resources (memory for Linkerd control plane)

## Deliverables Summary

By end of Week 11:
1. Linkerd control plane fully installed and verified
2. Flask service meshed with mTLS enabled
3. PostgreSQL service meshed with mTLS enabled
4. End-to-end Flask-to-PostgreSQL traffic flowing through mesh
5. `linkerd check` output confirming all systems operational
6. Week 11 environment log and documentation complete

## Notes

- If Linkerd is incompatible with the k3d version, escalate to TA immediately rather than proceeding with a workaround or alternative service mesh
- Document any deviations from the plan in the retrospective
- Metrics collection and dashboard creation are Week 12 tasks; Week 11 focus is on installation and meshing only
