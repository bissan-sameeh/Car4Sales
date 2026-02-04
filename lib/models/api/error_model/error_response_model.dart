class ErrorResponseModel {

  final Map<String, dynamic>? errors;

  ErrorResponseModel({ this.errors});

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(

      errors: json['error'],
    );
  }
}