#!/bin/bash

echo "Working directory: $(pwd)"

if [[ -z $(git status --porcelain) ]]; then
  echo "No changes to commit."
else
  git add -A

  echo "Enter commit message:"
  read msg

  git commit -m "$msg"

  git push origin main
fi
