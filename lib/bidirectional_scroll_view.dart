import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class BidirectionalScrollViewPlugin extends StatefulWidget {
  const BidirectionalScrollViewPlugin({@required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return new _BidirectionalScrollViewState(child);
  }
}

class _BidirectionalScrollViewState extends State<BidirectionalScrollViewPlugin>
    with SingleTickerProviderStateMixin {
  static const double _kMinFlingVelocity = 1.0;

  Widget _child;

  _BidirectionalScrollViewState(Widget child) {
    _child = child;
  }

  final GlobalKey _containerKey = new GlobalKey();
  final GlobalKey _positionedKey = new GlobalKey();

  double xPos = 0.0;
  double yPos = 0.0;
  double xViewPos = 0.0;
  double yViewPos = 0.0;

  AnimationController _controller;
  Animation<Offset> _flingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  void _handleFlingAnimation() {
    if (_flingAnimation.value.dx.isNaN || _flingAnimation.value.dy.isNaN) {
      return;
    }

    double newXPosition = xPos + _flingAnimation.value.dx;
    double newYPosition = yPos + _flingAnimation.value.dy;

    RenderBox renderBox = _positionedKey.currentContext.findRenderObject();
    double width = renderBox.size.width;
    double height = renderBox.size.height;

    RenderBox containerBox = _containerKey.currentContext.findRenderObject();
    double containerWidth = containerBox.size.width;
    double containerHeight = containerBox.size.height;

    if (newXPosition > 0.0 || width < containerWidth) {
      newXPosition = 0.0;
    } else if (-newXPosition + containerWidth > width) {
      newXPosition = containerWidth - width;
    }

    if (newYPosition > 0.0 || height < containerHeight) {
      newYPosition = 0.0;
    } else if (-newYPosition + containerHeight > height) {
      newYPosition = containerHeight - height;
    }

    setState(() {
      xViewPos = newXPosition;
      yViewPos = newYPosition;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(details.globalPosition);

    double newXPosition = xViewPos + (position.dx - xPos);
    double newYPosition = yViewPos + (position.dy - yPos);

    RenderBox renderBox = _positionedKey.currentContext.findRenderObject();
    double width = renderBox.size.width;
    double height = renderBox.size.height;

    RenderBox containerBox = _containerKey.currentContext.findRenderObject();
    double containerWidth = containerBox.size.width;
    double containerHeight = containerBox.size.height;


    if (newXPosition > 0.0 || width < containerWidth) {
      newXPosition = 0.0;
    } else if (-newXPosition + containerWidth > width) {
      newXPosition = containerWidth - width;
    }

    if (newYPosition > 0.0 || height < containerHeight) {
      newYPosition = 0.0;
    } else if (-newYPosition + containerHeight > height) {
      newYPosition = containerHeight - height;
    }

    setState(() {
      xViewPos = newXPosition;
      yViewPos = newYPosition;
    });

    xPos = position.dx;
    yPos = position.dy;
  }

  void _handlePanDown(DragDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(details.globalPosition);

    xPos = position.dx;
    yPos = position.dy;
  }

  void _handlePanEnd(DragEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    final double velocity = magnitude / 1000.0;

    if (velocity < _kMinFlingVelocity) {
      return;
    }

    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;

    xPos = xViewPos;
    yPos = yViewPos;

    _flingAnimation = new Tween<Offset>(
        begin: new Offset(0.0, 0.0),
        end: direction * distance
    ).animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: velocity);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanDown: _handlePanDown,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: new Container(
          key: _containerKey,
          child: new Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              new Positioned(
                  key: _positionedKey,
                  top: yViewPos,
                  left: xViewPos,
                  child: _child
              )
            ],
          )
      ),
    );
  }
}