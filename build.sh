#!/bin/bash

# Clone Flutter stable version
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Set path
export PATH="$PATH:`pwd`/flutter/bin"

# Check version (important fix)
flutter --version

# Enable web
flutter config --enable-web

# Clean & get packages
flutter clean
flutter pub get

# Build web
flutter build web