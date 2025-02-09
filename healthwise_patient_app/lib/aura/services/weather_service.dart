import 'dart:convert';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  
  WeatherService(this.apiKey);
  // Future<Weather> getWeather(String cityName) async{
  //   final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
  //   if(response.statusCode==200){
  //     return Weather.fromJson(jsonDecode(response.body));
  //   } else{
  //     throw Exception('Failed to load weather data');
  //   }
  // }

  Future<Weather> getWeatherByCoordinates(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
      '$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
    ));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  // Future<String> getCurrentCity() async{
  //   LocationPermission permission=await Geolocator.checkPermission();
  //   if (permission==LocationPermission.denied){
  //     permission=await Geolocator.requestPermission();
  //   }

  //   Position position=await Geolocator.getCurrentPosition(
  //     // ignore: deprecated_member_use
  //     desiredAccuracy: LocationAccuracy.high,
  //     // ignore: deprecated_member_use
  //     timeLimit: const Duration(seconds: 10),
  //     );

  //   List<Placemark> placemarks=
  //   await placemarkFromCoordinates(position.latitude,position.longitude);

  //   String? city = placemarks[0].locality;

  //   return city ?? "";
  // }
//   Future<String> getCurrentCity() async {
//   try {
//     // LocationPermission permission = await Geolocator.checkPermission();
//     // if (permission == LocationPermission.denied) {
//     //   permission = await Geolocator.requestPermission();
//     // }

//     // Position position = await Geolocator.getCurrentPosition(
//     //   desiredAccuracy: LocationAccuracy.high,
//     //   timeLimit: const Duration(seconds: 10),
//     // );

//     print("Fetching location permissions...");
//     LocationPermission permission = await Geolocator.checkPermission();
//     print("Permission status: $permission");

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       print("Requested permission: $permission");
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//       timeLimit: const Duration(seconds: 20),
//     );
//     print("Obtained position: ${position.latitude}, ${position.longitude}");


//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       position.latitude,
//       position.longitude,
//     ).timeout(Duration(seconds: 20), onTimeout: () {
//       throw Exception('Reverse geocoding timed out');
//     });

//     try{
//       print(placemarks);
//     }catch(e){
//       print("Locality could not be found. error by me");
//     }

//     String? city = placemarks[0].locality;
//     return city ?? "";
//   } catch (e) {
//     print('Error retrieving city: $e');
//     return "Unknown city";
//   }
// }

}