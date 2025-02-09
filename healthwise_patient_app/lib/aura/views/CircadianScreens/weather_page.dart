
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

import '../../models/weather_model.dart';
import '../../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('dfc584c45e51420a85f80827ce24d9fd');
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  // _fetchWeather() async{
  //   String cityName= await _weatherService.getCurrentCity();

  //   try{
  //     final weather=await _weatherService.getWeather(cityName);
  //     setState((){
  //       _weather=weather;
  //     });
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }

//   _fetchWeather() async {
//   setState(() {
//     _isLoading = true;
//     _errorMessage = null;
//   });

//   try {
//     String cityName = await _weatherService.getCurrentCity();
//     final weather = await _weatherService.getWeather(cityName);
//     setState(() {
//       _weather = weather;
//       _isLoading = false;
//     });
//   } catch (e) {
//     setState(() {
//       _isLoading = false;
//       _errorMessage = 'Failed to fetch weather data. Please try again.';
//     });
//     print(e);
//   }
// }
  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Retrieve the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );

      // Use latitude and longitude to get weather
      final weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch weather data: $e';
      });
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'asests/weather_animation/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/weather_animation/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/weather_animation/rain.json';
      case 'thunderstorm':
        return 'assets/weather_animation/thunder.json';
      case 'clear':
        return 'assets/weather_animation/sunny.json';
      default:
        return 'assets/weather_animation/sunny.json';
    }
  }

  String getText(String? mainCondition) {
    if (mainCondition == null) return 'It is sunny today!';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'It is cloudy outside!';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'It is rainy outside!';
      case 'thunderstorm':
        return 'It is thundering outside!';
      case 'clear':
        return 'It is sunny today!';
      default:
        return 'It is sunny today!';
    }
  }

  String getActivity(String? mainCondition) {
    if (mainCondition == null) {
      return 'On a sunny day, let the warm rays of sunlight lift your spirits. Step outside, maybe to your garden or a nearby park, and feel the gentle warmth on your skin. Bring a journal and write down the things you’re grateful for; let nature inspire you. If you’re up for a bit of creativity, take some photos of the small beauties around you—the way the light dances through the trees or the colors of blooming flowers. Or bring a good book and a cool drink, settling in for a relaxing outdoor reading session. These simple moments can ground you, bringing a renewed sense of joy and calm.';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'Cloudy days bring a soft, gentle light that invites reflection and relaxation. Why not set up a cozy space by a window with a warm cup of tea? The subtle light is perfect for working on a small art project or simply journaling your thoughts. You could even take a virtual tour of a museum, letting yourself be transported to a world of art and culture without leaving home. With the calm and quiet of a cloudy day, you might also enjoy a few minutes of meditation, letting go of any stress. This peaceful time indoors can be truly nourishing for your mind and heart.';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'When the rain is falling, it creates the perfect backdrop for rest and introspection. Put on some soft music or rain sounds, letting them create a cozy, soothing atmosphere. Try reading or writing some poetry, inspired by the rhythm of the raindrops. If you’re in the mood for self-care, indulge in an at-home spa session—maybe a facial mask or a warm bath to relax. Cooking a comforting meal or treat can also bring you joy and warmth as you listen to the rain outside. These gentle, nurturing activities can be a balm for the soul on a rainy day.';
      case 'thunderstorm':
        return 'Thunderstorms can be dramatic and energizing, making them a wonderful time to connect with yourself. Curl up with a favorite movie or nature documentary, letting the stormy ambiance add to the cozy atmosphere. If you’re feeling reflective, write a letter to your future self, capturing hopes, dreams, and maybe even a little excitement stirred by the storm. You might also enjoy creating a vision board—cutting out images and words that represent your dreams and aspirations. The storm outside can serve as a reminder of your inner strength, inspiring you to focus on what truly brings you happiness and purpose.';
      case 'clear':
        return 'On a sunny day, let the warm rays of sunlight lift your spirits. Step outside, maybe to your garden or a nearby park, and feel the gentle warmth on your skin. Bring a journal and write down the things you’re grateful for; let nature inspire you. If you’re up for a bit of creativity, take some photos of the small beauties around you—the way the light dances through the trees or the colors of blooming flowers. Or bring a good book and a cool drink, settling in for a relaxing outdoor reading session. These simple moments can ground you, bringing a renewed sense of joy and calm.';
      default:
        return 'On a sunny day, let the warm rays of sunlight lift your spirits. Step outside, maybe to your garden or a nearby park, and feel the gentle warmth on your skin. Bring a journal and write down the things you’re grateful for; let nature inspire you. If you’re up for a bit of creativity, take some photos of the small beauties around you—the way the light dances through the trees or the colors of blooming flowers. Or bring a good book and a cool drink, settling in for a relaxing outdoor reading session. These simple moments can ground you, bringing a renewed sense of joy and calm.';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading spinner
            : _errorMessage != null
                ? Text(_errorMessage!) // Show error message
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_weather?.cityName ?? "Unknown city"),
                      const SizedBox(height: 16),
                      // Text(_weather?.mainCondition ?? "Unknown uncondition"),

                      Text(
                        getText(_weather?.mainCondition),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Make text bold
                          fontSize: 20,
                        ),
                      ),
                      Lottie.asset(
                          getWeatherAnimation(_weather?.mainCondition)),

                      // Text('${_weather?.temperature.round()}°C'),
                      // const SizedBox(height: 16),
                      // const Text(
                      //   'Fun activities for you to try!',
                      //   style: TextStyle(fontSize: 16),
                      //   ),

                      // Text(getActivity(_weather?.mainCondition)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          getActivity(_weather?.mainCondition),
                          textAlign: TextAlign.center, // Center-align text
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
