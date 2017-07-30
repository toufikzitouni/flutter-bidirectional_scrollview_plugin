import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BidirectionalScrollViewPlugin _plugin;


  @override
  void initState() {
    super.initState();
    _plugin = new BidirectionalScrollViewPlugin(
      child: _buildWidgets(),
      velocityFactor: 2.0,
      scrollListener: (offset) {
        print("----------");
        print("new x and y scroll offset: " + offset.dx.toString() + " " + offset.dy.toString());
        print("x and y scroll offset getters: " + _plugin.x.toString() + " " + _plugin.y.toString());
        print("height and width of overscrolled widget: " + _plugin.height.toString() + " " + _plugin.width.toString());
        print("height and width of the container: " + _plugin.containerHeight.toString() + " " + _plugin.containerWidth.toString());
        print("----------");
      },
    );

    //_plugin.offset = new Offset(10.0, 10.0); // use this method to set a new offset where appropriate
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Bidirectional ScrollView Plugin'),
        ),
        body: new Center(
          child: _plugin
        ),
      ),
    );
  }

  Widget _buildWidgets() {
    List<Widget> list = new List();

    for (int i = 0; i < 10; i++) {
      list.add(new Container(
        padding: new EdgeInsets.all(5.0),
        color: Colors.white,
        height: 80.0,
        width: 120.0,
        child: new Container(
          color: Colors.grey,
        ),
      ));
    }

    return new Row(
      children: [
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
        new Column(
          children: list.map((widget) {
            return widget;
          }).toList(),
        ),
      ],
    );
  }
}
