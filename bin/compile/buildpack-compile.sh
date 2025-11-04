#!/bin/bash
# This is a minimal buildpack compile script
# Save this as bin/compile in a new git repository to create a custom buildpack
# Also copy bin/prepare-shared to the same bin/ directory

set -e

# Get the buildpack's bin directory
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the prepare-shared script if it exists
if [ -f "$BIN_DIR/prepare-shared" ]; then
  source "$BIN_DIR/prepare-shared"
else
  echo "       WARNING: prepare-shared script not found in $BIN_DIR"
  echo "       Make sure bin/prepare-shared exists in your buildpack"
fi

# Exit successfully - this buildpack just prepares the shared folder
# The monorepo buildpack will handle the actual app copying

