import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fb_api_test/fitbit_credententials.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:intl/intl.dart';
import 'package:fb_api_test/fitbit_strings.dart';

class FitbitAPIs {
  static FitbitAPIs? instance;
  late Dio _dio;
  late Codec<String, String> _stringToBase64;

  factory FitbitAPIs() => instance ?? FitbitAPIs._internal();
  FitbitAPIs._internal() {
    _dio = Dio();
    _stringToBase64 = utf8.fuse(base64);
    instance = this;
  }

  printData(String data) {
    print("Fitbit-Test # $data");
  }

  //////////////////////////////////////// Authorization //////////////////////////////////////

  Future<FitbitCredentials?> authorize() async {
    FitbitCredentials? fitbitCredentials;

    String authUrl =
        "${FitbitStrings.authBaseUrl}/authorize?response_type=code&client_id=${FitbitStrings.oauth2ClientID}&scope=activity+cardio_fitness+electrocardiogram+heartrate+location+nutrition+oxygen_saturation+profile+respiratory_rate+settings+sleep+social+temperature+weight";

    try {
      String result = await FlutterWebAuth2.authenticate(
          url: authUrl, callbackUrlScheme: FitbitStrings.callbackUrlScheme);
      if (!result.contains("error")) {
        String code = Uri.parse(result).queryParameters['code'] ?? "";
        if (code != "") {
          String path = "${FitbitStrings.apiBaseUrl}/oauth2/token";
          String data =
              "client_id=${FitbitStrings.oauth2ClientID}&code=$code&grant_type=authorization_code";
          Map<String, dynamic> authorizationHeader = {
            "Authorization":
                "Basic ${_stringToBase64.encode("${FitbitStrings.oauth2ClientID}:${FitbitStrings.clientSecret}")}"
          };
          Response response = await _dio.post(
            path,
            data: data,
            options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: authorizationHeader,
            ),
          );
          fitbitCredentials = FitbitCredentials.fromJson(response.data);
        }
      } else {
        String error = Uri.parse(result).queryParameters['error'] ?? "";
        String errorDescription =
            Uri.parse(result).queryParameters['error_description'] ?? "";
        fitbitCredentials = FitbitCredentials(
            userId: "",
            accessToken: "",
            refreshToken: "",
            tokenType: "",
            expiresInSeconds: 0,
            scope: [],
            error: error,
            errorDescription: errorDescription);
      }
    } catch (e) {}
    return fitbitCredentials;
  }

  Future<bool> isTokenValid(String accessToken) async {
    bool isTokenValid = false;
    String path = "${FitbitStrings.apiBaseUrl}/1.1/oauth2/introspect";
    String data = "token=$accessToken";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: bearerHeader,
        ),
      );
      if (response.data != null) {
        printData("response => ${response.data}");
        isTokenValid = response.data["active"];
      }
    } catch (e) {}
    return isTokenValid;
  }

  Future<FitbitCredentials?> refreshToken(
      String oldRefreshToken, String clientId) async {
    FitbitCredentials? fitbitCredentials;
    String path = "${FitbitStrings.apiBaseUrl}/oauth2/token";
    String data =
        "client_id=$clientId&grant_type=refresh_token&refresh_token=$oldRefreshToken";
    Map<String, dynamic> authorizationHeader = {
      "Authorization":
          "Basic ${_stringToBase64.encode("${FitbitStrings.oauth2ClientID}:${FitbitStrings.clientSecret}")}"
    };
    try {
      Response response = await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: authorizationHeader,
        ),
      );
      fitbitCredentials = FitbitCredentials.fromJson(response.data);
    } catch (e) {}

    return fitbitCredentials;
  }

  Future revokeToken(String accessToken) async {
    String path = "${FitbitStrings.apiBaseUrl}/oauth2/revoke";
    String data = "token=$accessToken";
    Map<String, dynamic> authorizationHeader = {
      "Authorization":
          "Basic ${_stringToBase64.encode("${FitbitStrings.oauth2ClientID}:${FitbitStrings.clientSecret}")}"
    };
    try {
      await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: authorizationHeader,
        ),
      );
    } catch (e) {}
  }

  //////////////////////////////////////////// Body APIs //////////////////////////////////////////////

  Future createWeightLog(String accessToken, String userId, double weight,
      DateTime dateTime) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/body/log/weight.json";
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String time = DateFormat('HH:mm:ss').format(dateTime);
    String data = "weight=${weight.toStringAsFixed(2)}&date=$date&time=$time";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken",
      "Content-Length": data.length
    };
    try {
      await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: bearerHeader,
        ),
      );
    } catch (e) {}
  }

  Future createBodyFatLog(String accessToken, String userId, double bodyFatLog,
      DateTime dateTime) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/$userId/body/log/fat.json";
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String time = DateFormat('HH:mm:ss').format(dateTime);

    String data = "fat=${bodyFatLog.toStringAsFixed(2)}&date=$date&time=$time";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken",
      "Content-Length": data.length
    };

    try {
      Response response = await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: bearerHeader,
        ),
      );

      if (response.statusCode == 201) {
        print(response.data.toString());
      }
    } catch (e) {
      print("Error while getting body fat log: $e");
      return null;
    }
  }

  Future getBodyFatLog(
      String accessToken, String userId, DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/$userId/body/log/fat/date/$date.json";

    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          headers: bearerHeader,
        ),
      );

      if (response.statusCode == 200) {
        print(response.data.toString());
      }
    } catch (e) {
      print("Error while getting body fat log: $e");
      return null;
    }
  }

  Future getWeightLog(
      String accessToken, String userId, DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/$userId/body/log/weight/date/$date.json";

    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          headers: bearerHeader,
        ),
      );
      print(response.data.toString());
    } catch (e) {
      print("Error while getting body fat log: $e");
      return null;
    }
  }

  Future createWeightGoal(String accessToken, String userId,
      DateTime startDateTime, double startWeight, double targetWeight) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/body/log/weight/goal.json";
    String startDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    String data =
        "startDate=$startDate&startWeight=${startWeight.toStringAsFixed(2)}&weight=${targetWeight.toStringAsFixed(2)}";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken",
      "Content-Length": data.length,
    };
    try {
      await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: bearerHeader,
        ),
      );
    } catch (e) {}
  }

  Future createBodyFatGoal(
      String accessToken, String userId, double bodyFatGoal) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/body/log/fat/goal.json";
    String data = "fat=${bodyFatGoal.toStringAsFixed(2)}";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken",
      "Content-Length": data.length,
    };
    try {
      await _dio.post(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: bearerHeader,
        ),
      );
    } catch (e) {}
  }

  Future deleteWeightLog(
      String accessToken, String userId, String weightLogId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/body/log/weight/$weightLogId.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };
    try {
      await _dio.delete(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );
    } catch (e) {}
  }

  Future deleteBodyFatLog(
      String accessToken, String userId, String bodyFatLogId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/body/log/fat/$bodyFatLogId.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };
    try {
      await _dio.delete(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );
    } catch (e) {}
  }

  /////////////////////////////////// Breathing Rate APIs //////////////////////////////////////

  Future getBreathingRateSummaryByDate(
      String accessToken, String userId, DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/br/date/$date.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getBreathingRateByInterval(String accessToken, String userId,
      DateTime startDateTime, DateTime endDateTime) async {
    //Maximum end date range is 30 days
    String startDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    String endDate = DateFormat('yyyy-MM-dd').format(endDateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/br/date/$startDate/$endDate.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  /////////////////////////////////// Cardio Fitness Score (VO2 Max) APIs //////////////////////////////////////

  Future getCardioFitnessScoreSummaryByDate(
      String accessToken, String userId, DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/cardioscore/date/$date.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getCardioFitnessScoreByInterval(String accessToken, String userId,
      DateTime startDateTime, DateTime endDateTime) async {
    //Maximum end date range is 30 days
    String startDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    String endDate = DateFormat('yyyy-MM-dd').format(endDateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/cardioscore/date/$startDate/$endDate.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  /////////////////////////////////// Blood Oxygen Saturation (SPO2) APIs //////////////////////////////////////

  Future getBloodOxygenSaturationSummaryByDate(
      String accessToken, String userId, DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/cardioscore/date/$date.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getBloodOxygenSaturationByInterval(String accessToken, String userId,
      DateTime startDateTime, DateTime endDateTime) async {
    //Maximum end date range is 30 days
    String startDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    String endDate = DateFormat('yyyy-MM-dd').format(endDateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/cardioscore/date/$startDate/$endDate.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  /////////////////////////////////// Heart Rate Variability (HRV) APIs //////////////////////////////////////

  Future getHeartRateVariabilitySummaryByDate(
      String accessToken, String userId, DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/hrv/date/$date.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getHeartRateVariabilityByInterval(String accessToken, String userId,
      DateTime startDateTime, DateTime endDateTime) async {
    //Maximum end date range is 30 days
    String startDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    String endDate = DateFormat('yyyy-MM-dd').format(endDateTime);
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/hrv/date/$startDate/$endDate.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  /////////////////////////////////// Friends API  //////////////////////////////////////

  Future getFriends(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFriendsLeaderboard(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  ///-------------------------- Activity API ----------------------///
  Future addFavoriteFoods(
      String accessToken, String userId, String foodId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/foods/log/favorite/$foodId.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future createFood(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future createFoodGoal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future CreateFoodLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future createMeal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future createWaterGoal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future createWaterLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future deleteCustomFood(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future deleteFavoriteFoods(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future deleteFoodLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future deleteMeal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future deleteWaterLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFavoriteFoods(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFood(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFoodGoals(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFoodLocales(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFoodLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFoodUnits(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getFrequentFoods(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getmeal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getmeals(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getRecentFoods(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getWaterGoal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future getWaterLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future searchFoods(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future updateFoodLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future updateMeal(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }

  Future updateWaterLog(String accessToken, String userId) async {
    String path =
        "${FitbitStrings.apiBaseUrl}/1.1/user/${userId != "" ? userId : "-"}/leaderboard/friends.json";
    Map<String, dynamic> bearerHeader = {
      "Authorization": "Bearer $accessToken"
    };

    try {
      Response response = await _dio.get(
        path,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: bearerHeader,
        ),
      );

      if (response.data != null) {
        print(response.data.toString());
      }
    } catch (e) {}
  }
}
