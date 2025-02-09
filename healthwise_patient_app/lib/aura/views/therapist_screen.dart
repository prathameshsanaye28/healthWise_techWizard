// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PetBabySitting extends StatefulWidget {
//   final String userUid;

//   PetBabySitting({super.key, required this.userUid});

//   @override
//   _PetBabySittingState createState() => _PetBabySittingState();
// }

// class _PetBabySittingState extends State<PetBabySitting> {
//   LatLng? _currentLocation;
//   List<User> _nearbyUsers = [];
//   late String currentUserId; // Replace with actual user ID

//   @override
//   void initState() {
//     super.initState();
//     currentUserId = widget.userUid;
//     _getCurrentLocationAndUpdateUsers();
//   }

//   // Function to get current location and update in Firestore
//   Future<void> _getCurrentLocationAndUpdateUsers() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return Future.error('Location services are disabled.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return Future.error('Location permissions are denied.');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         return Future.error('Location permissions are permanently denied.');
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // Update current user's location in Firestore
//       await FirebaseFirestore.instance
//           .collection('patients')
//           .doc(currentUserId)
//           .update({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//       });

//       // Get nearby users
//       await _getNearbyUsers(position.latitude, position.longitude);

//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }

//   // Function to get nearby users
//   Future<void> _getNearbyUsers(double lat, double lng) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('patients')
//           .where('latitude', isGreaterThan: lat - 1)
//           .where('latitude', isLessThan: lat + 1)
//           .get();

//       List<User> nearbyUsers = [];
//       for (var doc in querySnapshot.docs) {
//         User user = User.fromSnap(doc);
//         if (user.uid != currentUserId &&
//             user.longitude != null &&
//             user.longitude! >= lng - 1 &&
//             user.longitude! <= lng + 1) {
//           nearbyUsers.add(user);
//         }
//       }

//       setState(() {
//         _nearbyUsers = nearbyUsers;
//       });
//     } catch (e) {
//       print('Error getting nearby users: $e');
//     }
//   }

//   // Function to show user details
//   void _showUserDetails(User user) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'User Details',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text('Name: ${user.fullname}'),
//               Text('Contact No: ${user.contactnumber}'),
//               Text('Email: ${user.email}'),
//               Text('Location: (${user.latitude}, ${user.longitude})'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Nearby Users Map'),
//         ),
//         body: _currentLocation == null
//             ? Center(child: CircularProgressIndicator())
//             : FlutterMap(
//                 options: MapOptions(
//                   initialCenter: _currentLocation!,
//                   initialZoom: 13.0,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     subdomains: ['a', 'b', 'c'],
//                   ),
//                   MarkerLayer(
//                     markers: [
//                       // Current user marker (blue)
//                       Marker(
//                         width: 80.0,
//                         height: 80.0,
//                         point: _currentLocation!,
//                         child: Icon(
//                           Icons.location_pin,
//                           color: Colors.blue,
//                           size: 40,
//                         ),
//                       ),

//                       // Nearby users markers (red with onTap to show details)
//                       ..._nearbyUsers.map((user) => Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: LatLng(user.latitude!, user.longitude!),
//                             child: GestureDetector(
//                               onTap: () => _showUserDetails(user),
//                               child: Icon(
//                                 Icons.location_pin,
//                                 color: Colors.red,
//                                 size: 40,
//                               ),
//                             ),
//                           )),
//                     ],
//                   ),
//                 ],
//               ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _getCurrentLocationAndUpdateUsers,
//           child: Icon(Icons.refresh),
//           tooltip: 'Refresh Location',
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/therapist.dart';

class TherapistScreen extends StatefulWidget {
  final String userUid;

  const TherapistScreen({super.key, required this.userUid});

  @override
  _TherapistScreenState createState() => _TherapistScreenState();
}

class _TherapistScreenState extends State<TherapistScreen> {
  LatLng? _currentLocation;
  List<Therapist> _nearbyTherapists = [];
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = widget.userUid;
    _getCurrentLocationAndFetchTherapists();
  }

  Future<void> _getCurrentLocationAndFetchTherapists() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update current user's location in Firestore
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUserId)
          .update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      // Get nearby therapists
      await _fetchNearbyTherapists(position.latitude, position.longitude);

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchNearbyTherapists(double lat, double lng) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('therapists')
          .where('latitude', isGreaterThan: lat - 0.5)
          .where('latitude', isLessThan: lat + 0.5)
          .get();

      List<Therapist> nearbyTherapists = [];
      for (var doc in querySnapshot.docs) {
        Therapist therapist = Therapist.fromSnap(doc);
        if (therapist.longitude != null &&
            therapist.longitude! >= lng - 0.5 &&
            therapist.longitude! <= lng + 0.5) {
          nearbyTherapists.add(therapist);
        }
      }

      setState(() {
        _nearbyTherapists = nearbyTherapists;
      });
    } catch (e) {
      print('Error fetching therapists: $e');
    }
  }

  void _showTherapistDetails(Therapist therapist) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Therapist Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Name: ${therapist.fullname}'),
              Text('Age: ${therapist.age}'),
              Text('Contact: ${therapist.contactnumber}'),
              Text('Email: ${therapist.email}'),
              Text('Location: (${therapist.latitude}, ${therapist.longitude})'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Nearby Therapists Map'),
        ),
        body: _currentLocation == null
            ? const Center(child: CircularProgressIndicator())
            : FlutterMap(
                options: MapOptions(
                  initialCenter: _currentLocation!,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentLocation!,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      ..._nearbyTherapists.map((therapist) => Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(
                                therapist.latitude!, therapist.longitude!),
                            child: GestureDetector(
                              onTap: () => _showTherapistDetails(therapist),
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getCurrentLocationAndFetchTherapists,
          tooltip: 'Refresh Location',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
