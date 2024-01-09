import 'package:flutter/material.dart';
import 'package:fb_api_test/fitbit_apis.dart';
import 'package:fb_api_test/fitbit_strings.dart';
import 'package:fb_api_test/fitbit_credententials.dart';

class TestScreens extends StatelessWidget {
  const TestScreens({super.key});

  printData(String data) {
    print("Fitbit-Test # $data");
  }

  @override
  Widget build(BuildContext context) {
    String accessToken =
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyM1JIQkYiLCJzdWIiOiI5V0s2S1EiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJ3aHIgd3BybyB3bnV0IHdzbGUgd2VjZyB3c29jIHdhY3Qgd294eSB3dGVtIHd3ZWkgd2NmIHdzZXQgd3JlcyB3bG9jIiwiZXhwIjoxNzAxODcwMTY0LCJpYXQiOjE3MDE4NDEzNjR9.dOvauV7ETOvPqLbx55YwlizCOFEYpzrZZJADHQzl4VY";
    String oldRefreshToken =
        "2f6cd25145464f299f6016d7e5b5c94bb36143b746cd2ff4f1c38a555fde8550";
    String userId = "9WK6KQ";

    //Temperature
    DateTime dateTime = DateTime.now();
    DateTime startDateTime = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDateTime = DateTime.now();

    // //Body
    // DateTime startDateTime = DateTime.now();
    // double startWeight = 75.0;
    // double targetWeight = 80.0;

    // double bodyFatGoal = 20.0;

    // double weightLog = 60.0;
    // double bodyFatLog = 35.0;

    // DateTime dateTime = DateTime.now();

    // String weightLogId = "1701873858000";
    // String bodyFatLogId = "1701873906000";
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          ElevatedButton(
            onPressed: () async {
              // IsarLocalDB isarLocalDB = IsarLocalDB();
              // isarLocalDB.copyToFile();
            },
            child: const Text("Isar"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              FitbitCredentials? credentials = await fitbitAPIs.authorize();
              printData(credentials.toString());
            },
            child: const Text("Authorize"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              bool isTokenValid = await fitbitAPIs.isTokenValid(accessToken);
              printData(isTokenValid.toString());
            },
            child: const Text("Is Token Valid"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              String clientId = FitbitStrings.oauth2ClientID;
              FitbitCredentials? fitbitCredentials =
                  await fitbitAPIs.refreshToken(oldRefreshToken, clientId);
              printData(fitbitCredentials.toString());
            },
            child: const Text("Refresh Token"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();

              await fitbitAPIs.revokeToken(accessToken);
            },
            child: const Text("Revoke Token"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              print("Date => $dateTime");

              // List<FitbitCoreTemperature> fitbitCoreTemperatureList =
              //     await fitbitAPIs.getCoreTemperatureByDate(
              //         accessToken, userId, dateTime);
              // print(fitbitCoreTemperatureList);
            },
            child: const Text("Get Core Temp By Date"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              print(
                  "Date => Start date : $startDateTime, End date : $endDateTime");

              // List<FitbitCoreTemperature> fitbitCoreTemperatureList =
              //     await fitbitAPIs.getCoreTemperatureByInterval(
              //         accessToken, userId, startDateTime, endDateTime);
              // print(fitbitCoreTemperatureList);
            },
            child: const Text("Get Core Temp By Interval"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              print("Date => $dateTime");

              // List<FitbitSkinTemperature> fitbitSkinTemperatureList =
              //     await fitbitAPIs.getSkinTemperatureByDate(
              //         accessToken, userId, dateTime);
              // print(fitbitSkinTemperatureList);
            },
            child: const Text("Get Skin Temp By Date"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              print(
                  "Date => Start date : $startDateTime, End date : $endDateTime");

              // List<FitbitSkinTemperature> fitbitSkinTemperatureList =
              //     await fitbitAPIs.getSkinTemperatureByInterval(
              //         accessToken, userId, startDateTime, endDateTime);
              // print(fitbitSkinTemperatureList);
            },
            child: const Text("Get Skin Temp By Interval"),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     FitbitWeightGoal? fitbitBodyWeightGoal =
          //         await fitbitAPIs.getBodyWeightGoal(accessToken, userId);
          //     printData(fitbitBodyWeightGoal.toString());
          //   },
          //   child: const Text("Get Body Weight Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     await fitbitAPIs.createWeightGoal(accessToken, userId,
          //         startDateTime, startWeight, targetWeight);
          //   },
          //   child: const Text("Create Body Weight Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     FitbitFatGoal? fitbitBodyFatGoal =
          //         await fitbitAPIs.getBodyFatGoal(accessToken, userId);
          //     printData(fitbitBodyFatGoal.toString());
          //   },
          //   child: const Text("Get Body Fat Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     await fitbitAPIs.createBodyFatGoal(
          //         accessToken, userId, bodyFatGoal);
          //   },
          //   child: const Text("Create Body Fat Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     List<FitbitBodyWeightLog> fitbitBodyWeightLogs = await fitbitAPIs
          //         .getBodyWeightLogs(accessToken, userId, dateTime);
          //     printData(fitbitBodyWeightLogs.toString());
          //   },
          //   child: const Text("Get Body Weight Logs"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     await fitbitAPIs.createWeightLog(
          //         accessToken, userId, weightLog, dateTime);
          //   },
          //   child: const Text("Create Body Weight Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.deleteWeightLog(
          //         accessToken, userId, weightLogId);
          //   },
          //   child: const Text("Delete Body Weight Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     List<FitbitBodyFatLog> fitbitBodyfatLogs = await fitbitAPIs
          //         .getBodyFatLogs(accessToken, userId, dateTime);
          //     printData(fitbitBodyfatLogs.toString());
          //   },
          //   child: const Text("Get Body Fat Logs"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.createBodyFatLog(
          //         accessToken, userId, bodyFatLog, dateTime);
          //   },
          //   child: const Text("Create Body Fat Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.deleteBodyFatLog(
          //         accessToken, userId, bodyFatLogId);
          //   },
          //   child: const Text("Delete Body Fat Log"),
          // ),
        ],
      ),
    );
  }
}
