import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollTopWidget extends StatefulWidget {
  final ScrollController? scrollController;
  ScrollTopWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  _ScrollTopWidgetState createState() => _ScrollTopWidgetState();
}

class _ScrollTopWidgetState extends State<ScrollTopWidget> {
  bool _flagShow = false;
  void _onScroll() {
    final double offset = widget.scrollController!.offset;
    //TODO: reduce or extract variable sliverlistde appbar oldugu zaman azaltmak lazım _ALL
    if (offset < 50) {
      if (_flagShow) {
        setFlagShow(false);
      }
      return;
    }
    // print("offset $offset");
    final double velocity = widget.scrollController!.position.activity!.velocity;
    if (velocity.abs() > 10) {
      _flagShow = widget.scrollController!.position.userScrollDirection == ScrollDirection.forward;
      setFlagShow(_flagShow);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController!.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(_onScroll);
    super.dispose();
  }

  void _actionScrollTop() {
    widget.scrollController!.jumpTo(0);
    setFlagShow(false);
  }

  void setFlagShow(bool flag) {
    setState(() {
      _flagShow = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_flagShow
        ? SizedBox()
        : Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _actionScrollTop,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade500.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(
                  right: 8,
                  bottom: MediaQuery.of(context).padding.bottom + 8,
                ),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.grey.shade300,
                  size: 38,
                ),
              ),
            ),
          );
  }
}
