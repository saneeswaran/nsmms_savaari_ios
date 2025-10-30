class ApiResponse {
  final ErrorInfo error;
  final ResultData result;

  ApiResponse({required this.error, required this.result});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: ErrorInfo.fromJson(json['Error']),
      result: ResultData.fromJson(json['Result']),
    );
  }
}

class ErrorInfo {
  final int errorCode;
  final String? errorMessage;

  ErrorInfo({required this.errorCode, this.errorMessage});

  factory ErrorInfo.fromJson(Map<String, dynamic> json) {
    return ErrorInfo(
      errorCode: json['ErrorCode'],
      errorMessage: json['ErrorMessage'],
    );
  }
}

class ResultData {
  final List<City> cityList;

  ResultData({required this.cityList});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    var list = json['CityList'] as List;
    List<City> cities = list.map((city) => City.fromJson(city)).toList();
    return ResultData(cityList: cities);
  }
}

class City {
  final int cityId;
  final String cityName;

  City({required this.cityId, required this.cityName});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['CityId'],
      cityName: json['CityName'].trim(),
    );
  }
}
