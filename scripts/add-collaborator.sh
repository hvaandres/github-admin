#!/bin/bash

# Add Collaborator to Repository Script
# Usage: ./add-collaborator.sh <owner/repo> <username> <permission>
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
USERNAME=$2
PERMISSION=${3:-push}

if [ -z "$REPO" ] || [ -z "$USERNAME" ]; then
    echo -e "${RED}Error: Repository and username are required.${NC}"
    echo "Usage: $0 <owner/repo> <username> <permission>"
    echo "Permissions: pull, push, admin, maintain, triage"
    exit 1
fi

# Remove @ prefix if present
USERNAME=${USERNAME#@}

echo -e "${YELLOW}Adding ${USERNAME} to ${REPO} with ${PERMISSION} permission...${NC}"

# Add collaborator using GitHub API
gh api "repos/${REPO}/collaborators/${USERNAME}" \
    --method PUT \
    --field permission="$PERMISSION"

echo -e "${GREEN}✓ Successfully added ${USERNAME} as a collaborator${NC}"
echo "The user will receive an invitation to join the repository."
