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

if [ -f "src/theme/default/theme.scss" ]; then
  echo "Default theme already exists"
else
  echo "Generating default theme"
  mkdir -p src/theme/default
  npx -p @angular/cli ng generate @angular/material:m3-theme \
    --primary-color="#1C2C44" \
    --secondary-color="#5A81BA" \
    --tertiary-color="#8BA7CF" \
    --neutral-color="#DCE4F0" \
    --neutral-variant-color="#1C2C44" \
    --error-color="#B3261E" \
    --include-high-contrast=true \
    --is-scss=true \
    --directory="src/theme/default" \
    --defaults
  
  mv src/theme/default_theme-colors.scss src/theme/default/theme.scss 2>/dev/null || true
fi

if [ -f "src/theme/orange/theme.scss" ]; then
  echo "Orange theme already exists"
else
  echo "Generating orange theme"
  mkdir -p src/theme/orange
  npx -p @angular/cli ng generate @angular/material:m3-theme \
    --primary-color="#F57C00" \
    --secondary-color="#FF9800" \
    --tertiary-color="#FFB74D" \
    --neutral-color="#FFF3E0" \
    --neutral-variant-color="#F57C00" \
    --error-color="#B3261E" \
    --include-high-contrast=true \
    --is-scss=true \
    --directory="src/theme/orange" \
    --defaults
  
  mv src/theme/orange_theme-colors.scss src/theme/orange/theme.scss 2>/dev/null || true
fi

if [ -f "src/theme/purple/theme.scss" ]; then
  echo "Purple theme already exists"
else
  echo "Generating purple theme"
  mkdir -p src/theme/purple
  npx -p @angular/cli ng generate @angular/material:m3-theme \
    --primary-color="#6A1B9A" \
    --secondary-color="#9C27B0" \
    --tertiary-color="#BA68C8" \
    --neutral-color="#F3E5F5" \
    --neutral-variant-color="#6A1B9A" \
    --error-color="#B3261E" \
    --include-high-contrast=true \
    --is-scss=true \
    --directory="src/theme/purple" \
    --defaults
  
  mv src/theme/purple_theme-colors.scss src/theme/purple/theme.scss 2>/dev/null || true
fi

echo "Done"

# Step 4: Generate library projects (future microfrontends)
LIBRARIES=("library-authors" "library-books" "library-catalog")

for LIB in "${LIBRARIES[@]}"; do
  if [ -d "projects/$LIB" ]; then
    echo "Library '$LIB' already exists, skipping"
  else
    echo "Generating library: $LIB"
    npx -p @angular/cli ng generate library $LIB \
      --prefix="lib" \
      --standalone
  fi
done