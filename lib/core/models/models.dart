import 'package:flutter/material.dart';

class GeoPoint {
  final double lat;
  final double lng;
  const GeoPoint(this.lat, this.lng);
}

class PlaceRef {
  final String placeId;
  final String name;
  final String category;
  final String subtitle;
  final GeoPoint location;
  final double rating;
  final String priceLevel;
  final String? bookingUrl;
  final String? phone;
  final String? website;
  final bool openNow;
  final String? imageAsset;
  final String description;
  final int estimatedCost;

  const PlaceRef({
    required this.placeId,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.location,
    this.rating = 0,
    this.priceLevel = '',
    this.bookingUrl,
    this.phone,
    this.website,
    this.openNow = false,
    this.imageAsset,
    this.description = '',
    this.estimatedCost = 0,
  });
}

class TravelPreferences {
  final Set<String> styles;
  final Set<String> interests;
  final Set<String> food;
  final String budget;
  final String pace;
  final String companion;
  final Set<String> transport;

  const TravelPreferences({
    required this.styles,
    required this.interests,
    required this.food,
    required this.budget,
    required this.pace,
    required this.companion,
    required this.transport,
  });

  TravelPreferences copyWith({
    Set<String>? styles,
    Set<String>? interests,
    Set<String>? food,
    String? budget,
    String? pace,
    String? companion,
    Set<String>? transport,
  }) => TravelPreferences(
    styles: styles ?? this.styles,
    interests: interests ?? this.interests,
    food: food ?? this.food,
    budget: budget ?? this.budget,
    pace: pace ?? this.pace,
    companion: companion ?? this.companion,
    transport: transport ?? this.transport,
  );
}

class TripDraft {
  String destination;
  DateTime? start;
  DateTime? end;
  PlaceRef? stay;
  bool useStayAsAnchor;
  int adults;
  int children;
  TravelPreferences? overrides;
  String budget;
  int? dailyBudget;

  TripDraft({
    this.destination = '',
    this.start,
    this.end,
    this.stay,
    this.useStayAsAnchor = true,
    this.adults = 2,
    this.children = 0,
    this.overrides,
    this.budget = 'Moderate',
    this.dailyBudget,
  });

  void reset() {
    destination = '';
    start = null;
    end = null;
    stay = null;
    useStayAsAnchor = true;
    adults = 2;
    children = 0;
    overrides = null;
    budget = 'Moderate';
    dailyBudget = null;
  }
}

class ItineraryStop {
  final String id;
  final PlaceRef place;
  final String time;
  final String note;
  final int travelMinutesFromPrevious;

  const ItineraryStop({
    required this.id,
    required this.place,
    required this.time,
    this.note = '',
    this.travelMinutesFromPrevious = 0,
  });
}

class TripDay {
  final int dayNumber;
  final DateTime date;
  final String title;
  final List<ItineraryStop> stops;

  const TripDay({
    required this.dayNumber,
    required this.date,
    required this.title,
    required this.stops,
  });

  TripDay copyWith({List<ItineraryStop>? stops}) => TripDay(
    dayNumber: dayNumber,
    date: date,
    title: title,
    stops: stops ?? this.stops,
  );
}


class DemoTrip {
  final String id;
  final String title;
  final String destination;
  final String country;
  final DateTime start;
  final DateTime end;
  final String status;
  final int adults;
  final int children;
  final TravelPreferences preferences;
  final PlaceRef? stay;
  final bool useStayAsAnchor;
  final String stayStatus;
  final String currency;
  final int stayCost;
  final int transportCost;
  final List<TripDay> itinerary;
  final Set<String> featureTags;
  final String highlight;

  const DemoTrip({
    required this.id,
    required this.title,
    required this.destination,
    required this.country,
    required this.start,
    required this.end,
    required this.status,
    required this.adults,
    this.children = 0,
    required this.preferences,
    this.stay,
    this.useStayAsAnchor = true,
    required this.stayStatus,
    this.currency = 'AED',
    this.stayCost = 0,
    this.transportCost = 0,
    required this.itinerary,
    this.featureTags = const {},
    this.highlight = '',
  });

  int get days => end.difference(start).inDays + 1;
  int get stops => itinerary.fold<int>(0, (sum, day) => sum + day.stops.length);
  int get activityCost => itinerary.expand((d) => d.stops).fold<int>(0, (sum, stop) => sum + stop.place.estimatedCost);
  int get estimatedTotal => stayCost + transportCost + activityCost;
}

class SavedCollection {
  final String id;
  final String name;
  final Set<String> placeIds;
  final String note;

  const SavedCollection({
    required this.id,
    required this.name,
    required this.placeIds,
    this.note = '',
  });
}

class RoamliNotification {
  final String id;
  final String title;
  final String body;
  final IconData icon;
  final DateTime time;
  final bool unread;

  const RoamliNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.icon,
    required this.time,
    this.unread = true,
  });
}
