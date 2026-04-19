#!/bin/bash

# Flutter install
git clone https://github.com/flutter/flutter.git --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web
flutter config --enable-web

# Get dependencies
flutter pub get

# Build web
flutter build web