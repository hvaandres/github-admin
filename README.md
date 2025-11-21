# GitHub Admin - Repository Management Automation

Automated GitHub repository management system using GitHub Issues as an interface for creating repositories and managing administrator access.

## 🚀 Features

- **Issue-Based Workflow**: Create repositories and request admin access through GitHub Issues
- **Automated Branch Protection**: Automatically protect main branches with customizable rules
- **README Generation**: Every repository starts with a README file
- **Owner Assignment**: Assign administrators and collaborators during repository creation
- **Team Management**: Integrate team-based access control
- **GitHub Actions Integration**: Automated processing of requests
- **Helper Scripts**: Command-line tools for advanced configuration

## 📋 Prerequisites

Before using this automation system, ensure you have:

1. **GitHub CLI** (`gh`) installed
   ```bash
   # macOS
   brew install gh
   
   # Linux
   sudo apt install gh
   
   # Windows
   winget install GitHub.cli
   ```

2. **GitHub Authentication**
   ```bash
   gh auth login
   ```

3. **Appropriate Permissions**
   - Organization owner or admin access for organization repositories
   - Personal account access for personal repositories
   - Write access to this repository

## 🎯 How It Works

### Creating a New Repository

1. **Go to the Issues tab** of this repository
2. **Click "New Issue"**
3. **Select "Create New Repository"** template
4. **Fill out the form** with:
   - Repository name
   - Description
   - Visibility (public/private)
   - Branch to protect
   - Branch protection rules
   - Repository owners
   - Team access
   - Initial files to create

5. **Submit the issue**
6. The GitHub Actions workflow will:
   - Parse your request
   - Add a comment with the configuration summary
   - Provide commands to execute the creation
   
7. **An administrator** will run the provided script to create the repository

### Requesting Administrator Access

1. **Go to the Issues tab** of this repository
2. **Click "New Issue"**
3. **Select "Request Administrator Access"** template
4. **Fill out the form** with:
   - Your GitHub username
   - Access level needed
   - Scope (repository, organization, or team)
   - Justification

5. **Submit the issue**
6. The request will be:
   - Parsed automatically
   - Labeled for review
   - Assigned to repository administrators
   
7. **An administrator** will review and approve/deny with `/approve` or `/deny` commands

## 🛠️ Helper Scripts

The `scripts/` directory contains helper scripts for manual repository management:

### Create Repository

```bash
./scripts/create-repo.sh <repo-name> <visibility> <branch-to-protect> "<description>" [owner/org]
```

**Example:**
```bash
./scripts/create-repo.sh my-new-project private main "A new project repository" myorg
```

### Add Collaborator

```bash
./scripts/add-collaborator.sh <owner/repo> <username> <permission>
```

**Permissions:** `pull`, `push`, `admin`, `maintain`, `triage`

**Example:**
```bash
./scripts/add-collaborator.sh myorg/my-repo johndoe admin
```

### Add Team

```bash
./scripts/add-team.sh <owner/repo> <team-slug> <permission>
```

**Example:**
```bash
./scripts/add-team.sh myorg/my-repo engineering write
```

### Configure Branch Protection

```bash
./scripts/configure-branch-protection.sh <owner/repo> <branch> [options]
```

**Options:**
- `--required-reviewers N` - Number of required reviewers
- `--enforce-admins` - Apply rules to administrators
- `--require-code-owners` - Require code owner reviews
- `--require-linear-history` - Require linear history
- `--require-signed-commits` - Require signed commits
- `--no-conversation-resolution` - Don't require conversation resolution
- `--allow-force-pushes` - Allow force pushes

**Example:**
```bash
./scripts/configure-branch-protection.sh myorg/my-repo main --required-reviewers 2 --enforce-admins
```

## ⚙️ Configuration

Edit `config.yml` to customize default settings:

- Default visibility (public/private)
- Default branch name
- Branch protection rules
- Required files
- Permission levels
- Auto-approval settings

## 🔧 Workflow Commands

Use these commands in issue comments to control workflow:

- `/approve` - Approve and close an admin request
- `/deny [reason]` - Deny and close a request with optional reason
- `/done` - Mark a repository creation as completed

## 📁 Repository Structure

```
github-admin/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── request-admin-access.yml
│   │   └── create-repository.yml
│   └── workflows/
│       └── issue-automation.yml
├── scripts/
│   ├── create-repo.sh
│   ├── add-collaborator.sh
│   ├── add-team.sh
│   └── configure-branch-protection.sh
├── config.yml
└── README.md
```

## 🔒 Security Considerations

1. **Token Security**: Never commit GitHub tokens to the repository
2. **Permission Reviews**: Regularly review granted permissions
3. **Audit Logs**: Monitor issue activity for unauthorized requests
4. **Branch Protection**: Always protect main branches
5. **Two-Factor Authentication**: Require 2FA for organization members

## 🎓 Best Practices

1. **Use Descriptive Names**: Follow naming conventions for repositories
2. **Document Justifications**: Provide clear reasons for admin access requests
3. **Review Before Approval**: Always review requests before approving
4. **Consistent Configuration**: Use the scripts to ensure consistency
5. **Regular Audits**: Periodically review repository access and permissions

## 📝 Example Workflows

### Creating a Private Repository with Protection

1. Create issue using "Create New Repository" template
2. Set visibility to "Private"
3. Enable "Require pull request reviews before merging"
4. Set required reviewers to 2
5. Add team "engineering:write"
6. Submit and wait for automation
7. Run the provided script
8. Comment `/done` to close

### Requesting Organization Admin Access

1. Create issue using "Request Administrator Access" template
2. Select "Organization Administrator"
3. Specify organization name
4. Provide detailed justification
5. Submit for review
6. Administrator reviews and comments `/approve` or `/deny`

## 🤝 Contributing

To contribute to this automation system:

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📄 License

This project is provided as-is for organizational use. Customize as needed for your environment.

## 🆘 Troubleshooting

### GitHub CLI Not Found
```bash
# Install GitHub CLI
brew install gh  # macOS
# or
sudo apt install gh  # Linux
```

### Authentication Issues
```bash
# Re-authenticate
gh auth logout
gh auth login
```

### Permission Errors
- Ensure you have the necessary permissions in the organization
- Verify your GitHub token has the required scopes
- Check if 2FA is properly configured

### Branch Protection Failures
- Ensure the branch exists before applying protection
- Verify you have admin access to the repository
- Check if there are conflicting rules

## 📞 Support

For issues or questions:
1. Check existing issues in this repository
2. Create a new issue with the appropriate template
3. Contact repository administrators

---

**Maintained by**: Repository Administrators  
**Last Updated**: 2025
