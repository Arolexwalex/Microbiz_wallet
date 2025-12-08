#!/usr/bin/env bash
# Exit the script if any command fails
set -e

# The directory to install Flutter into
FLUTTER_DIR="$HOME/flutter"

# Clone the Flutter repository if it doesn't exist
if [ ! -d "$FLUTTER_DIR" ]; then
  git clone -b stable https://github.com/flutter/flutter.git --depth 1 "$FLUTTER_DIR"
fi

# Add the Flutter bin directory to the PATH
export PATH="$FLUTTER_DIR/bin:$PATH"

# Verify Flutter and enable web support
flutter --version
flutter config --enable-web

# Get dependencies and build the web app for release
flutter pub get
flutter build web --release --dart-define=FLUTTER_WEB_RENDERER=html