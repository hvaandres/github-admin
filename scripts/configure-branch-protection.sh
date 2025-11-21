#!/bin/bash

# Configure Branch Protection Script
# Usage: ./configure-branch-protection.sh <owner/repo> <branch> [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    exit 1
fi

# Default values
REQUIRE_REVIEWS=true
REQUIRED_REVIEWERS=1
DISMISS_STALE_REVIEWS=true
REQUIRE_CODE_OWNER_REVIEWS=false
REQUIRE_STATUS_CHECKS=false
ENFORCE_ADMINS=false
REQUIRE_LINEAR_HISTORY=false
REQUIRE_SIGNED_COMMITS=false
REQUIRE_CONVERSATION_RESOLUTION=true
ALLOW_FORCE_PUSHES=false
ALLOW_DELETIONS=false

# Parse arguments
REPO=$1
BRANCH=${2:-main}

if [ -z "$REPO" ]; then
    echo -e "${RED}Error: Repository is required.${NC}"
    echo "Usage: $0 <owner/repo> <branch>"
    exit 1
fi

shift 2 2>/dev/null || shift 1

# Parse optional flags
while [[ $# -gt 0 ]]; do
    case $1 in
        --required-reviewers)
            REQUIRED_REVIEWERS="$2"
            shift 2
            ;;
        --enforce-admins)
            ENFORCE_ADMINS=true
            shift
            ;;
        --require-code-owners)
            REQUIRE_CODE_OWNER_REVIEWS=true
            shift
            ;;
        --require-linear-history)
            REQUIRE_LINEAR_HISTORY=true
            shift
            ;;
        --require-signed-commits)
            REQUIRE_SIGNED_COMMITS=true
            shift
            ;;
        --no-conversation-resolution)
            REQUIRE_CONVERSATION_RESOLUTION=false
            shift
            ;;
        --allow-force-pushes)
            ALLOW_FORCE_PUSHES=true
            shift
            ;;
        *)
            echo -e "${YELLOW}Unknown option: $1${NC}"
            shift
            ;;
    esac
done

echo -e "${YELLOW}Configuring branch protection for ${REPO}:${BRANCH}...${NC}"

# Build the protection configuration
gh api "repos/${REPO}/branches/${BRANCH}/protection" \
    --method PUT \
    --field required_status_checks='null' \
    --field enforce_admins="$ENFORCE_ADMINS" \
    --field required_pull_request_reviews[required_approving_review_count]="$REQUIRED_REVIEWERS" \
    --field required_pull_request_reviews[dismiss_stale_reviews]="$DISMISS_STALE_REVIEWS" \
    --field required_pull_request_reviews[require_code_owner_reviews]="$REQUIRE_CODE_OWNER_REVIEWS" \
    --field restrictions='null' \
    --field required_linear_history="$REQUIRE_LINEAR_HISTORY" \
    --field allow_force_pushes="$ALLOW_FORCE_PUSHES" \
    --field allow_deletions="$ALLOW_DELETIONS" \
    --field required_conversation_resolution="$REQUIRE_CONVERSATION_RESOLUTION"

if [ "$REQUIRE_SIGNED_COMMITS" = true ]; then
    gh api "repos/${REPO}/branches/${BRANCH}/protection/required_signatures" \
        --method POST || echo -e "${YELLOW}Warning: Could not enable signed commits${NC}"
fi

echo -e "${GREEN}✓ Branch protection configured successfully${NC}"
echo ""
echo "Configuration:"
echo "  Required reviewers: $REQUIRED_REVIEWERS"
echo "  Enforce for admins: $ENFORCE_ADMINS"
echo "  Require code owner reviews: $REQUIRE_CODE_OWNER_REVIEWS"
echo "  Require linear history: $REQUIRE_LINEAR_HISTORY"
echo "  Require signed commits: $REQUIRE_SIGNED_COMMITS"
echo "  Require conversation resolution: $REQUIRE_CONVERSATION_RESOLUTION"
