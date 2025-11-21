#!/bin/bash

# Repository Creation and Configuration Script
# Usage: ./create-repo.sh <repo-name> <visibility> <protected-branch> <description> [owner/org]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub CLI.${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Parse arguments
REPO_NAME=$1
VISIBILITY=${2:-private}
PROTECTED_BRANCH=${3:-main}
DESCRIPTION=$4
OWNER_ORG=${5:-$(gh api user -q .login)}

if [ -z "$REPO_NAME" ]; then
    echo -e "${RED}Error: Repository name is required.${NC}"
    echo "Usage: $0 <repo-name> <visibility> <protected-branch> <description> [owner/org]"
    exit 1
fi

echo -e "${GREEN}Creating repository: ${OWNER_ORG}/${REPO_NAME}${NC}"

# Create the repository
if [ "$VISIBILITY" = "private" ]; then
    gh repo create "${OWNER_ORG}/${REPO_NAME}" --private --description "$DESCRIPTION" --clone=false
else
    gh repo create "${OWNER_ORG}/${REPO_NAME}" --public --description "$DESCRIPTION" --clone=false
fi

echo -e "${GREEN}✓ Repository created successfully${NC}"

# Wait a moment for the repo to be fully created
sleep 2

# Create initial README
echo -e "${YELLOW}Creating initial README...${NC}"
README_CONTENT="# ${REPO_NAME}

${DESCRIPTION}

## Getting Started

This repository was created through the automated repository management system.

## Branch Protection

This repository has branch protection enabled on the \`${PROTECTED_BRANCH}\` branch.

## Contributing

Please follow the contribution guidelines and ensure all pull requests are reviewed before merging.
"

# Create README using GitHub API
echo "$README_CONTENT" | gh api "repos/${OWNER_ORG}/${REPO_NAME}/contents/README.md" \
    --method PUT \
    --field message="Initial commit: Add README" \
    --field content="$(echo "$README_CONTENT" | base64)" \
    --field branch="$PROTECTED_BRANCH" || echo -e "${YELLOW}Warning: Could not create README via API${NC}"

echo -e "${GREEN}✓ README created${NC}"

# Wait for the branch to be created
sleep 2

# Configure branch protection
echo -e "${YELLOW}Configuring branch protection for '${PROTECTED_BRANCH}'...${NC}"

# Create branch protection rule
gh api "repos/${OWNER_ORG}/${REPO_NAME}/branches/${PROTECTED_BRANCH}/protection" \
    --method PUT \
    --field required_status_checks='null' \
    --field enforce_admins=false \
    --field required_pull_request_reviews[required_approving_review_count]=1 \
    --field required_pull_request_reviews[dismiss_stale_reviews]=true \
    --field required_pull_request_reviews[require_code_owner_reviews]=false \
    --field restrictions='null' \
    --field required_linear_history=false \
    --field allow_force_pushes=false \
    --field allow_deletions=false \
    --field required_conversation_resolution=true || echo -e "${YELLOW}Warning: Could not fully configure branch protection. You may need to configure it manually.${NC}"

echo -e "${GREEN}✓ Branch protection configured${NC}"

echo -e "${GREEN}Repository setup complete!${NC}"
echo -e "Repository URL: https://github.com/${OWNER_ORG}/${REPO_NAME}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Add collaborators: ./scripts/add-collaborator.sh ${OWNER_ORG}/${REPO_NAME} <username> <permission>"
echo "2. Add teams: ./scripts/add-team.sh ${OWNER_ORG}/${REPO_NAME} <team-name> <permission>"
echo "3. Clone the repository: gh repo clone ${OWNER_ORG}/${REPO_NAME}"
