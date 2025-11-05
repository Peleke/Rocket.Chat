#!/bin/bash
# Rocket.Chat Development Environment Setup
# Complete setup script for Rocket.Chat monorepo development

set -e  # Exit on error

echo "🚀 Rocket.Chat Development Setup"
echo "================================="
echo ""

# ============================================================================
# STAGE 1: Install Node.js via nvm
# ============================================================================
echo "📦 Installing Node.js 22.16.0 via nvm..."

# Install nvm if not already installed
if [ ! -d "$HOME/.nvm" ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use Node 22.16.0
nvm install 22.16.0
nvm use 22.16.0

echo "✅ Node $(node --version) installed"
echo ""

# ============================================================================
# STAGE 2: Enable Yarn 4
# ============================================================================
echo "📦 Enabling Yarn 4.10.3..."

corepack enable
yarn --version

echo "✅ Yarn $(yarn --version) enabled"
echo ""

# ============================================================================
# STAGE 3: Install Dependencies
# ============================================================================
echo "📦 Installing 3,333 packages (this may take a few minutes)..."

yarn install

echo "✅ Dependencies installed"
echo ""

# ============================================================================
# STAGE 4: Install Meteor
# ============================================================================
echo "🌠 Installing Meteor 3.3.2..."

# Install Meteor if not already installed
if ! command -v meteor &> /dev/null; then
	curl https://install.meteor.com/ | sh
fi

# Add Meteor to PATH for this session
export PATH="$HOME/.meteor:$PATH"

echo "✅ Meteor $(meteor --version) installed"
echo ""

# ============================================================================
# STAGE 5: Install Deno (Required for apps-engine)
# ============================================================================
echo "🦕 Installing Deno runtime..."

# Install Deno if not already installed
if [ ! -d "$HOME/.deno" ]; then
	curl -fsSL https://deno.land/install.sh | sh
fi

# Add Deno to PATH for this session
export PATH="$HOME/.meteor:$PATH:$HOME/.deno/bin"

echo "✅ Deno installed"
echo ""

# ============================================================================
# STAGE 6: Build All Packages
# ============================================================================
echo "🔨 Building all 69 packages (this will take ~6 minutes)..."

yarn build

echo "✅ All packages built successfully"
echo ""

# ============================================================================
# Setup Complete
# ============================================================================
echo "================================="
echo "✅ Setup Complete!"
echo "================================="
echo ""
echo "To start the development server:"
echo ""
echo "  cd apps/meteor"
echo "  export PATH=\"\$HOME/.meteor:\$PATH:\$HOME/.deno/bin\""
echo "  meteor"
echo ""
echo "The app will be available at: http://localhost:3000"
echo ""
echo "📚 Next steps:"
echo "  - Review docs/WALKTHROUGH.md for detailed info"
echo "  - Check docs/BUGS.md for quick win opportunities"
echo "  - Explore .claude/CLAUDE.md for project guide"
echo ""
