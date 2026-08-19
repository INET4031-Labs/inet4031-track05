# Git Repository Initialization Instructions

Track 05: Network and Cloud Infrastructure has been scaffolded and is ready to be initialized as a git repository.

## Quick Start

From the track root directory (`track-05-network-and-cloud-infrastructure/`), run:

```bash
bash init-git.sh
```

Or initialize manually:

```bash
# Initialize repository
git init

# Configure git (optional, can be set globally)
git config user.email "your-email@example.com"
git config user.name "Your Name"

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Track 05 - Network and Cloud Infrastructure scaffold"
```

## Repository Status

**Status:** Scaffold ready for initialization  
**Files:** 26 files across 5 weeks of documentation and code  
**Size:** ~12,000 lines of documentation and templates  
**Ready:** Yes, git repository can be initialized immediately

## Initial Git Configuration

After initialization, configure remote (if pushing to a server):

```bash
# Add remote repository
git remote add origin https://github.com/your-org/track-05.git

# Push to remote
git push -u origin main
```

## Branch Strategy

The scaffold uses a single main branch for Week 10-14 work:
- `main` or `master` - Single branch for all track work
- No feature branches required for this framework
- Tags can be used to mark weekly milestones (optional)

Optional: Create weekly tags for reference:
```bash
git tag week-10-complete -m "Week 10: Challenge kickoff complete"
git tag week-11-complete -m "Week 11: Linkerd installation complete"
git tag week-12-complete -m "Week 12: Dashboards and policy testing complete"
git tag week-13-complete -m "Week 13: Ansible finalization complete"
git tag week-14-complete -m "Week 14: Demo Day complete"

# Push tags
git push origin --tags
```

## Commit Strategy

Recommended commit patterns:

**During Weekly Build:**
```bash
git add week-XX/docs/*.md
git commit -m "Week XX: [Day] - [What was done]"

# Example:
git commit -m "Week 11: Monday-Tuesday - Linkerd CLI installed and control plane deployed"
git commit -m "Week 11: Wednesday - Flask and PostgreSQL services meshed"
```

**Before Week Closure:**
```bash
git commit -m "Week XX: Final - Documentation and verification complete"
```

**Before Demo Day:**
```bash
git commit -m "Week 14: Pre-demo checkpoint - All systems verified and ready"
git commit -m "Week 14: Post-demo - Full rebuild from wipe successful"
```

## .gitignore Rules

The `.gitignore` file is configured to exclude:
- Credentials and secrets (kubeconfig, .env, etc.)
- Build artifacts and temporary files
- IDE configurations
- Docker and terraform artifacts
- Backup and test output files
- Large binary files

**Important:** Never commit secrets or credentials. If accidentally committed, remove with:
```bash
git rm --cached <filename>
git commit -m "Remove accidental credential commit"
```

## Troubleshooting

### Repository already exists
If you see "fatal: Initialized empty Git repository", the repository already exists. Verify with:
```bash
git status
```

### Path issues
Ensure you're in the track root directory before running git init:
```bash
pwd  # Should end with track-05-network-and-cloud-infrastructure
ls README.md  # Should exist
git init
```

### Permission denied on init-git.sh
Make the script executable:
```bash
chmod +x init-git.sh
bash init-git.sh
```

## Next Steps After Initialization

1. **Week 10 Start:** Begin challenge kickoff meeting
2. **Backlog Review:** Team reviews `week-10/backlog.md`
3. **Documentation:** Each week, update corresponding docs/ folder
4. **Commits:** Make weekly commits to track progress
5. **Week 14:** Final demo and post-demo rebuild documented

## Verification

After initialization, verify with:

```bash
git status
# Should show: On branch main/master, nothing to commit, working tree clean

git log --oneline
# Should show the initial commit message

ls -la .git
# Should show a .git directory
```

---

**Repository ready for Track 05 team to begin Week 10!**
