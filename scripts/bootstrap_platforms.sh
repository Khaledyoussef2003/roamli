#!/usr/bin/env bash
set -euo pipefail
# Run once on a machine with Flutter installed to generate native iOS/Android runners.
flutter create --platforms=ios,android --org com.roamli .
flutter pub get
