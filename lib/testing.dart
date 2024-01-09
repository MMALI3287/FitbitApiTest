import 'dart:math';

import 'package:fb_api_test/fitbit_apis.dart';
import 'package:fb_api_test/fitbit_credententials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    String accessToken =
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyM1JNNlYiLCJzdWIiOiJCVzJUSEMiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJ3aHIgd3BybyB3bnV0IHdzbGUgd2VjZyB3c29jIHdhY3Qgd294eSB3dGVtIHd3ZWkgd2NmIHdzZXQgd3JlcyB3bG9jIiwiZXhwIjoxNzA0ODE4MDQwLCJpYXQiOjE3MDQ3ODkyNDB9.VdY85V5ScDoAqmtBZTpm6P5OG2AFl9qPjg15ax4WiZU";
    String oldRefreshToken =
        "8e8e766eae2b121e9f867042351b6b2ec17f5da9ab070afa1978fa0cc04e8269";
    String clientId = "BW2THC";

    DateTime dateTime = DateTime.now();
    DateTime startDateTime = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDateTime = DateTime.now();

    Random random = Random();

    printData(String data) {
      if (kDebugMode) {
        print("Fitbit-Test # $data");
      }
    }

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              FitbitCredentials? credentials = await fitbitAPIs.authorize();
              printData(credentials.toString());
            },
            child: const Icon(Icons.lock_open),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              bool isTokenValid = await fitbitAPIs.isTokenValid(accessToken);
              printData(isTokenValid.toString());
            },
            child: const Text("Is Token Valid"),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     String clientId = userId;
          //     FitbitCredentials? fitbitCredentials =
          //         await fitbitAPIs.refreshToken(oldRefreshToken, clientId);
          //     printData(fitbitCredentials.toString());
          //   },
          //   child: const Text("Refresh Token"),
          // ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              double weight = random.nextDouble() * 150 + 30;
              printData(weight.toString());
              FitbitCredentials? fitbitCredentials = await fitbitAPIs
                  .createWeightLog(accessToken, clientId, weight, dateTime);
              printData(fitbitCredentials.toString());
            },
            child: const Text("Create Weight Log"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              FitbitCredentials? fitbitCredentials = await fitbitAPIs
                  .getWeightLog(accessToken, clientId, dateTime);
              printData(fitbitCredentials.toString());
            },
            child: const Text("Get Weight Log"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              double bodyFat = random.nextDouble() * 50;
              printData(bodyFat.toStringAsFixed(2));
              FitbitCredentials? fitbitCredentials = await fitbitAPIs
                  .createBodyFatLog(accessToken, clientId, bodyFat, dateTime);
              printData(fitbitCredentials.toString());
            },
            child: const Text("Create Body Fat Log"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              FitbitCredentials? fitbitCredentials = await fitbitAPIs
                  .getBodyFatLog(accessToken, clientId, dateTime);
              printData(fitbitCredentials.toString());
            },
            child: const Text("Get Body Fat Log"),
          ),
          ElevatedButton(
            onPressed: () async {
              double startWeight = random.nextDouble() * 50 + 20;
              printData(startWeight.toStringAsFixed(2));
              double targetWeight = startWeight - 20;
              printData(targetWeight.toStringAsFixed(2));
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              fitbitAPIs.createWeightGoal(accessToken, clientId, startDateTime,
                  startWeight, targetWeight);
            },
            child: const Text("Create Weight Goal"),
          ),
          ElevatedButton(
            onPressed: () async {
              double bodyFatGoal = random.nextDouble() * 50;
              printData(bodyFatGoal.toStringAsFixed(2));
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              fitbitAPIs.createBodyFatGoal(accessToken, clientId, bodyFatGoal);
            },
            child: const Text("Create BodyFat Goal"),
          ),
          ElevatedButton(
            onPressed: () async {
              String bodyFatLogId = "1704811643000";
              printData(bodyFatLogId);
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              fitbitAPIs.deleteBodyFatLog(accessToken, clientId, bodyFatLogId);
            },
            child: const Text("Delete Body Fat Log"),
          ),
        ],
      ),
    );
  }
}
