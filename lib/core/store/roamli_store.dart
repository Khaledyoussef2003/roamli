import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

class RoamliStore extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _onboardingKey = 'onboarding_complete';
  static const _preferencesKey = 'preferences_complete';
  static const _guestKey = 'guest_mode';
  static const _savedKey = 'saved_place_ids';

  ThemeMode themeMode = ThemeMode.system;
  bool onboardingComplete = false;
  bool preferencesComplete = false;
  bool guestMode = false;
  bool signedIn = false;
  bool plusMember = false;
  bool notificationsEnabled = true;
  bool quietHours = false;
  String language = 'English';
  String currency = 'AED';

  TravelPreferences preferences = MockData.preferences;
  final TripDraft tripDraft = TripDraft();
  final Set<String> savedPlaceIds = {'mock_oia', 'mock_pelekanos', 'mock_finikia', 'mock_dubai_dinner', 'mock_cala_comte', 'mock_florence_market', 'mock_charles_bridge', 'mock_mykonos_dinner'};
  final List<SavedCollection> collections = [
    const SavedCollection(id: 'c1', name: 'Greece Ideas', placeIds: {'mock_oia', 'mock_pelekanos', 'mock_mykonos_dinner'}),
    const SavedCollection(id: 'c2', name: 'Dubai Food', placeIds: {'mock_dubai_dinner'}),
    const SavedCollection(id: 'c3', name: 'Ibiza Summer', placeIds: {'mock_cala_comte'}),
    const SavedCollection(id: 'c4', name: 'Italy Local', placeIds: {'mock_florence_market'}),
    const SavedCollection(id: 'c5', name: 'Hidden Gems', placeIds: {'mock_finikia', 'mock_charles_bridge'}),
  ];
  final List<DemoTrip> demoTrips = MockData.demoTrips();
  late DemoTrip activeTrip;
  late List<TripDay> itinerary;
  List<RoamliNotification> notifications = MockData.notifications();

  RoamliStore() {
    activeTrip = demoTrips.first;
    itinerary = activeTrip.itinerary.map((d) => d.copyWith(stops: List<ItineraryStop>.of(d.stops))).toList();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = switch (prefs.getString(_themeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    onboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    preferencesComplete = prefs.getBool(_preferencesKey) ?? false;
    guestMode = prefs.getBool(_guestKey) ?? false;
    final saved = prefs.getStringList(_savedKey);
    if (saved != null) {
      savedPlaceIds
        ..clear()
        ..addAll(saved);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<void> completeOnboarding() async {
    onboardingComplete = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<void> continueAsGuest() async {
    guestMode = true;
    signedIn = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
  }

  void mockSignIn() {
    signedIn = true;
    guestMode = false;
    notifyListeners();
  }

  Future<void> savePreferences(TravelPreferences next) async {
    preferences = next;
    preferencesComplete = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_preferencesKey, true);
  }

  Future<void> toggleSaved(String placeId) async {
    if (!savedPlaceIds.add(placeId)) savedPlaceIds.remove(placeId);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedKey, savedPlaceIds.toList());
  }

  bool isSaved(String placeId) => savedPlaceIds.contains(placeId);


  void openDemoTrip(DemoTrip trip) {
    activeTrip = trip;
    itinerary = trip.itinerary.map((d) => d.copyWith(stops: List<ItineraryStop>.of(d.stops))).toList();
    notifyListeners();
  }

  void updateItineraryDay(int dayIndex, List<ItineraryStop> stops) {
    itinerary = List.of(itinerary)..[dayIndex] = itinerary[dayIndex].copyWith(stops: stops);
    notifyListeners();
  }

  void removeStop(int dayIndex, String stopId) {
    final next = itinerary[dayIndex].stops.where((s) => s.id != stopId).toList();
    updateItineraryDay(dayIndex, next);
  }

  void addStop(int dayIndex, PlaceRef place) {
    final day = itinerary[dayIndex];
    final next = List<ItineraryStop>.of(day.stops)
      ..add(ItineraryStop(
        id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
        place: place,
        time: 'Flexible',
        note: 'Added to your trip.',
        travelMinutesFromPrevious: 15,
      ));
    updateItineraryDay(dayIndex, next);
  }

  void setPlus(bool value) {
    plusMember = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void setQuietHours(bool value) {
    quietHours = value;
    notifyListeners();
  }

  void resetTripDraft() {
    tripDraft.reset();
    notifyListeners();
  }
}

class RoamliScope extends InheritedNotifier<RoamliStore> {
  const RoamliScope({super.key, required RoamliStore store, required super.child}) : super(notifier: store);

  static RoamliStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RoamliScope>();
    assert(scope != null, 'RoamliScope not found');
    return scope!.notifier!;
  }
}
