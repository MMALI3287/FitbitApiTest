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

enum Period { d1, d7, d03, w1, m1, m3, m6, y1 }

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    String accessToken =
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyM1JNNlYiLCJzdWIiOiJCVzJUSEMiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJ3aHIgd3BybyB3bnV0IHdzbGUgd2VjZyB3c29jIHdhY3Qgd294eSB3dGVtIHd3ZWkgd2NmIHdzZXQgd3JlcyB3bG9jIiwiZXhwIjoxNzA1MzM1MDA5LCJpYXQiOjE3MDUzMDYyMDl9.cJ5lEddmvXpAXKFvELffXYTGPu2bfhFAyebPhKhI76w";
    String oldRefreshToken =
        "b3614afa23069891c2ff0418cf6256dcabe4fcdb6c1aa01961b5eb8f91cfa920";
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
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     FitbitCredentials? credentials = await fitbitAPIs.authorize();
          //     printData(credentials.toString());
          //   },
          //   child: const Icon(Icons.lock_open),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     bool isTokenValid = await fitbitAPIs.isTokenValid(accessToken);
          //     printData(isTokenValid.toString());
          //   },
          //   child: const Text("Is Token Valid"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     FitbitCredentials? fitbitCredentials =
          //         await fitbitAPIs.refreshToken(oldRefreshToken, clientId);
          //     printData(fitbitCredentials.toString());
          //   },
          //   child: const Text("Refresh Token"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     double weight = random.nextDouble() * 150 + 30;
          //     printData(weight.toString());
          //     FitbitCredentials? fitbitCredentials = await fitbitAPIs
          //         .createWeightLog(accessToken, clientId, weight, dateTime);
          //     printData(fitbitCredentials.toString());
          //   },
          //   child: const Text("Create Weight Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     FitbitCredentials? fitbitCredentials = await fitbitAPIs
          //         .getWeightLog(accessToken, clientId, dateTime);
          //     printData(fitbitCredentials.toString());
          //   },
          //   child: const Text("Get Weight Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     double bodyFat = random.nextDouble() * 50;
          //     printData(bodyFat.toStringAsFixed(2));
          //     FitbitCredentials? fitbitCredentials = await fitbitAPIs
          //         .createBodyFatLog(accessToken, clientId, bodyFat, dateTime);
          //     printData(fitbitCredentials.toString());
          //   },
          //   child: const Text("Create Body Fat Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();

          //     FitbitCredentials? fitbitCredentials = await fitbitAPIs
          //         .getBodyFatLog(accessToken, clientId, dateTime);
          //     printData(fitbitCredentials.toString());
          //   },
          //   child: const Text("Get Body Fat Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     double startWeight = random.nextDouble() * 50 + 20;
          //     printData(startWeight.toStringAsFixed(2));
          //     double targetWeight = startWeight - 20;
          //     printData(targetWeight.toStringAsFixed(2));
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     fitbitAPIs.createWeightGoal(accessToken, clientId, startDateTime,
          //         startWeight, targetWeight);
          //   },
          //   child: const Text("Create Weight Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     double bodyFatGoal = random.nextDouble() * 50;
          //     printData(bodyFatGoal.toStringAsFixed(2));
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     fitbitAPIs.createBodyFatGoal(accessToken, clientId, bodyFatGoal);
          //   },
          //   child: const Text("Create BodyFat Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     String bodyFatLogId = "1704811643000";
          //     printData(bodyFatLogId);
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     fitbitAPIs.deleteBodyFatLog(accessToken, clientId, bodyFatLogId);
          //   },
          //   child: const Text("Delete Body Fat Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     fitbitAPIs.getFriends(accessToken, clientId);
          //   },
          //   child: const Text("Get Friends"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getFavoriteFoods(accessToken, clientId);
          //   },
          //   child: const Text("Get Favorite Foods"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodId = 123;
          //     await fitbitAPIs.getFood(accessToken, clientId, foodId); //checked
          //   },
          //   child: const Text("Get Food"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getFoodGoals(accessToken, clientId);
          //   },
          //   child: const Text("Get Food Goals"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getFoodLocales(accessToken, clientId); //checked
          //   },
          //   child: const Text("Get Food Locales"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getFoodLog(accessToken, clientId, dateTime);
          //   },
          //   child: const Text("Get Food Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getFoodUnits(accessToken, clientId); //checked
          //   },
          //   child: const Text("Get Food Units"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getFrequentFoods(accessToken, clientId);
          //   },
          //   child: const Text("Get Frequent Foods"),
          // ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              int mealId = 456; // Replace with the actual meal ID
              await fitbitAPIs.getMeal(accessToken, clientId, mealId);
            },
            child: const Text("Get Meal"),
          ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              await fitbitAPIs.getMeals(accessToken, clientId);
            },
            child: const Text("Get Meals"),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getRecentFoods(accessToken, clientId);
          //   },
          //   child: const Text("Get Recent Foods"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getWaterGoal(accessToken, clientId);
          //   },
          //   child: const Text("Get Water Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     await fitbitAPIs.getWaterLog(accessToken, clientId, dateTime);
          //   },
          //   child: const Text("Get Water Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     String foodName = "Banana";
          //     await fitbitAPIs.searchFoods(
          //         accessToken, clientId, foodName); //checked
          //   },
          //   child: const Text("Search Foods"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodLogId = 33111861308;
          //     int mealTypeId = 3;
          //     int amount = 100;
          //     int unitId = 204;
          //     int calories = 200;
          //     await fitbitAPIs.updateFoodLog(accessToken, clientId, foodLogId,
          //         mealTypeId, amount, unitId, calories);
          //   },
          //   child: const Text("Update Food Log"),
          // ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              int mealId = 456; // Replace with the actual meal ID
              await fitbitAPIs.updateMeal(accessToken, clientId, mealId);
            },
            child: const Text("Update Meal"),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int waterLogId = 10058892303;
          //     DateTime dateTime = DateTime.now();
          //     int amount = 700;
          //     String unit = "ml";
          //     await fitbitAPIs.updateWaterLog(
          //         accessToken, clientId, waterLogId, dateTime, amount, unit);
          //   },
          //   child: const Text("Update Water Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodId = 14724757;
          //     await fitbitAPIs.addFavoriteFoods(accessToken, clientId, foodId);
          //   },
          //   child: const Text("Add Favorite Foods"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     String name = "Murgi Khichuri";
          //     int defaultFoodMeasurementUnitId = 17;
          //     int defaultServingSize = 150;
          //     int calories = 80;
          //     String formType = "DRY";
          //     String description = "A Good old khichuri";
          //     await fitbitAPIs.createFood(
          //         accessToken,
          //         clientId,
          //         name,
          //         defaultFoodMeasurementUnitId,
          //         defaultServingSize,
          //         calories,
          //         formType,
          //         description);
          //   },
          //   child: const Text("Create Food"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     String intensity = "Harder";
          //     await fitbitAPIs.createFoodGoal(accessToken, clientId, intensity);
          //   },
          //   child: const Text("Create Food Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodId = 81409;
          //     int mealTypeId = 1;
          //     int unitId = 204;
          //     int amount = 179;
          //     DateTime dateTime = DateTime.now();
          //     bool favorite = true;
          //     String brandName = "Brand";
          //     int calories = 300;
          //     await fitbitAPIs.createFoodLog(
          //         accessToken,
          //         clientId,
          //         foodId,
          //         mealTypeId,
          //         unitId,
          //         amount,
          //         dateTime,
          //         favorite,
          //         brandName,
          //         calories);
          //   },
          //   child: const Text("Create Food Log"),
          // ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              String name = "New Meal";
              String description = "Meal Description";
              List<Map<String, dynamic>> mealFoods = [
                {"foodId": 81409, "amount": 1, "unitId": 204},
                {"foodId": 81000, "amount": 100, "unitId": 147}
              ];
              await fitbitAPIs.createMeal(
                  accessToken, clientId, name, description, mealFoods);
            },
            child: const Text("Create Meal"),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int target = 2000;
          //     await fitbitAPIs.createWaterGoal(accessToken, clientId, target);
          //   },
          //   child: const Text("Create Water Goal"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int amount = 500;
          //     DateTime dateTime = DateTime.now();
          //     String unit = "ml";
          //     await fitbitAPIs.createWaterLog(
          //         accessToken, clientId, amount, dateTime, unit);
          //   },
          //   child: const Text("Create Water Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodId = 813775804;
          //     await fitbitAPIs.deleteCustomFood(accessToken, clientId, foodId);
          //   },
          //   child: const Text("Delete Custom Food"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodId = 81409;
          //     await fitbitAPIs.deleteFavoriteFoods(
          //         accessToken, clientId, foodId);
          //   },
          //   child: const Text("Delete Favorite Foods"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int foodLogId = 33108248006;
          //     await fitbitAPIs.deleteFoodLog(accessToken, clientId, foodLogId);
          //   },
          //   child: const Text("Delete Food Log"),
          // ),
          ElevatedButton(
            onPressed: () async {
              FitbitAPIs fitbitAPIs = FitbitAPIs();
              int mealId = 789; // Replace with the actual meal ID
              await fitbitAPIs.deleteMeal(accessToken, clientId, mealId);
            },
            child: const Text("Delete Meal"),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     int waterLogId = 10058892303;
          //     await fitbitAPIs.deleteWaterLog(
          //         accessToken, clientId, waterLogId);
          //   },
          //   child: const Text("Delete Water Log"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     String resource = "water";
          //     DateTime dateTime = DateTime.now();
          //     Period period = Period.d03;
          //     await fitbitAPIs.getNutritionTimeSeriesByDate(
          //         accessToken, clientId, resource, dateTime, period);
          //   },
          //   child: const Text("Get Nutrition Time Series By Date"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     FitbitAPIs fitbitAPIs = FitbitAPIs();
          //     String resource = "water";
          //     DateTime startDateTime = DateTime.now();
          //     DateTime endDateTime = DateTime.now().add(Duration(days: 7));
          //     await fitbitAPIs.getNutritionTimeSeriesByDateRange(
          //         accessToken, clientId, resource, startDateTime, endDateTime);
          //   },
          //   child: const Text("Get Nutrition Time Series By Date Range"),
          // ),
        ],
      ),
    );
  }
}
