#!/usr/bin/env bash
set -euo pipefail

REPO="brianhartsock/ansible-role-prezto"
BRANCH="master"
REQUIRED_CHECKS=("Lint" "Molecule")

CHECK_ONLY=false
if [[ "${1:-}" == "--check" ]]; then
    CHECK_ONLY=true
fi

echo "Repository: $REPO"
echo "Branch:     $BRANCH"
echo "Required:   ${REQUIRED_CHECKS[*]}"
echo

# Fetch current branch protection
echo "=== Current Branch Protection ==="
PROTECTION=$(gh api "repos/$REPO/branches/$BRANCH/protection" 2>/dev/null || echo "none")

if [[ "$PROTECTION" == "none" ]]; then
    echo "No branch protection rules configured."
    CURRENT_CHECKS=()
else
    CURRENT_CHECKS=($(echo "$PROTECTION" | jq -r '.required_status_checks.contexts[]? // empty' 2>/dev/null))
    if [[ ${#CURRENT_CHECKS[@]} -eq 0 ]]; then
        echo "Branch protection exists but no required status checks."
    else
        echo "Current required checks:"
        for check in "${CURRENT_CHECKS[@]}"; do
            echo "  - $check"
        done
    fi
fi
echo

# Report missing checks
MISSING=()
for check in "${REQUIRED_CHECKS[@]}"; do
    found=false
    for current in "${CURRENT_CHECKS[@]+"${CURRENT_CHECKS[@]}"}"; do
        if [[ "$current" == "$check" ]]; then
            found=true
            break
        fi
    done
    if [[ "$found" == "false" ]]; then
        MISSING+=("$check")
    fi
done

if [[ ${#MISSING[@]} -eq 0 ]]; then
    echo "All required checks are configured."
    exit 0
fi

echo "Missing checks:"
for check in "${MISSING[@]}"; do
    echo "  - $check"
done
echo

if [[ "$CHECK_ONLY" == "true" ]]; then
    echo "Run without --check to apply changes."
    exit 1
fi

# Build the required_status_checks JSON
CHECKS_JSON=$(printf '%s\n' "${REQUIRED_CHECKS[@]}" | jq -R . | jq -s .)

echo "=== Configuring Branch Protection ==="
gh api "repos/$REPO/branches/$BRANCH/protection" \
    --method PUT \
    --input - <<EOF
{
    "required_status_checks": {
        "strict": true,
        "contexts": $CHECKS_JSON
    },
    "enforce_admins": false,
    "required_pull_request_reviews": null,
    "restrictions": null
}
EOF

echo
echo "=== Verifying Configuration ==="
UPDATED=$(gh api "repos/$REPO/branches/$BRANCH/protection/required_status_checks")
echo "Required checks after update:"
echo "$UPDATED" | jq -r '.contexts[]'
echo
echo "Branch protection configured successfully."
