#!/bin/bash
# Initialize Track 05 - Network and Cloud Infrastructure as a git repository
# Run this script from the track root directory

set -e

echo "Initializing Track 05 - Network and Cloud Infrastructure as git repository..."

# Initialize git repository
git init

# Set initial git config (can be overridden locally)
git config user.email "track05@inet4031.local" || true
git config user.name "INET 4031 Track 05 Team" || true

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Track 05 - Network and Cloud Infrastructure scaffold

- Week 10: Challenge kickoff, architecture decision, backlog
- Week 11: Linkerd installation and service meshing
- Week 12: Dashboard implementation and NetworkPolicy integration
- Week 13: Ansible finalization and demo rehearsal
- Week 14: Demo Day - container wipe and playbook rebuild

This scaffold provides the foundation for implementing Linkerd service mesh
on the INET 4031 k3d cluster platform for advanced networking and observability."

echo "Git repository initialized successfully!"
echo "Remote: Add a remote repository with: git remote add origin <url>"
echo "Branch: Currently on main/master branch"
echo ""
echo "Next steps:"
echo "1. Review Week 10 backlog in week-10/backlog.md"
echo "2. Begin Week 10 challenge kickoff"
echo "3. Document decisions in week-10/docs/"
echo "4. Update acceptance criteria as team progresses"
