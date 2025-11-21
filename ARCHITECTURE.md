# System Architecture

## Overview

The GitHub Admin automation system uses GitHub Issues as a user interface, GitHub Actions for automation, and helper scripts for advanced operations.

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Actions                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Issues Interface                       │
│  ┌──────────────────────┐    ┌──────────────────────┐          │
│  │ Create New Repository│    │ Request Admin Access  │          │
│  │     Issue Template   │    │    Issue Template     │          │
│  └──────────────────────┘    └──────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions Workflow                       │
│                   (issue-automation.yml)                         │
│                                                                   │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Job 1: process-admin-request                    │          │
│  │  - Parse issue body                              │          │
│  │  - Extract admin request details                 │          │
│  │  - Add review comment                            │          │
│  │  - Label: needs-review                           │          │
│  └──────────────────────────────────────────────────┘          │
│                                                                   │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Job 2: process-repo-creation                    │          │
│  │  - Parse issue body                              │          │
│  │  - Extract repository configuration              │          │
│  │  - Generate creation commands                    │          │
│  │  - Add action comment                            │          │
│  │  - Label: needs-action                           │          │
│  └──────────────────────────────────────────────────┘          │
│                                                                   │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Job 3: handle-commands                          │          │
│  │  - Process /approve, /deny, /done                │          │
│  │  - Update issue status                           │          │
│  │  - Close issues                                  │          │
│  └──────────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Manual Execution                            │
│                  (Administrator Actions)                         │
│                                                                   │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Helper Scripts                                  │          │
│  │  ├── create-repo.sh                              │          │
│  │  ├── add-collaborator.sh                         │          │
│  │  ├── add-team.sh                                 │          │
│  │  └── configure-branch-protection.sh              │          │
│  └──────────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub API                                │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Repository Operations:                          │          │
│  │  • Create repository                             │          │
│  │  • Add README file                               │          │
│  │  • Configure branch protection                   │          │
│  │  • Add collaborators                             │          │
│  │  • Add teams                                     │          │
│  │  • Set permissions                               │          │
│  └──────────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   New Repository Created                         │
│                       with protection                            │
└─────────────────────────────────────────────────────────────────┘
```

## Components

### 1. Issue Templates

**Location**: `.github/ISSUE_TEMPLATE/`

- `create-repository.yml`: Form for creating new repositories
- `request-admin-access.yml`: Form for requesting administrator access
- `config.yml`: Configuration for issue template chooser

**Purpose**: Provide structured input forms for users

### 2. GitHub Actions Workflow

**Location**: `.github/workflows/issue-automation.yml`

**Triggers**: When issues are opened or edited

**Jobs**:
- **process-admin-request**: Parses admin access requests and queues them for review
- **process-repo-creation**: Parses repository creation requests and generates commands
- **handle-commands**: Processes workflow commands (/approve, /deny, /done)

### 3. Helper Scripts

**Location**: `scripts/`

All scripts use the GitHub CLI (`gh`) and GitHub API:

- **create-repo.sh**: Creates repository with README and branch protection
- **add-collaborator.sh**: Adds individual collaborators with specific permissions
- **add-team.sh**: Adds teams to repositories
- **configure-branch-protection.sh**: Configures advanced branch protection rules

### 4. Configuration

**Location**: `config.yml`

Defines default settings for:
- Repository visibility and branches
- Branch protection rules
- Permission levels
- Automation behavior
- Compliance requirements

## Data Flow

### Repository Creation Flow

1. **User submits issue** with repository details
2. **GitHub Actions parses** the issue body
3. **Workflow generates commands** based on configuration
4. **Workflow posts comment** with instructions
5. **Administrator runs script** to create repository
6. **Script uses GitHub API** to:
   - Create repository
   - Add README
   - Protect branches
   - Set permissions
7. **Administrator comments** `/done` to close issue

### Admin Access Request Flow

1. **User submits issue** requesting access
2. **GitHub Actions parses** the request
3. **Workflow labels issue** for review
4. **Workflow posts comment** with summary
5. **Administrator reviews** the justification
6. **Administrator grants access** manually in GitHub settings
7. **Administrator comments** `/approve` or `/deny`
8. **Workflow closes issue** with appropriate label

## Security Model

### Authentication
- Uses GitHub CLI authentication (`gh auth`)
- Requires valid GitHub token with appropriate scopes

### Authorization
- Scripts require admin permissions to create/modify repositories
- Branch protection requires admin access
- Manual approval required for sensitive operations

### Audit Trail
- All requests tracked in GitHub Issues
- Issue comments document actions taken
- Labels indicate status (approved, denied, completed)

## Extension Points

### Adding New Issue Types

1. Create new template in `.github/ISSUE_TEMPLATE/`
2. Add corresponding job in `issue-automation.yml`
3. Create helper script if needed
4. Update documentation

### Custom Branch Protection Rules

1. Modify `configure-branch-protection.sh`
2. Add options for new rules
3. Update `config.yml` defaults
4. Document in README

### Integration with External Systems

Potential integrations:
- Slack notifications
- Jira ticket creation
- Custom approval workflows
- Monitoring and alerting

## Technology Stack

- **GitHub Issues**: User interface
- **GitHub Actions**: Automation engine
- **GitHub API**: Repository operations
- **GitHub CLI**: Command-line interface
- **Bash**: Scripting language
- **YAML**: Configuration format

## Best Practices

1. **Idempotency**: Scripts can be run multiple times safely
2. **Error Handling**: Scripts validate inputs and handle failures
3. **Logging**: Scripts provide colored output for clarity
4. **Documentation**: Inline comments explain complex logic
5. **Security**: Tokens never committed to repository

## Future Enhancements

Potential improvements:
- Fully automated repository creation (no manual step)
- Integration with LDAP/Active Directory
- Custom approval workflows
- Repository templates
- Automated compliance checks
- Analytics dashboard
- Webhook integrations
