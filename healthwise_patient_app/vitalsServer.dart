import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Map<String, dynamic> generateVitalSigns() {
  final random = Random();
  int heartRate = random.nextInt(20) + 60;
  int bloodPressureSystolic = random.nextInt(50) + 90;
  int bloodPressureDiastolic = random.nextInt(30) + 60;
  int spo2 = random.nextInt(5) + 94;
  int temperature = random.nextInt(5) + 97;

  // Introduce occasional spikes for chronic conditions
  if (random.nextDouble() < 0.1) {
    // 10% chance of a spike
    heartRate = random.nextInt(100) + 20;
    bloodPressureSystolic = random.nextInt(30) + 15;
    bloodPressureDiastolic = random.nextInt(20) + 10;
    spo2 = random.nextInt(3) + 90;
    temperature = random.nextInt(3) + 100;
  }

  return {
    "heart_rate": heartRate,
    "blood_pressure_systolic": bloodPressureSystolic,
    "blood_pressure_diastolic": bloodPressureDiastolic,
    "spo2": spo2,
    "temperature": temperature,
  };
}

Response handleRequest(Request request) {
  final vitals = generateVitalSigns();
  return Response.ok(jsonEncode(vitals),
      headers: {'Content-Type': 'application/json'});
}

void main() async {
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(handleRequest);
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
