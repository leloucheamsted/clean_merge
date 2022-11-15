import 'package:flutter/material.dart';

import 'action_state.dart';
export 'action_state.dart';

typedef SuccessCallback<T> = Widget Function(BuildContext context, ActionState<T> data);

Widget buildDefaultLoading() {
  return const Center(
      child: Padding(
    padding: EdgeInsets.all(8.0),
    child: CircularProgressIndicator(),
  ));
}

Widget buildDefaultError(Object? error, Function? doRetryFunction, {Widget? erorWidget}) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: erorWidget ?? Text(error == null ? "null err" : error as String, textAlign: TextAlign.center)),
        const SizedBox(height: 25),
        doRetryFunction != null
            ? ClipOval(
                child: Container(
                  // color: Theme.of(context).colorTheme.primaryColor,
                  child: IconButton(
                      icon: const Icon(Icons.refresh, size: 32),
                      color: Colors.white,
                      onPressed: () => doRetryFunction()),
                ),
              )
            : SizedBox()
      ],
    ),
  );
}

class StreamBuilder_all<T> extends StatelessWidget {
  final bool isSliver;
  final String? debugTag;
  final bool showLoadingForNull;
  StreamBuilder_all({
    Key? key,
    required this.stream,
    required this.onSuccess,
    this.debugTag,
    this.onInitial,
    this.onError,
    this.onLoading,
    this.doRetryFunction,
    this.isSliver = false,
    this.initialData,
    this.showLoadingForNull = false,
  }) : super(key: key);

  final T? initialData;
  final Stream<T>? stream;

  final Function(BuildContext context, T? data) onSuccess;
  // final SuccessCallback onSuccess;

  final Function(BuildContext context, Object? error, {Exception? exception})? onError;
  final Function(BuildContext context)? onLoading;
  final Function(BuildContext context)? onInitial;
  final Function? doRetryFunction;
  // final Function(BuildContext context) onNoData;

  Function get _defaultOnInitial => (context) => const Center(child: Text("initial state"));

  Function get _defaultOnWaiting => (context) => buildDefaultLoading();

  Function get _defaulOnError => (context, error) => buildDefaultError(error, doRetryFunction);

  T? _lastData;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return _buildError(context, snapshot.error.toString());
        }
        if ((snapshot.connectionState == ConnectionState.waiting) || (showLoadingForNull && snapshot.data == null)) {
          return _buildLoading(context);
        } else {
          return _buildActionState(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildActionState(BuildContext context, T? response) {
    if (response is ActionState) {
      final ActionState apiResponse = response;
      switch (apiResponse.status) {
        case ActionStateStatus.INITIAL:
          return _buildInitial(context);
        case ActionStateStatus.LOADING:
          return _buildLoading(context);
        case ActionStateStatus.ERROR:
          return _buildError(context, apiResponse.message, exception: apiResponse.exception);
        case ActionStateStatus.COMPLETED:
          return _buildSuccess(context, response);
      }
    }
    return onSuccess(context, response);
  }

  Widget _buildSuccess(BuildContext context, T? data) {
    _lastData = data;
    return onSuccess(context, data);
  }

  Widget _buildInitial(BuildContext context) {
    if (onInitial != null) return onInitial!(context);

    Widget w = _defaultOnInitial(context);
    return isSliver ? SliverToBoxAdapter(child: w) : w;
  }

  Widget _buildLoading(BuildContext context) {
    if (onLoading != null) return onLoading!(context);

    Widget loadingWidget = _defaultOnWaiting(context);
    return isSliver ? SliverToBoxAdapter(child: loadingWidget) : loadingWidget;
  }

  Widget _buildError(BuildContext context, String? errorMsg, {Exception? exception}) {
    if (onError != null) return onError!(context, errorMsg, exception: exception);

    Widget errorWidget = _defaulOnError(context, errorMsg);
    return isSliver ? SliverToBoxAdapter(child: errorWidget) : errorWidget;
  }
}
