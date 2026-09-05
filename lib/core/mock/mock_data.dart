import 'package:flutter/material.dart';
import '../models/models.dart';

abstract final class MockData {
  static const userName = 'Omar Youssef';
  static const username = '@omarroamli';

  static const preferences = TravelPreferences(
    styles: {'Balanced'},
    interests: {'Food & Drinks', 'Nature', 'Beaches', 'Culture & History', 'Hidden Gems'},
    food: {'Local Cuisine', 'Fine Dining', 'Cafés', 'Healthy', 'Halal'},
    budget: 'Moderate',
    pace: 'Balanced',
    companion: 'Friends',
    transport: {'Walking', 'Taxi / Ride-hailing'},
  );

  static const canaves = PlaceRef(
    placeId: 'mock_canaves_oia',
    name: 'Canaves Oia Suites',
    category: 'Stay',
    subtitle: 'Oia, Santorini, Greece',
    location: GeoPoint(36.4618, 25.3753),
    rating: 4.8,
    priceLevel: r'$$$$',
    website: 'https://example.com',
    openNow: true,
    description: 'Clifftop stay overlooking the caldera and Aegean Sea.',
    estimatedCost: 420,
  );

  static const pelekanos = PlaceRef(
    placeId: 'mock_pelekanos_oia',
    name: 'Pelekanos',
    category: 'Restaurant',
    subtitle: 'Oia, Santorini · 0.4 km',
    location: GeoPoint(36.4615, 25.3758),
    rating: 4.8,
    priceLevel: r'$$$',
    phone: '+302286071513',
    bookingUrl: 'https://example.com/reserve',
    openNow: true,
    description: 'Greek favorites with a sunset terrace in the heart of Oia.',
    estimatedCost: 55,
  );

  static const oia = PlaceRef(
    placeId: 'mock_oia',
    name: 'Oia Village',
    category: 'Place',
    subtitle: 'Santorini · 1.2 km',
    location: GeoPoint(36.4618, 25.3753),
    rating: 4.8,
    openNow: true,
    description: 'Whitewashed lanes, blue domes, boutiques and iconic sunset viewpoints.',
    estimatedCost: 0,
  );

  static const fira = PlaceRef(
    placeId: 'mock_fira',
    name: 'Fira Town',
    category: 'Place',
    subtitle: 'Santorini · 3.4 km',
    location: GeoPoint(36.4166, 25.4324),
    rating: 4.6,
    openNow: true,
    description: 'The lively capital of Santorini with museums, cafés and caldera views.',
    estimatedCost: 15,
  );

  static const metaxi = PlaceRef(
    placeId: 'mock_metaxi',
    name: 'Metaxi Mas',
    category: 'Restaurant',
    subtitle: 'Exo Gonia · 1.3 km',
    location: GeoPoint(36.3975, 25.4511),
    rating: 4.6,
    priceLevel: r'$$',
    phone: '+302286031323',
    openNow: true,
    description: 'Local Cretan and Santorinian cooking in a relaxed village setting.',
    estimatedCost: 40,
  );

  static const redBeach = PlaceRef(
    placeId: 'mock_red_beach',
    name: 'Red Beach',
    category: 'Beach',
    subtitle: 'Akrotiri · 12 km',
    location: GeoPoint(36.3489, 25.3946),
    rating: 4.5,
    openNow: true,
    description: 'Dramatic volcanic cliffs frame one of Santorini’s most distinctive beaches.',
    estimatedCost: 0,
  );

  static const sailing = PlaceRef(
    placeId: 'mock_sailing',
    name: 'Caldera Sunset Sail',
    category: 'Experience',
    subtitle: 'Ammoudi Bay · 0.8 km',
    location: GeoPoint(36.4610, 25.3690),
    rating: 4.9,
    priceLevel: r'$$$',
    openNow: true,
    description: 'Small-group sailing with swimming stops, dinner and sunset views.',
    estimatedCost: 145,
  );

  static const hiddenGem = PlaceRef(
    placeId: 'mock_finikia',
    name: 'Finikia Village Walk',
    category: 'Hidden Gem',
    subtitle: 'Finikia · 1.8 km',
    location: GeoPoint(36.4635, 25.4015),
    rating: 4.7,
    openNow: true,
    description: 'A quieter maze of traditional houses and lanes away from Oia’s busiest paths.',
    estimatedCost: 0,
  );

  static const explore = [oia, fira, pelekanos, metaxi, redBeach, sailing, hiddenGem, canaves];

  static List<TripDay> itinerary() => [
    TripDay(
      dayNumber: 1,
      date: DateTime(2026, 9, 18),
      title: 'Oia & sunset',
      stops: const [
        ItineraryStop(id: 'd1s1', place: oia, time: '10:00 AM', note: 'Explore the lanes and viewpoints.'),
        ItineraryStop(id: 'd1s2', place: pelekanos, time: '1:00 PM', note: 'Lunch planned. Reservation handled externally.', travelMinutesFromPrevious: 7),
        ItineraryStop(id: 'd1s3', place: sailing, time: '4:30 PM', note: 'Arrive 20 minutes before departure.', travelMinutesFromPrevious: 12),
      ],
    ),
    TripDay(
      dayNumber: 2,
      date: DateTime(2026, 9, 19),
      title: 'Villages & local flavors',
      stops: const [
        ItineraryStop(id: 'd2s1', place: hiddenGem, time: '9:30 AM', note: 'Easy morning walk.'),
        ItineraryStop(id: 'd2s2', place: metaxi, time: '1:30 PM', note: 'Lunch stop.', travelMinutesFromPrevious: 24),
        ItineraryStop(id: 'd2s3', place: fira, time: '4:00 PM', note: 'Museum and evening stroll.', travelMinutesFromPrevious: 15),
      ],
    ),
    TripDay(
      dayNumber: 3,
      date: DateTime(2026, 9, 20),
      title: 'Beach day',
      stops: const [
        ItineraryStop(id: 'd3s1', place: redBeach, time: '10:30 AM', note: 'Bring water and comfortable footwear.'),
        ItineraryStop(id: 'd3s2', place: oia, time: '5:30 PM', note: 'Last evening in Oia.', travelMinutesFromPrevious: 35),
      ],
    ),
  ];


  // ----- Multi-destination demo trips for feature visibility -----
  static const dubaiStay = PlaceRef(
    placeId: 'mock_dubai_address', name: 'Address Sky View', category: 'Stay',
    subtitle: 'Downtown Dubai, UAE', location: GeoPoint(25.2016, 55.2692), rating: 4.7,
    priceLevel: r'$$$$', openNow: true, description: 'Premium Downtown stay used as the daily route anchor.', estimatedCost: 0,
  );
  static const dubaiFrame = PlaceRef(
    placeId: 'mock_dubai_frame', name: 'Dubai Frame', category: 'Place', subtitle: 'Zabeel Park · Dubai',
    location: GeoPoint(25.2355, 55.3004), rating: 4.6, openNow: true,
    description: 'Panoramic views connecting old and new Dubai.', estimatedCost: 55,
  );
  static const dubaiMuseum = PlaceRef(
    placeId: 'mock_museum_future', name: 'Museum of the Future', category: 'Experience', subtitle: 'Sheikh Zayed Road · Dubai',
    location: GeoPoint(25.2192, 55.2820), rating: 4.6, priceLevel: r'$$$', openNow: true,
    description: 'Immersive exhibitions focused on future technology and society.', estimatedCost: 155,
  );
  static const dubaiDinner = PlaceRef(
    placeId: 'mock_dubai_dinner', name: 'Skyline Dinner', category: 'Restaurant', subtitle: 'DIFC · Dubai',
    location: GeoPoint(25.2135, 55.2803), rating: 4.8, priceLevel: r'$$$$', openNow: true,
    bookingUrl: 'https://example.com/reserve', phone: '+97140000000',
    description: 'Premium dinner with an external reservation action.', estimatedCost: 420,
  );
  static const kiteBeach = PlaceRef(
    placeId: 'mock_kite_beach', name: 'Kite Beach', category: 'Beach', subtitle: 'Jumeirah · Dubai',
    location: GeoPoint(25.1612, 55.2083), rating: 4.6, openNow: true,
    description: 'Relaxed beach morning with cafés and skyline views.', estimatedCost: 0,
  );

  static const ibizaStay = PlaceRef(
    placeId: 'mock_ibiza_villa', name: 'Can Soleil Villa', category: 'Stay', subtitle: 'Sant Josep, Ibiza, Spain',
    location: GeoPoint(38.9224, 1.2940), rating: 4.8, priceLevel: r'$$$$', openNow: true,
    description: 'Private villa entered as an address rather than a hotel.', estimatedCost: 0,
  );
  static const calaComte = PlaceRef(
    placeId: 'mock_cala_comte', name: 'Cala Comte', category: 'Beach', subtitle: 'Sant Josep · Ibiza',
    location: GeoPoint(38.9620, 1.2237), rating: 4.8, openNow: true,
    description: 'Clear-water beach stop with sunset views.', estimatedCost: 0,
  );
  static const ibizaOldTown = PlaceRef(
    placeId: 'mock_dalt_vila', name: 'Dalt Vila', category: 'Place', subtitle: 'Ibiza Town · Spain',
    location: GeoPoint(38.9067, 1.4366), rating: 4.7, openNow: true,
    description: 'Historic hilltop old town and evening walk.', estimatedCost: 0,
  );
  static const ibizaClub = PlaceRef(
    placeId: 'mock_ibiza_club', name: 'Ibiza Night Experience', category: 'Nightlife', subtitle: 'Ibiza Town · Spain',
    location: GeoPoint(38.9180, 1.4430), rating: 4.5, priceLevel: r'$$$$', openNow: true,
    description: 'Late-night experience for the friends/nightlife demo.', estimatedCost: 260,
  );

  static const romeStay = PlaceRef(
    placeId: 'mock_rome_stay', name: 'Hotel Campo de’ Fiori', category: 'Stay', subtitle: 'Rome, Italy',
    location: GeoPoint(41.8957, 12.4722), rating: 4.7, priceLevel: r'$$$', openNow: true,
    description: 'First stay in a multi-city Italy draft.', estimatedCost: 0,
  );
  static const colosseum = PlaceRef(
    placeId: 'mock_colosseum', name: 'Colosseum', category: 'Culture & History', subtitle: 'Rome · Italy',
    location: GeoPoint(41.8902, 12.4922), rating: 4.8, openNow: true,
    description: 'Historic landmark and guided visit.', estimatedCost: 85,
  );
  static const florenceMarket = PlaceRef(
    placeId: 'mock_florence_market', name: 'Mercato Centrale', category: 'Food & Drinks', subtitle: 'Florence · Italy',
    location: GeoPoint(43.7767, 11.2531), rating: 4.6, openNow: true,
    description: 'Local-food stop used to showcase multi-city planning.', estimatedCost: 70,
  );
  static const veniceWalk = PlaceRef(
    placeId: 'mock_venice_walk', name: 'Cannaregio Walk', category: 'Hidden Gem', subtitle: 'Venice · Italy',
    location: GeoPoint(45.4453, 12.3264), rating: 4.7, openNow: true,
    description: 'Quieter neighborhood walk for local and photography preferences.', estimatedCost: 0,
  );

  static const pragueStay = PlaceRef(
    placeId: 'mock_prague_stay', name: 'Mosaic House Design Hotel', category: 'Stay', subtitle: 'Prague, Czech Republic',
    location: GeoPoint(50.0753, 14.4161), rating: 4.6, priceLevel: r'$$', openNow: true,
    description: 'Moderate stay for a budget-conscious solo trip.', estimatedCost: 0,
  );
  static const charlesBridge = PlaceRef(
    placeId: 'mock_charles_bridge', name: 'Charles Bridge', category: 'Culture & History', subtitle: 'Prague · Czech Republic',
    location: GeoPoint(50.0865, 14.4114), rating: 4.8, openNow: true,
    description: 'Early walking stop optimized for low-cost transport.', estimatedCost: 0,
  );
  static const pragueCastle = PlaceRef(
    placeId: 'mock_prague_castle', name: 'Prague Castle', category: 'Culture & History', subtitle: 'Prague · Czech Republic',
    location: GeoPoint(50.0909, 14.4005), rating: 4.7, openNow: true,
    description: 'Major historic stop with public-transport routing.', estimatedCost: 80,
  );
  static const pragueFood = PlaceRef(
    placeId: 'mock_prague_food', name: 'Local Czech Kitchen', category: 'Restaurant', subtitle: 'Old Town · Prague',
    location: GeoPoint(50.0870, 14.4210), rating: 4.5, priceLevel: r'$', openNow: true,
    description: 'Affordable local-food stop.', estimatedCost: 45,
  );

  static const littleVenice = PlaceRef(
    placeId: 'mock_little_venice', name: 'Little Venice', category: 'Place', subtitle: 'Mykonos Town · Greece',
    location: GeoPoint(37.4467, 25.3261), rating: 4.7, openNow: true,
    description: 'Waterfront walk and sunset views.', estimatedCost: 0,
  );
  static const mykonosBeach = PlaceRef(
    placeId: 'mock_psarou', name: 'Psarou Beach', category: 'Beach', subtitle: 'Mykonos · Greece',
    location: GeoPoint(37.4156, 25.3366), rating: 4.6, openNow: true,
    description: 'Luxury beach-day idea before a stay has been selected.', estimatedCost: 0,
  );
  static const mykonosDinner = PlaceRef(
    placeId: 'mock_mykonos_dinner', name: 'Mykonos Sunset Dining', category: 'Restaurant', subtitle: 'Mykonos Town · Greece',
    location: GeoPoint(37.4460, 25.3280), rating: 4.8, priceLevel: r'$$$$', openNow: true,
    phone: '+302289000000', description: 'Restaurant demo with call fallback when no booking URL exists.', estimatedCost: 280,
  );

  static List<DemoTrip> demoTrips() => [
    DemoTrip(
      id: 'trip_dubai', title: 'Dubai Luxe Weekend', destination: 'Dubai', country: 'United Arab Emirates',
      start: DateTime(2026, 10, 16), end: DateTime(2026, 10, 18), status: 'Planned', adults: 2,
      preferences: const TravelPreferences(styles: {'Luxury', 'Balanced'}, interests: {'Food & Drinks', 'Shopping', 'Nightlife', 'Entertainment'}, food: {'Fine Dining', 'Cafés', 'Halal'}, budget: 'Premium', pace: 'Balanced', companion: 'Couple', transport: {'Taxi / Ride-hailing'}),
      stay: dubaiStay, stayStatus: 'Exact hotel selected', stayCost: 3400, transportCost: 420,
      featureTags: {'Route anchor', 'External reservation', 'Weather', 'Offline'}, highlight: 'Premium couple trip with a complete stay-anchored itinerary.',
      itinerary: [
        TripDay(dayNumber: 1, date: DateTime(2026, 10, 16), title: 'Downtown & skyline', stops: const [
          ItineraryStop(id: 'dub1', place: dubaiMuseum, time: '10:30 AM', note: 'Timed attraction entry.'),
          ItineraryStop(id: 'dub2', place: dubaiDinner, time: '7:30 PM', note: 'Reserve through the external booking provider.', travelMinutesFromPrevious: 12),
        ]),
        TripDay(dayNumber: 2, date: DateTime(2026, 10, 17), title: 'Beach & city icons', stops: const [
          ItineraryStop(id: 'dub3', place: kiteBeach, time: '9:00 AM', note: 'Relaxed beach morning.'),
          ItineraryStop(id: 'dub4', place: dubaiFrame, time: '4:00 PM', note: 'Golden-hour city views.', travelMinutesFromPrevious: 20),
        ]),
      ],
    ),
    DemoTrip(
      id: 'trip_ibiza', title: 'Ibiza Friends Escape', destination: 'Ibiza', country: 'Spain',
      start: DateTime(2027, 6, 10), end: DateTime(2027, 6, 14), status: 'Draft', adults: 4,
      preferences: const TravelPreferences(styles: {'Relaxed', 'Adventure'}, interests: {'Beaches', 'Nightlife', 'Hidden Gems', 'Food & Drinks'}, food: {'Local Cuisine', 'Street Food', 'Cafés'}, budget: 'Premium', pace: 'Relaxed', companion: 'Friends', transport: {'Rental Car', 'Taxi / Ride-hailing'}),
      stay: ibizaStay, stayStatus: 'Villa address entered', stayCost: 6200, transportCost: 950,
      featureTags: {'Manual address', 'Nightlife', 'Saved restaurants', 'External booking'}, highlight: 'Friends trip showing a private-stay address, beaches and nightlife.',
      itinerary: [
        TripDay(dayNumber: 1, date: DateTime(2027, 6, 10), title: 'Old town & nightlife', stops: const [
          ItineraryStop(id: 'ibz1', place: ibizaOldTown, time: '5:00 PM', note: 'Dinner and old-town walk.'),
          ItineraryStop(id: 'ibz2', place: ibizaClub, time: '11:30 PM', note: 'Nightlife plan; entry handled externally.', travelMinutesFromPrevious: 18),
        ]),
        TripDay(dayNumber: 2, date: DateTime(2027, 6, 11), title: 'Beach reset', stops: const [
          ItineraryStop(id: 'ibz3', place: calaComte, time: '11:00 AM', note: 'Relaxed beach day and sunset.'),
        ]),
      ],
    ),
    DemoTrip(
      id: 'trip_italy', title: 'Italy Local Journey', destination: 'Rome · Florence · Venice', country: 'Italy',
      start: DateTime(2027, 4, 3), end: DateTime(2027, 4, 10), status: 'Draft', adults: 2,
      preferences: const TravelPreferences(styles: {'Local & Authentic', 'Balanced'}, interests: {'Food & Drinks', 'Culture & History', 'Photography', 'Hidden Gems'}, food: {'Local Cuisine', 'Street Food', 'Cafés'}, budget: 'Moderate', pace: 'Balanced', companion: 'Couple', transport: {'Walking', 'Public Transport'}),
      stay: romeStay, stayStatus: 'First city stay selected', stayCost: 5200, transportCost: 1100,
      featureTags: {'Multi-city', 'Changing stays', 'Train travel', 'Photography'}, highlight: 'Multi-city demo for route changes, local food and cultural planning.',
      itinerary: [
        TripDay(dayNumber: 1, date: DateTime(2027, 4, 3), title: 'Ancient Rome', stops: const [ItineraryStop(id: 'ita1', place: colosseum, time: '9:00 AM', note: 'Pre-booked time slot handled outside ROAMLI.')]),
        TripDay(dayNumber: 3, date: DateTime(2027, 4, 5), title: 'Florence flavors', stops: const [ItineraryStop(id: 'ita2', place: florenceMarket, time: '12:00 PM', note: 'Local lunch and market exploration.')]),
        TripDay(dayNumber: 6, date: DateTime(2027, 4, 8), title: 'Quiet Venice', stops: const [ItineraryStop(id: 'ita3', place: veniceWalk, time: '4:30 PM', note: 'Photography walk away from the busiest paths.')]),
      ],
    ),
    DemoTrip(
      id: 'trip_czech', title: 'Prague Smart Budget', destination: 'Prague', country: 'Czech Republic',
      start: DateTime(2027, 3, 12), end: DateTime(2027, 3, 15), status: 'Needs attention', adults: 1,
      preferences: const TravelPreferences(styles: {'Packed', 'Local & Authentic'}, interests: {'Culture & History', 'Photography', 'Food & Drinks'}, food: {'Local Cuisine', 'Healthy'}, budget: 'Budget', pace: 'Packed', companion: 'Solo', transport: {'Walking', 'Public Transport'}),
      stay: pragueStay, stayStatus: 'Hotel selected', stayCost: 1450, transportCost: 160,
      featureTags: {'Budget tracking', 'Public transport', 'Walking routes', 'Needs attention'}, highlight: 'Solo budget trip emphasizing walking, transit and cost visibility.',
      itinerary: [
        TripDay(dayNumber: 1, date: DateTime(2027, 3, 12), title: 'Old Prague on foot', stops: const [
          ItineraryStop(id: 'cz1', place: charlesBridge, time: '7:30 AM', note: 'Early start for fewer crowds.'),
          ItineraryStop(id: 'cz2', place: pragueFood, time: '12:30 PM', note: 'Affordable local lunch.', travelMinutesFromPrevious: 14),
          ItineraryStop(id: 'cz3', place: pragueCastle, time: '2:30 PM', note: 'Use tram for the uphill section.', travelMinutesFromPrevious: 18),
        ]),
      ],
    ),
    DemoTrip(
      id: 'trip_mykonos', title: 'Mykonos Summer Draft', destination: 'Mykonos', country: 'Greece',
      start: DateTime(2027, 7, 2), end: DateTime(2027, 7, 6), status: 'Draft', adults: 3,
      preferences: const TravelPreferences(styles: {'Luxury', 'Relaxed'}, interests: {'Beaches', 'Nightlife', 'Wellness', 'Food & Drinks'}, food: {'Fine Dining', 'Healthy', 'Local Cuisine'}, budget: 'Luxury', pace: 'Relaxed', companion: 'Friends', transport: {'Taxi / Ride-hailing', 'Choose best for me'}),
      stay: null, useStayAsAnchor: false, stayStatus: 'Stay not booked yet', stayCost: 0, transportCost: 650,
      featureTags: {'No stay yet', 'Add stay prompt', 'Call fallback', 'ROAMLI+'}, highlight: 'Shows planning before accommodation is booked and later route re-optimization.',
      itinerary: [
        TripDay(dayNumber: 1, date: DateTime(2027, 7, 2), title: 'Mykonos Town', stops: const [
          ItineraryStop(id: 'myk1', place: littleVenice, time: '6:00 PM', note: 'Flexible until a stay is selected.'),
          ItineraryStop(id: 'myk2', place: mykonosDinner, time: '8:30 PM', note: 'No booking URL; call the restaurant instead.', travelMinutesFromPrevious: 8),
        ]),
        TripDay(dayNumber: 2, date: DateTime(2027, 7, 3), title: 'Beach & wellness', stops: const [ItineraryStop(id: 'myk3', place: mykonosBeach, time: '11:00 AM', note: 'Route will improve after adding a stay.')]),
      ],
    ),
  ];

  static List<PlaceRef> get allDemoPlaces => [
    ...explore, dubaiStay, dubaiFrame, dubaiMuseum, dubaiDinner, kiteBeach,
    ibizaStay, calaComte, ibizaOldTown, ibizaClub, romeStay, colosseum, florenceMarket,
    veniceWalk, pragueStay, charlesBridge, pragueCastle, pragueFood,
    littleVenice, mykonosBeach, mykonosDinner,
  ];

  static List<RoamliNotification> notifications() => [
    RoamliNotification(id: 'n1', title: 'Santorini is coming up', body: 'Your trip starts soon. Review your itinerary and saved places.', icon: Icons.luggage_outlined, time: DateTime(2026, 9, 16, 9)),
    RoamliNotification(id: 'n2', title: 'Pelekanos is on today’s itinerary', body: 'Dinner is planned for 7 PM. Reserve externally or call the restaurant.', icon: Icons.restaurant_outlined, time: DateTime(2026, 9, 18, 15)),
    RoamliNotification(id: 'n3', title: 'Possible rain tomorrow', body: 'We found indoor ideas near your stay if you want to adjust the day.', icon: Icons.cloud_outlined, time: DateTime(2026, 9, 18, 18)),
  ];
}
