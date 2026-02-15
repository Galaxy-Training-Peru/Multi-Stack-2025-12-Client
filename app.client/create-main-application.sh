#!/bin/bash

# Step 1: Create Angular base project

APP_NAME="ng-library-client"
ORG="Multi-Stack-2025-12"
GITHUB_TOKEN=""

export NG_CLI_ANALYTICS=false

# Check if project already exists
if [ -d "$APP_NAME" ]; then
  echo "Project $APP_NAME already exists, skipping creation"
  cd $APP_NAME
else
  echo "Creating Angular project: $APP_NAME"
  
  npx -p @angular/cli ng new $APP_NAME \
    --routing=true \
    --style=scss \
    --standalone=true \
    --skip-git=false \
    --package-manager=npm
  
  if [ ! -d "$APP_NAME" ]; then
    echo "ERROR: Project not created"
    exit 1
  fi
  
  cd $APP_NAME
  
  git add .
  git commit -m "feat: initial Angular project setup" > /dev/null 2>&1
fi

# Check if remote exists
if git remote get-url origin > /dev/null 2>&1; then
  echo "GitHub repository already configured"
else
  export GITHUB_TOKEN="$GITHUB_TOKEN"
  gh repo create "$ORG/$APP_NAME" --public --source=. --remote=origin --push > /dev/null 2>&1
  
  if [ $? -eq 0 ]; then
    echo "Project created: https://github.com/$ORG/$APP_NAME"
  fi
fi

# Step 2: Install Angular Material with custom colors
# Note: Color palettes are generated from primary: #1C2C44, secondary: #5A81BA, tertiary: #8BA7CF, neutral: #DCE4F0
if grep -q "@angular/material" package.json 2>/dev/null; then
  echo "Angular Material already installed"
else
  echo "Installing Angular Material"
  npx -p @angular/cli ng add @angular/material
fi