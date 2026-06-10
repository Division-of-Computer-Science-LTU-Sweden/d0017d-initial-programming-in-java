#!/bin/bash

# Install pre-commit hook to protect critical environment files
HOOK=.git/hooks/pre-commit
cat > $HOOK << 'EOF'
#!/bin/bash
protected=(
  ".devcontainer/devcontainer.json"
  ".devcontainer/setup.sh"
  ".gitignore"
)
for file in "${protected[@]}"; do
  if git diff --cached --name-only --diff-filter=D | grep -q "^$file$"; then
    echo ""
    echo "❌ Cannot delete '$file' — this file is required for your coding environment."
    echo "   Restore it and try again. If something is broken, ask your teacher for help."
    echo ""
    exit 1
  fi
done
EOF
chmod +x $HOOK

# Add a direct return button to the README using this Codespace's unique URL
if [ -n "$CODESPACE_NAME" ]; then
  BUTTON="[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/${CODESPACE_NAME})"
  sed -i "s|<!-- CODESPACE_BUTTON_PLACEHOLDER -->|${BUTTON}|g" README.md
  git add README.md
  git diff --cached --quiet || git commit -m "chore: add Codespace return button to README"
  git push 2>/dev/null || true
fi
