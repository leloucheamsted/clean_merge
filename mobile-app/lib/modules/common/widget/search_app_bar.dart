import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:tello_social_app/modules/core/presentation/action_state.dart';

class SearchAppBarBloc<T> {
  // final Future<T> Function(String) onChanged;
  // SearchAppBarBloc({required this.onChanged})
  void doSearch(String key) {
    onTextChanged.add(key);
  }

  final Sink<String> onTextChanged;
  final Stream<ActionState<T>> state;

  factory SearchAppBarBloc(Future<T> Function(String) onChanged) {
    final onTextChanged = PublishSubject<String>();

    final Stream<ActionState<T>> state = onTextChanged
        // If the text has not changed, do not perform a new search
        .distinct()
        // Wait for the user to stop typing for 250ms before running a search
        .debounceTime(const Duration(milliseconds: 250))
        // Call the Github api with the given search term and convert it to a
        // State. If another search term is entered, switchMap will ensure
        // the previous search is discarded so we don't deliver stale results
        // to the View.
        .switchMap<ActionState<T>>((String term) => _search(term, onChanged))
        // The initial state to deliver to the screen.
        .startWith(ActionState.initial());

    return SearchAppBarBloc._(onTextChanged, state);
  }

  SearchAppBarBloc._(this.onTextChanged, this.state);

  void dispose() {
    onTextChanged.close();
  }

  static Stream<ActionState<T>> _search<T>(String term, onChanged) {
    return Rx.fromCallable<T>(() => onChanged(term))
        .map((result) => ActionState.completed(result))
        .startWith(ActionState.loading())
        .onErrorReturnWith((err, stackTrace) => ActionState.error(err, stackTrace: stackTrace));
  }
  // static Stream<ActionState> _search<T>(String term, onChanged) => Rx.fromCallable(() => onChanged(term))
  //     .map((result) => ActionState.completed(result))
  //     .startWith(ActionState.loading())
  //     .onErrorReturn((ActionState.error("error")));
}
/*
class SearchAppBarBloc<T> {
  final Future<T> Function(String) onChanged;
  SearchAppBarBloc({required this.onChanged}) {
    // Implementation based on: https://youtu.be/7O1UO5rEpRc
    // ReactiveConf 2018 - Brian Egan & Filip Hracek: Practical Rx with Flutter
    _results =
        _searchTerms.debounce((_) => TimerStream(true, const Duration(milliseconds: 200))).switchMap((query) async* {
      yield await onChanged(query);
    }); // discard previous events
  }

  // Input stream (search terms)
  final _searchTerms = BehaviorSubject<String>();
  void doSearch(String key) => _searchTerms.add(key);

  // Output stream (search results)
  late Stream<T> _results;
  Stream<T> get results => _results;

  void dispose() {
    _searchTerms.close();
  }
}*/

class SearchAppBar extends StatefulWidget {
  // final ValueChanged<String> onChanged;
  // final Future Function(String) onChanged;
  final SearchAppBarBloc bloc;
  final String? search_hint;
  final List<TextInputFormatter>? inputFormatters;
  // final Duration? searchDelay;
  final List<Widget>? actions;
  // final bool restrictEmoji;
  final bool showBackButton;
  SearchAppBar({
    Key? key,
    required this.bloc,
    this.search_hint,
    this.inputFormatters,
    this.showBackButton = true,
    // this.searchDelay = const Duration(seconds: 1),
    this.actions,
  }) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final StreamController<String> _textChangeStreamController = StreamController();
  late StreamSubscription _textChangesSubscription;

  final TextEditingController _textEditingController = TextEditingController();

  String query = "";

  late Stream _results;
  Stream get results => _results;
  @override
  void initState() {
    /*_textChangesSubscription =
        _textChangeStreamController.stream.listen((text) {
      widget.onChanged(text);
    });*/

    _textChangesSubscription = _textChangeStreamController.stream.listen((event) {
      widget.bloc.doSearch(event);
    });
    /*_results = _textChangeStreamController.stream
        .distinct()
        // .debounceTime(const Duration(seconds: 1))
        .debounceTime(widget.searchDelay ?? const Duration(seconds: 1))
        .switchMap((query) async* {
      yield await widget.onChanged(query);
      // yield await searchRepository.searchUser(query);
    }); //
    // .flatMap((_) => _resetSearch())
    // .listen(_onNewListingStateController.add)
    // .asyncMap((event) => widget.onChanged);
    // .listen(widget.onChanged);
  */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // floating: true,
      // pinned: true,
      // snap: true,
      // forceElevated: true,
      automaticallyImplyLeading: widget.showBackButton,
      title: _buidlSearchField(),
      // title: Text("PagingTestWidget"),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 1,
      actions: _buildActions(context),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    return query == ""
        ? widget.actions
        : [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: actionClear,
            ),
            if (widget.actions != null) ...widget.actions!
          ];
  }

  void actionClear() {
    // _textChangeStreamController.
    _textEditingController.clear();
    widget.bloc.doSearch("");

    // widget.onChanged("");
    onChanged("");
    // onChanged1("");
  }

  Widget _buidlSearchField() {
    return Container(
      // margin: EdgeInsets.all(0),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        /*color: CommonHelper.isDarkMode(context)
            ? Colors.grey.shade800
            : Colors.white70,*/
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: _textEditingController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          hintText: widget.search_hint,
          // hintText: k,
          // labelText: query,
        ),
        // onChanged: _textChangeStreamController.add,
        onChanged: onChanged1,
        // onSubmitted: widget.onChanged,
        inputFormatters: widget.inputFormatters,
      ),
    );
  }

  void onChanged1(String str) {
    onChanged(str);
    _textChangeStreamController.add(str);
  }

  void onChanged(String str) {
    setState(() {
      query = str;
    });
    // widget.onChanged(str);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }

  /*
  Widget _buildTitleTextF(ThemeData theme, String searchFieldLabel) {
    return TextField(
      maxLength: 15,
      controller: widget.delegate!._queryTextController,
      focusNode: focusNode,
      style: theme.textTheme.headline6!.copyWith(color: Colors.grey.shade600),
      textInputAction: widget.delegate!.textInputAction,
      keyboardType: widget.delegate!.keyboardType,
      onSubmitted: (String _) {
        widget.delegate!.showResults(context);
      },
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.only(left: 10),
        counterText: "",
        border: InputBorder.none,
        hintText: searchFieldLabel,
        hintStyle: theme.inputDecorationTheme.hintStyle!
            .copyWith(color: Colors.grey.shade600),
      ),
    );
  }*/

}
