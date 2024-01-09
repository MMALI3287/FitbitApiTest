class FitbitCredentials {
  late String userId;
  late String accessToken;
  late String refreshToken;
  late String tokenType;
  late int expiresInSeconds;
  late List<String> scope;
  late String error;
  late String errorDescription;

  FitbitCredentials(
      {required this.userId,
      required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresInSeconds,
      required this.scope,
      required this.error,
      required this.errorDescription});

  FitbitCredentials.fromJson(Map params) {
    userId = params["user_id"] != null ? params["user_id"].toString() : "";
    accessToken =
        params["access_token"] != null ? params["access_token"].toString() : "";
    refreshToken = params["refresh_token"] != null
        ? params["refresh_token"].toString()
        : "";
    tokenType =
        params["token_type"] != null ? params["token_type"].toString() : "";
    expiresInSeconds = params["expires_in"] != null
        ? int.parse(params["expires_in"].toString())
        : 0;
    scope = params["scope"] != null
        ? params["scope"].toString().trim().split(" ")
        : [];
    error = params["error"] != null ? params["error"].toString() : "";
    errorDescription = params["error_description"] != null
        ? params["error_description"].toString()
        : "";
  }

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = <String, dynamic>{};
    params["user_id"] = userId;
    params["access_token"] = accessToken;
    params["refresh_token"] = refreshToken;
    params["token_type"] = tokenType;
    params["expires_in"] = expiresInSeconds.toString();
    String scopeString = "";
    for (int i = 0; i < scope.length; i++) {
      if (i == 0) {
        scopeString = scope[i].toString();
      } else {
        scopeString = "$scopeString ${scope[i].toString()}";
      }
    }
    params["scope"] = scopeString;
    params["error"] = error;
    params["error_description"] = errorDescription;
    return params;
  }

  @override
  String toString() {
    return "FitbitCredentials{user_id: $userId, access_token: $accessToken, refresh_token: $refreshToken, token_type: $tokenType, expires_in: $expiresInSeconds, scope: $scope, error: $error, errorDescription: $errorDescription}";
  }
}
