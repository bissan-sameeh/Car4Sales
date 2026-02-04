class ApiResponse<T> {
  ApiStatus status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = ApiStatus.LOADING;
  ApiResponse.initial(this.message) : status = ApiStatus.INITIAL;
  ApiResponse.completed(this.data) : status = ApiStatus.COMPLETED;
  ApiResponse.error(this.message) : status = ApiStatus.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum ApiStatus { INITIAL, LOADING, COMPLETED, ERROR }
