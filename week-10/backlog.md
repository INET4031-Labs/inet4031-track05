# Challenge Track Backlog

**Track:** 5 - Network and Cloud Infrastructure  
**Version:** 1.0  
**Last Updated:** (date)

## Vision

Deploy Linkerd as a service mesh on the k3d cluster to provide automatic mTLS, request-level observability, and traffic visualization for the Flask application and PostgreSQL database. Enable the incident data platform to demonstrate modern cloud-native networking practices.

## Epic 1: Linkerd Control Plane Installation (Week 11)

### Story 1.1: Install Linkerd CLI and Control Plane

**As a** platform engineer  
**I want** Linkerd control plane running on the k3d cluster  
**So that** workloads can be meshed with automatic mTLS and observability

**Acceptance Criteria:**
- [ ] Linkerd CLI installed on the control host
- [ ] Linkerd control plane deployed to k3d cluster
- [ ] Control plane passes `linkerd check` validation
- [ ] Namespace annotations applied for sidecar injection ready

**Task:**
- Verify k3d Kubernetes version compatibility with selected Linkerd version
- Install Linkerd CLI
- Apply Linkerd control plane manifests to cluster
- Document any customizations or configuration overrides

**Dependencies:** None (ready to start Week 11)

---

### Story 1.2: Configure mTLS and Observability

**As a** security engineer  
**I want** automatic mTLS enabled for all meshed services  
**So that** traffic is encrypted and identities are verified between services

**Acceptance Criteria:**
- [ ] mTLS policy set to automatic for meshed namespaces
- [ ] Service identity certificates generated and rotated automatically
- [ ] `linkerd check` output confirms mTLS is enabled

**Task:**
- Document mTLS configuration
- Verify certificate issuance and rotation
- Test identity verification with meshed services

**Dependencies:** Story 1.1 completed

---

## Epic 2: Service Meshing (Week 11)

### Story 2.1: Mesh Flask Application

**As a** application operator  
**I want** the Flask service meshed with Linkerd  
**So that** Flask traffic has automatic mTLS and metrics collection

**Acceptance Criteria:**
- [ ] Flask namespace annotated for sidecar injection
- [ ] Flask pods restart with Linkerd sidecar
- [ ] Linkerd proxy logs show successful startup
- [ ] `linkerd stat pods -n <flask-namespace>` returns metrics

**Task:**
- Identify Flask namespace and deployment
- Add `linkerd.io/inject: enabled` annotation
- Trigger pod restart and verify sidecar injection
- Monitor initial metrics for any anomalies

**Dependencies:** Story 1.2 completed

---

### Story 2.2: Mesh PostgreSQL Service

**As a** application operator  
**I want** the PostgreSQL service meshed with Linkerd  
**So that** database traffic has automatic mTLS and is observable

**Acceptance Criteria:**
- [ ] PostgreSQL namespace annotated for sidecar injection
- [ ] PostgreSQL pods restart with Linkerd sidecar
- [ ] Sidecar health checks pass
- [ ] `linkerd stat pods -n <postgres-namespace>` returns metrics

**Task:**
- Identify PostgreSQL namespace and statefulset/deployment
- Add sidecar injection annotation
- Monitor pod startup and sidecar readiness
- Verify traffic flows through proxy

**Dependencies:** Story 2.1 completed

---

### Story 2.3: Verify End-to-End Meshed Traffic

**As a** platform engineer  
**I want** Flask-to-PostgreSQL traffic fully meshed with mTLS  
**So that** the core data path is secure and observable

**Acceptance Criteria:**
- [ ] Flask pods can connect to PostgreSQL via meshed network
- [ ] `linkerd check` confirms all checks pass
- [ ] Incident query still succeeds through meshed connection
- [ ] mTLS handshakes visible in proxy logs

**Task:**
- Run incident data query from Flask to PostgreSQL
- Verify successful response
- Capture `linkerd check` output for documentation
- Document metrics and identity pairs in Linkerd CLI

**Dependencies:** Stories 2.1, 2.2 completed

---

## Epic 3: Observability and Dashboards (Week 12)

### Story 3.1: Set Up Grafana Datasource for Linkerd Metrics

**As a** platform engineer  
**I want** Grafana connected to Linkerd Prometheus for metrics  
**So that** service-to-service observability is visualized

**Acceptance Criteria:**
- [ ] Grafana datasource added for Linkerd Prometheus
- [ ] Datasource connectivity verified
- [ ] Sample metrics query successful (e.g., request rate)

**Task:**
- Identify Linkerd Prometheus endpoint
- Add datasource to existing Grafana or deploy new Grafana instance
- Test metric queries

**Dependencies:** Stories 2.1, 2.2, 2.3 completed

---

### Story 3.2: Create Service-to-Service Latency Dashboard

**As a** operator  
**I want** a Grafana dashboard showing Flask-to-PostgreSQL latency  
**So that** performance issues can be detected and debugged

**Acceptance Criteria:**
- [ ] Dashboard displays 95th and 99th percentile latencies
- [ ] Latencies broken down by source and destination
- [ ] Historical data retained for trend analysis
- [ ] Dashboard is read-only or restricted to authorized users

**Task:**
- Build Prometheus queries for latency metrics
- Create Grafana dashboard panels
- Set appropriate time ranges and refresh rates
- Document dashboard interpretation

**Dependencies:** Story 3.1 completed

---

### Story 3.3: Create Success Rate Dashboard

**As a** operator  
**I want** a Grafana dashboard showing Flask-to-PostgreSQL request success rate  
**So that** connection health and error rates are visible

**Acceptance Criteria:**
- [ ] Dashboard displays success rate (success/total requests)
- [ ] Error breakdown visible (connection errors, timeouts, etc.)
- [ ] Alert thresholds configurable
- [ ] Data refresh interval appropriate for operations

**Task:**
- Build Prometheus queries for success metrics
- Create dashboard panels for success rate and errors
- Configure alert rules if appropriate
- Document interpretation and escalation paths

**Dependencies:** Story 3.1 completed

---

## Epic 4: NetworkPolicy Integration (Week 12)

### Story 4.1: Document Existing NetworkPolicy Rules

**As a** security engineer  
**I want** to understand existing Week 7 NetworkPolicy rules  
**So that** I can integrate meshed services with existing policies

**Acceptance Criteria:**
- [ ] All Week 7 NetworkPolicy rules documented
- [ ] Ingress and egress rules for each service listed
- [ ] Any conflicts with mesh traffic identified

**Task:**
- List all NetworkPolicy resources in cluster
- Document rules in backlog or security documentation
- Test that existing policies don't block meshed traffic

**Dependencies:** None (can be done in parallel with Epic 3)

---

### Story 4.2: Create NetworkPolicy Blocking Rule for Meshed Path

**As a** security engineer  
**I want** a NetworkPolicy that blocks specific meshed traffic  
**So that** I can demonstrate fine-grained network control

**Acceptance Criteria:**
- [ ] NetworkPolicy created to block one meshed path (e.g., a secondary app to PostgreSQL)
- [ ] Policy successfully blocks traffic when applied
- [ ] Linkerd metrics show blocked connections
- [ ] Policy can be toggled to demonstrate before/after

**Task:**
- Design a test NetworkPolicy rule
- Apply to cluster and verify blocking behavior
- Document the policy and its effect on metrics
- Create a second version that allows traffic for demo reversal

**Dependencies:** Stories 2.1, 2.2, 2.3, and 4.1 completed

---

## Epic 5: Ansible Automation (Weeks 13-14)

### Story 5.1: Create Linkerd Ansible Role

**As a** platform engineer  
**I want** an Ansible role that installs Linkerd  
**So that** the environment can be built from scratch in Demo Day

**Acceptance Criteria:**
- [ ] Role downloads and installs Linkerd CLI
- [ ] Role applies Linkerd control plane manifests
- [ ] Role is idempotent (safe to run multiple times)
- [ ] Role passes dry-run before Demo Day

**Task:**
- Create `ansible/roles/linkerd/` directory structure
- Write `tasks/main.yml` with installation steps
- Test role in dry-run mode
- Document any prerequisites or variables

**Dependencies:** Stories 1.1, 1.2 completed and tested

---

### Story 5.2: Create Sidecar Injection Ansible Task

**As a** platform engineer  
**I want** an Ansible role that injects Linkerd sidecars into Flask and PostgreSQL  
**So that** services are automatically meshed during environment rebuild

**Acceptance Criteria:**
- [ ] Role applies namespace annotations for sidecar injection
- [ ] Role triggers pod restart for both services
- [ ] Role verifies sidecars are running
- [ ] Role is idempotent

**Task:**
- Add tasks to linkerd role or create separate role
- Document namespace names and annotation format
- Test injection and pod restart process

**Dependencies:** Stories 2.1, 2.2 completed

---

## Epic 6: Demo Day Preparation (Week 14)

### Story 6.1: Full Environment Wipe and Rebuild

**As a** demo team  
**I want** to wipe the k3d cluster and rebuild with Ansible  
**So that** we can verify the entire setup is reproducible

**Acceptance Criteria:**
- [ ] k3d cluster completely wiped (delete and recreate)
- [ ] Ansible playbook successfully rebuilds Weeks 1-9 services
- [ ] Linkerd control plane installed and verified
- [ ] Flask and PostgreSQL meshed with mTLS confirmed

**Task:**
- Prepare cluster wipe procedures
- Run full Ansible playbook
- Verify all services operational
- Document any manual steps if any are required

**Dependencies:** All prior stories completed

---

### Story 6.2: Demo Script and Runbook

**As a** demo team  
**I want** a clear demo script for Linkerd capabilities  
**So that** the presentation is polished and reproducible

**Acceptance Criteria:**
- [ ] Demo script written with step-by-step commands
- [ ] Grafana dashboards pre-loaded or accessible in demo
- [ ] `linkerd check` output captured and explained
- [ ] NetworkPolicy block-and-allow demo scripted

**Task:**
- Write demo runbook
- Pre-load Grafana dashboards
- Practice timing
- Document any manual setup steps

**Dependencies:** All implementation stories completed

---

## Priority and Dependencies

### Must-Have (Week 11)
1. Story 1.1 - Linkerd control plane
2. Story 1.2 - mTLS configuration
3. Story 2.1 - Flask meshing
4. Story 2.2 - PostgreSQL meshing
5. Story 2.3 - End-to-end verification

### Should-Have (Week 12)
1. Story 3.1 - Grafana datasource
2. Story 3.2 - Latency dashboard
3. Story 3.3 - Success rate dashboard
4. Story 4.1 - NetworkPolicy documentation
5. Story 4.2 - NetworkPolicy demo rule

### Nice-to-Have (Weeks 13-14)
1. Story 5.1 - Linkerd Ansible role
2. Story 5.2 - Sidecar injection Ansible
3. Story 6.1 - Full rebuild demo
4. Story 6.2 - Polished demo script

## Assumptions and Risks

### Assumptions
- Linkerd version compatible with k3d Kubernetes version
- Linkerd Prometheus metrics are available for Grafana integration
- Flask and PostgreSQL are running in separate namespaces
- Existing Grafana instance available or will be deployed

### Risks
- **High:** Linkerd incompatibility with k3d - mitigate by confirming version compatibility before Week 11
- **Medium:** mTLS policy interferes with existing NetworkPolicy - mitigate by testing meshing on non-critical service first
- **Medium:** Grafana datasource configuration complexity - mitigate by documenting Prometheus endpoint early

## Open Questions

- (List any clarifications needed from professor or TA, e.g., about Cilium support)
