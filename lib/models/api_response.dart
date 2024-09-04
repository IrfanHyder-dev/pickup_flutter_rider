import 'error_model.dart';

class ApiResponseModel {
  bool success;
  int statusCode;
  dynamic? data;
  String? authToken;
  ErrorModel? errorModel;

  ApiResponseModel(
      {this.success = false,
      required this.statusCode,
      this.authToken,
      this.data,
      this.errorModel});
}
