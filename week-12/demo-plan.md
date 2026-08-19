# Demo Plan: Network and Cloud Infrastructure Track

**Demo Date:** [Insert date]  
**Demo Duration:** [XX minutes]  
**Audience:** [Faculty, peers, stakeholders]  
**Location/Format:** [In-person / Virtual / Hybrid]

---

## 1. Demo Sequence

**Step-by-step walkthrough with timing:**

| Time | Step | Description | Owner |
|------|------|-------------|-------|
| 0:00 | Introduction | Brief overview of track objectives | [Name] |
| 0:30 | Component 1 | [Description with specific actions] | [Name] |
| 2:00 | Component 2 | [Description with specific actions] | [Name] |
| 4:00 | Component 3 | [Description with specific actions] | [Name] |
| 5:30 | Results/Analysis | [Description of outputs demonstrated] | [Name] |
| 6:30 | Q&A | Questions from audience | All |

**Total: XX minutes**

### Detailed Walkthrough

**TODO:** Provide step-by-step instructions for each demo component
- Which cloud resources to show?
- What infrastructure configurations to display?
- What monitoring/metrics to demonstrate?
- Where are potential failure points?

---

## 2. Success Criteria

**What must work for the demo to succeed:**

- [ ] Cloud infrastructure is accessible and responsive
- [ ] Network connectivity and routing working properly
- [ ] Monitoring dashboards display current metrics
- [ ] Application/service deployments are running
- [ ] Load balancing/failover working as expected
- [ ] Security groups and ACLs functioning properly
- [ ] Network/connectivity is stable (if applicable)
- [ ] Audio/video working (if virtual)
- [ ] Timing is within target duration
- [ ] [Additional track-specific criteria]

---

## 3. Risk Assessment

**What could go wrong:**

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Cloud service unavailable | Low | High | Have local VirtualBox backup; use screenshots |
| Network connectivity issues | Medium | High | Pre-test all connections; have mobile hotspot |
| API rate limits hit during demo | Low | High | Pre-cache responses; use smaller test resources |
| Monitoring dashboard slow | Medium | Medium | Pre-load data; use static screenshots if needed |
| DNS/name resolution issues | Low | Medium | Use IP addresses directly; have local hosts file |
| Security group rules blocking access | Medium | Medium | Pre-verify all rules; have backup access methods |

---

## 4. Recovery Plans

**How to handle each risk:**

### Cloud Service Unavailable
- **Plan A:** Fail over to local VirtualBox environment
- **Plan B:** Show infrastructure-as-code and explain what would run
- **Plan C:** Display pre-captured screenshots of live environment

### Network Connectivity Issues
- **Plan A:** Switch to mobile hotspot
- **Plan B:** Use alternative network/connection method
- **Plan C:** Continue demo using cached/local resources

### API/Rate Limit Issues
- **Plan A:** Use smaller test dataset
- **Plan B:** Show API responses from cache
- **Plan C:** Display infrastructure logs and metrics locally

### Dashboard Performance
- **Plan A:** Navigate to specific metric pages
- **Plan B:** Use pre-loaded static screenshots
- **Plan C:** Explain dashboard structure and metrics verbally

---

## 5. Key Talking Points

**What to explain to the audience:**

- **Infrastructure Architecture:** Overall design and component relationships
- **Scalability Approach:** How does it handle increased load?
- **High Availability Strategy:** What makes it resilient?
- **Security Posture:** How network is secured; access controls
- **Monitoring & Observability:** How health and performance monitored
- **Cost Optimization:** How resources are managed efficiently
- **Disaster Recovery:** What happens if components fail?
- **Lessons Learned:** Challenges and design decisions

### Sample Talking Points
- [Point 1 - TODO: Fill in]
- [Point 2 - TODO: Fill in]
- [Point 3 - TODO: Fill in]

---

## 6. Contingencies

**Backup plan if primary demo fails:**

### Pre-recorded Infrastructure Tour
- Location: `week-12/backup/infrastructure-recording.mp4`
- Duration: [XX minutes]
- Setup instructions: [Specify how to play]

### Screenshot Fallback
- Location: `week-12/backup/screenshots/`
- Contents:
  - [ ] Screenshot 1: [Cloud console overview]
  - [ ] Screenshot 2: [Network topology diagram]
  - [ ] Screenshot 3: [Monitoring dashboard]

### Local VirtualBox Alternative
- Location: `week-12/backup/local-environment/`
- Setup: Run `./start-local-demo.sh`
- Demonstrates: Same architecture on local VMs

### Architecture Diagram & Whiteboard
- **Scenario:** If cloud unavailable, team can:
  1. Draw architecture on whiteboard/projector
  2. Explain each component and its role
  3. Walk through network flow and routing
  4. Show infrastructure-as-code (Terraform/CloudFormation)
  5. Display performance data from local testing

---

## Pre-Demo Checklist

**Day Before:**
- [ ] Test all cloud resources accessible
- [ ] Verify network connectivity to cloud
- [ ] Check all security groups and routing tables
- [ ] Load monitoring dashboards; verify data present
- [ ] Test application/service endpoints
- [ ] Setup local VirtualBox backup environment
- [ ] Record backup video (if using)
- [ ] Prepare printed handouts with architecture diagrams
- [ ] Brief all team members on their roles
- [ ] Run through demo once, timing it

**Morning Of:**
- [ ] Verify all cloud services up and healthy
- [ ] Test network connectivity
- [ ] Refresh monitoring data
- [ ] Open all relevant browser tabs/consoles
- [ ] Test microphone/audio (if virtual)
- [ ] Verify projection/screen sharing
- [ ] Have backup devices/networks ready
- [ ] Review talking points one more time

---

## Demo Success Log

**After demo, complete the following:**

- [ ] Demo completed successfully?
  - [ ] Yes - Note what worked well
  - [ ] Partial - Note what failed and recovery used
  - [ ] No - Document what went wrong

- [ ] Audience feedback: [Brief notes]
- [ ] Lessons learned: [What to improve next time]
- [ ] Follow-up actions: [Any questions to address]

---

**Demo Rehearsal Completed:** [Date]  
**Final Approval:** [Name/Date]
