import 'dart:developer';

class ActionState<T> {
  ActionStateStatus status;
  String? code;
  Exception? exception;
  StackTrace? stackTrace;
  Object? error;
  T? data;
  // dynamic data;
  String? get message {
    if (error != null) {
      return error.toString();
    }
    return data.toString();
  }

  // dynamic error;

  ActionState.initial() : status = ActionStateStatus.INITIAL;
  ActionState.loading() : status = ActionStateStatus.LOADING;
  ActionState.completed(this.data) : status = ActionStateStatus.COMPLETED;
  ActionState.error(this.error, {this.exception, this.code, this.stackTrace}) : status = ActionStateStatus.ERROR {
    log(error.toString(), stackTrace: stackTrace, error: error);
  }

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum ActionStateStatus { INITIAL, LOADING, COMPLETED, ERROR }
