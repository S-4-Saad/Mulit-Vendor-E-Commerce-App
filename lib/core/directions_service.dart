import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  
  // Using the same API key from Android manifest
  static const String _apiKey = 'AIzaSyA6aHpBlVh7cuv3nXYEOfV8ikzTr8H-8FA';
  
  final Dio _dio = Dio();

  Future<DirectionsResult?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': _apiKey,
          'mode': 'driving',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          return DirectionsResult.fromJson(data);
        } else {
          print('Directions API error: ${data['status']}');
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching directions: $e');
      return null;
    }
  }
}

class DirectionsResult {
  final List<Route> routes;
  final String status;

  DirectionsResult({
    required this.routes,
    required this.status,
  });

  factory DirectionsResult.fromJson(Map<String, dynamic> json) {
    return DirectionsResult(
      routes: (json['routes'] as List)
          .map((route) => Route.fromJson(route))
          .toList(),
      status: json['status'],
    );
  }
}

class Route {
  final List<LatLng> points;
  final String summary;
  final int distance; // in meters
  final int duration; // in seconds

  Route({
    required this.points,
    required this.summary,
    required this.distance,
    required this.duration,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    final legs = json['legs'] as List;
    final leg = legs.first;
    
    // Decode polyline points
    final overviewPolyline = json['overview_polyline'];
    final encodedPoints = overviewPolyline['points'] as String;
    final points = _decodePolyline(encodedPoints);

    return Route(
      points: points,
      summary: json['summary'] ?? '',
      distance: leg['distance']['value'] ?? 0,
      duration: leg['duration']['value'] ?? 0,
    );
  }

  static List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
