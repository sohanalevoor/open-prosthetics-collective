#!/usr/bin/env bash
# One-command script to push this repository to GitHub (Owner: sohanalevoor)
set -e

REPO_NAME="${1:-open-prosthetics-collective}"
GITHUB_USER="sohanalevoor"

echo "Configuring remote origin for https://github.com/${GITHUB_USER}/${REPO_NAME}.git ..."
git branch -M main
if git remote | grep -q "^origin$"; then
  git remote set-url origin "https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
else
  git remote add origin "https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
fi

echo "Pushing main branch to GitHub..."
git push -u origin main
echo "Successfully pushed to https://github.com/${GITHUB_USER}/${REPO_NAME}!"
