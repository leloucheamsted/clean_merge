import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tello_social_app/modules/core/presentation/action_state.dart';

import '../error/failure.dart';

class EitherStreamBinder<T> {
  late final _ctrl = BehaviorSubject<ActionState<T>>.seeded(ActionState.initial());
  Stream<ActionState<T>> get outStream => _ctrl.stream;

  late final _ctrlData = BehaviorSubject<T>();
  Stream<T> get outDataStream => _ctrlData.stream;

  T? _loadedValue;
  T? get loadedValue => _loadedValue;

  Future callUseCase(
    Future<Either<IFailure, T>> Function() useCaseCall, {
    Function(T data)? onSuccess,
    Function(String error)? onFailure,
    Function(bool isSuccess)? onCompleted,
    bool forceLoading = false,
  }) async {
    // if (flagLoading) _add(ActionState.loading());
    if (forceLoading || _loadedValue == null) _add(ActionState.loading());
    final response = await useCaseCall();
    response.fold((l) {
      _add(ActionState.error(l));
      onFailure?.call(l.toString());
      onCompleted?.call(false);
    }, (r) {
      addLoadedValue(r);
      /*_loadedValue = r;
      if (!_ctrlData.isClosed) {
        _ctrlData.add(r);
      }
      _add(ActionState.completed(r));
      */
      onSuccess?.call(r);
      onCompleted?.call(true);
    });
  }

  void addLoadedValue(T r) {
    _loadedValue = r;
    if (!_ctrlData.isClosed) {
      _ctrlData.add(r);
    }
    _add(ActionState.completed(r));
  }

  void addLoading() {
    _add(ActionState.loading());
  }

  void addResponse() {
    _add(ActionState.completed(null));
  }

  void addException(Exception exception) {
    _add(ActionState.error(exception.toString(), exception: exception));
  }

  void _add(ActionState<T> response) {
    if (!_ctrl.isClosed) {
      _ctrl.sink.add(response);
    }
  }

  void dispose() {
    if (!_ctrlData.isClosed) {
      _ctrlData.close();
    }
    if (!_ctrl.isClosed) {
      _ctrl.close();
    }
  }
}
