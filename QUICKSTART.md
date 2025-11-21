# Quick Start Guide

Get your GitHub Admin automation system up and running in minutes!

## Initial Setup

### 1. Push to GitHub

```bash
# Initialize and push to GitHub
git add .
git commit -m "Initial commit: GitHub Admin automation system"

# If creating a new repository on GitHub
gh repo create github-admin --private --source=. --remote=origin --push

# Or if pushing to an existing repository
git remote add origin https://github.com/YOUR_USERNAME/github-admin.git
git branch -M main
git push -u origin main
```

### 2. Verify GitHub Actions

1. Go to your repository on GitHub
2. Navigate to the **Actions** tab
3. Ensure workflows are enabled
4. You should see "Repository and Admin Automation" workflow

### 3. Test the System

#### Test Repository Creation

1. Go to the **Issues** tab
2. Click **New Issue**
3. Select **"Create New Repository"**
4. Fill in the form:
   - **Repository Name**: test-repo
   - **Description**: Test repository
   - **Visibility**: Private
   - **Branch to Protect**: main
   - Check "Require pull request reviews before merging"
   - **Repository Owners**: @your-username
5. Submit the issue

The workflow will automatically:
- Parse your request
- Add a comment with configuration details
- Provide the exact commands to run

#### Test Admin Request

1. Go to the **Issues** tab
2. Click **New Issue**
3. Select **"Request Administrator Access"**
4. Fill in the form with test data
5. Submit the issue

The workflow will:
- Parse the request
- Add it to the review queue
- Label it appropriately

## Manual Repository Creation

If you prefer to create repositories manually using the scripts:

```bash
# Make sure you're authenticated with GitHub CLI
gh auth status

# If not authenticated, login
gh auth login

# Create a new repository
./scripts/create-repo.sh my-new-repo private main "My new repository description"

# Add collaborators
./scripts/add-collaborator.sh YOUR_ORG/my-new-repo johndoe admin

# Configure advanced branch protection
./scripts/configure-branch-protection.sh YOUR_ORG/my-new-repo main --required-reviewers 2
```

## Configuration

Edit `config.yml` to customize:

- Default branch protection rules
- Required number of reviewers
- Naming conventions
- Security settings

## Common Commands

```bash
# Check GitHub CLI authentication
gh auth status

# List your repositories
gh repo list

# View repository details
gh repo view OWNER/REPO

# Check branch protection status
gh api repos/OWNER/REPO/branches/main/protection

# List collaborators
gh api repos/OWNER/REPO/collaborators
```

## Troubleshooting

### "gh: command not found"
```bash
# Install GitHub CLI
brew install gh  # macOS
```

### "Workflow not running"
- Check if GitHub Actions is enabled in repository settings
- Verify the workflow file syntax is correct
- Check the Actions tab for any errors

### "Permission denied"
- Ensure you have admin access to the organization/repository
- Verify your GitHub token has the correct scopes
- Re-authenticate: `gh auth login`

## Next Steps

1. ✅ Push code to GitHub
2. ✅ Enable GitHub Actions
3. ✅ Create your first issue to test the system
4. ✅ Customize `config.yml` for your needs
5. ✅ Add collaborators who can approve requests
6. ✅ Document any organization-specific processes

## Security Checklist

- [ ] Repository is private (recommended)
- [ ] Only trusted users have write access
- [ ] Branch protection is enabled on main branch
- [ ] Require PR reviews before merging
- [ ] Regular audits of admin requests
- [ ] GitHub token is stored securely (never committed)

## Support

Need help? 
- Check the main [README.md](README.md)
- Review existing issues
- Create a new issue with details

---

**Ready to automate!** 🚀
