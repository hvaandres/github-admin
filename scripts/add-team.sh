#!/bin/bash

# Add Team to Repository Script
# Usage: ./add-team.sh <owner/repo> <team-slug> <permission>
# Permissions: pull, push, admin, maintain, triage

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

# Parse arguments
REPO=$1
TEAM_SLUG=$2
PERMISSION=${3:-push}

if [ -z "$REPO" ] || [ -z "$TEAM_SLUG" ]; then
    echo -e "${RED}Error: Repository and team name are required.${NC}"
    echo "Usage: $0 <owner/repo> <team-slug> <permission>"
    echo "Permissions: pull, push, admin, maintain, triage"
    exit 1
fi

# Extract organization from repo
ORG=$(echo "$REPO" | cut -d'/' -f1)

echo -e "${YELLOW}Adding team ${TEAM_SLUG} to ${REPO} with ${PERMISSION} permission...${NC}"

# Add team to repository using GitHub API
gh api "orgs/${ORG}/teams/${TEAM_SLUG}/repos/${REPO}" \
    --method PUT \
    --field permission="$PERMISSION"

echo -e "${GREEN}✓ Successfully added team ${TEAM_SLUG} to the repository${NC}"
