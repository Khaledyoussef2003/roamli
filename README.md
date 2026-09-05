# ROAMLI Flutter — Full Mock-Mode Build

**ROAMLI — Your trip. Your way.**

This project implements the approved ROAMLI product direction in Flutter for iOS and Android. It is intentionally **API-ready but API-independent**: the app can be developed and reviewed with local data first, then Google Places/Maps, authentication, weather, subscriptions, push notifications and backend services can be connected without redesigning the UI.

## Implemented flows

- Animated ROAMLI splash foundation with light/dark behavior.
- Three-step onboarding.
- Auth hub: Apple, Google, Email, Sign In, Continue as Guest (mock behavior until providers are connected).
- Seven-step Travel Preferences flow with profile defaults.
- Home with personalized greeting, quick actions, upcoming trip, recommendations and trending destinations.
- Persistent main navigation: **Home · Explore · Planner · Saved · Profile**.
- Explore list/map mock mode with Places, Restaurants, Experiences, Hidden Gems, Nearby, search, filters, Open Now, price and explicit **Search this area**.
- Exact place model built around `placeId` + coordinates for future branch-safe Google Places integration.
- Plan a Trip flow: Destination → Dates → Your Stay → Travelers → Trip Preferences → Budget → Review → Build My Trip.
- Stay options: exact property, manual address, not booked yet, help me choose; optional daily route anchor.
- Trip-only preference override does not overwrite profile defaults.
- Trip build state uses **“We’re putting your trip together…”** instead of AI-centric copy.
- My Trip: Overview, day-by-day itinerary, reorder/remove/add stops, route map placeholder, costs, stay anchor and explicit re-optimization confirmation when a stay changes.
- Place detail, save, Add to Trip, directions placeholder, and safe external reservation semantics.
- Saved: places, collections and trips.
- Profile: Omar Youssef mock identity, stats, preferences, ROAMLI+, notifications, appearance, privacy/data and support surfaces.
- ROAMLI+ mock paywall and gating foundation; pricing remains intentionally placeholder.
- Notifications and weather-alert examples without claiming reservation confirmation.
- Approved system/edge state gallery for loading, offline, location, empty states, unavailable places, errors, friendly throttling, ROAMLI+ lock, maintenance, connection loss, region limitations and invalid links.
- SharedPreferences persistence for theme, onboarding, guest mode, preference completion and saved place IDs.

## Product rules locked in code

- User-facing copy sells the travel experience, not the underlying AI.
- Never identify a branch only by business name; production places use exact Place ID and coordinates.
- A known stay can be the daily route start/end anchor.
- Changing stay never silently destroys an itinerary; re-optimization is explicit.
- ROAMLI does **not** claim restaurant bookings are confirmed without a verified integrated source.
- Reserve a Table opens a verified external booking URL when available, otherwise use call/website/directions fallbacks.
- Free Explore remains useful; premium functionality is positioned as travel value rather than API-cost recovery.
- Google Places production integration should use field masks, lazy enrichment, explicit Search This Area, restricted keys, quotas and cost alerts.

## Run locally

A Flutter SDK is required on the development machine.

```bash
flutter pub get
flutter create --platforms=ios,android .
flutter test
flutter analyze
flutter run
```

The included `scripts/bootstrap_platforms.sh` performs the platform generation step if `android/` and `ios/` are not present.

## API integration later

The service boundaries are in `lib/core/services/services.dart`. Production integrations can replace mock implementations for:

- Google Places (New) / Maps SDK
- Routes API
- Weather API
- Apple / Google / Email authentication
- Push notifications
- App Store / Google Play subscriptions
- ROAMLI backend sync

`lib/core/config/app_config.dart` contains compile-time configuration placeholders. Do **not** put unrestricted or server-secret keys inside Dart source.

Example development mode:

```bash
flutter run --dart-define=ROAMLI_MOCK_MODE=true
```

Later backend mode:

```bash
flutter run \
  --dart-define=ROAMLI_MOCK_MODE=false \
  --dart-define=ROAMLI_API_BASE_URL=https://your-api.example.com
```

## Current validation note

This environment does not include the Flutter SDK, so `flutter analyze`, widget tests and native iOS/Android compilation cannot be executed here. The source has been structurally checked and kept dependency-light; the final device-validation pass must be run on a machine or CI runner with Flutter installed before release.
