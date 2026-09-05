# ROAMLI Locked Design & Product Decisions

This file is the implementation source of truth for the approved Steps 1–17.

## Brand
- Name: ROAMLI
- Tagline: “Your trip. Your way.”
- Coral `#FF6542`, Coral Soft `#FF9A5A`, Midnight `#101828`, Journey Sand `#FFF8EF`, Explorer Green `#32B67A`, Slate `#667085`, Sky Blue `#4EA8DE`.
- Dark background `#08111F`, card `#101D2E`, elevated card `#17263A`.
- Display/headings: Manrope. Body/forms/buttons: Inter. If font assets are not bundled yet, platform fallbacks are temporary only.
- All major app surfaces support light and dark modes.

## Product voice
Avoid repeated “AI-powered” marketing in the UI. Preferred copy includes “Plan your next trip with us”, “Recommended for You”, “Build My Trip” and “We’re putting your trip together…”. Technology can be explained in store/privacy/about contexts, not as the main UX voice.

## Navigation
Persistent bottom navigation on main surfaces: **Home · Explore · Planner · Saved · Profile** with an emphasized coral Planner action. Hide it in focused flows such as onboarding, auth, preferences and the trip wizard, with clear back/close controls.

## Preferences
Profile preferences are defaults for future trips. Per-trip changes remain scoped to that trip unless the user explicitly saves them back to the profile.

## Trip flow
Destination → Dates → Your Stay → Travelers → Trip Preferences → Budget → Review → Build My Trip.

Your Stay supports exact property search, manual address, not booked yet and help me choose. Production identity must use exact Place ID + coordinates. A known stay can be the daily start/end route anchor. If no stay is known, trip creation still works. When the stay changes later, offer explicit route re-optimization instead of silently rebuilding the itinerary.

## Places and branches
Google Places (New) is the planned source of truth. Never identify a restaurant/hotel/place branch only by name. ROAMLI-owned metadata is stored around the provider Place ID.

## Reservations
ROAMLI currently does not verify restaurant reservation status. Never show “Reservation confirmed”, “Reserved” or “Booking successful” unless a future verified integration actually confirms it. Reserve a Table opens a verified external booking link; if unavailable, offer Call Restaurant, then website/directions fallbacks.

## API-cost architecture
- Debounced autocomplete only during active search.
- Minimal fields first, richer details/photos lazily.
- Explicit “Search this area” instead of firing paid searches on every map movement.
- Field masks and backend quotas/budget alerts.
- Restricted platform keys and protected server-side calls.
- Cache only where provider terms allow.

## ROAMLI+
Free remains useful. Premium can unlock deeper discovery, advanced filters, more trip plans, stronger itinerary optimization, offline access, expanded saves/collections and priority support. Pricing stays placeholder until real operating costs are modeled. Never explain premium as paying for API bills.

## Notifications
Trip reminders, itinerary/place reminders, weather alerts, saved-place updates, recommendations, offers/news and system updates. Quiet hours and granular toggles. No false booking confirmations.

## Mock data
Use **Omar Youssef** everywhere in development/demo data. Mock identity and seed data should remain centralized so authenticated production data can replace it cleanly.
