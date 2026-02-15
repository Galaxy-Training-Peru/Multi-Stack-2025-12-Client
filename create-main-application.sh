#!/bin/bash

# Step 1: Create Angular base project

APP_NAME="ng-library-client"
ORG="Multi-Stack-2025-12"
GITHUB_TOKEN="<YOUR_GITHUB_TOKEN>"

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