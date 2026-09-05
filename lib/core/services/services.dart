import '../models/models.dart';

abstract interface class PlacesService {
  Future<List<PlaceRef>> autocomplete(String query, {GeoPoint? near});
  Future<List<PlaceRef>> searchArea({required GeoPoint center, String? category});
  Future<PlaceRef?> details(String placeId);
}

abstract interface class RoutingService {
  Future<List<GeoPoint>> route({required GeoPoint from, required List<GeoPoint> stops, required GeoPoint to});
  Future<int> travelMinutes(GeoPoint from, GeoPoint to);
}

abstract interface class WeatherService {
  Future<String> tripForecast(GeoPoint point, DateTime date);
}

abstract interface class AuthService {
  Future<void> continueAsGuest();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
}

abstract interface class SubscriptionService {
  Future<bool> get isPlus;
  Future<void> upgrade(String productId);
  Future<void> restore();
}

/// Cost rules for the future production Places implementation:
/// - Autocomplete only during active search and debounce user input.
/// - Request the minimum field mask first; enrich details/photos lazily.
/// - Use explicit "Search this area" rather than search-on-every-map-pan.
/// - Keep ROAMLI-owned metadata keyed by exact provider Place ID.
/// - Apply backend quotas, budget alerts and abuse protection.
/// - Never use a business name alone to identify a branch.
class MockPlacesService implements PlacesService {
  final List<PlaceRef> seed;
  const MockPlacesService(this.seed);

  @override
  Future<PlaceRef?> details(String placeId) async {
    for (final place in seed) {
      if (place.placeId == placeId) return place;
    }
    return null;
  }

  @override
  Future<List<PlaceRef>> autocomplete(String query, {GeoPoint? near}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return seed.take(5).toList();
    return seed.where((e) =>
      e.name.toLowerCase().contains(q) ||
      e.category.toLowerCase().contains(q) ||
      e.subtitle.toLowerCase().contains(q)
    ).toList();
  }

  @override
  Future<List<PlaceRef>> searchArea({required GeoPoint center, String? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (category == null || category == 'All') return seed;
    return seed.where((p) => p.category.toLowerCase().contains(category.toLowerCase())).toList();
  }
}

class MockRoutingService implements RoutingService {
  @override
  Future<List<GeoPoint>> route({required GeoPoint from, required List<GeoPoint> stops, required GeoPoint to}) async => [from, ...stops, to];

  @override
  Future<int> travelMinutes(GeoPoint from, GeoPoint to) async => 15;
}

class MockWeatherService implements WeatherService {
  @override
  Future<String> tripForecast(GeoPoint point, DateTime date) async => '24°C · Mostly sunny';
}
