import 'package:flutter/material.dart';

import 'next_page.dart';
import 'package:screen_ratio_adapter/screen_ratio_adapter.dart';

//Size uiSize = Size(300, 510);
Size uiSize = Size(414, 896);

//void main() => runApp(MyApp());
void main() => runFxApp(MyApp(), uiSize: uiSize);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '设计尺寸${uiSize.toString()}'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NextPage();
              }));
            },
            child: Center(child: Text("NextPage")),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              '设计尺寸 414x896',
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(
                    color: Colors.orange,
                    child: Text("w= 100,    h=100"),
                  ),
                ),

                SizedBox(
                  width: 314,
                  height: 100,
                  child: Container(
                    color: Colors.green,
                    child: Text("w=314"),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text("W= 414"),
                  width: 414,
                  height: 80,
                  color: Colors.greenAccent,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text("W= 415"),
                  width: 500,
                  height: 80,
                  color: Colors.lightBlue,
                ),
              ],
            ),
            Text(
              '设计尺寸 300x510',
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text("W= 100"),
                  width: 100,
                  height: 30,
                  color: Colors.lightBlue,
                ),
                Container(
                  child: Text("W= 200"),
                  width: 200,
                  height: 30,
                  color: Colors.red,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text("W= 100"),
                  width: 100,
                  height: 30,
                  color: Colors.yellow,
                ),
                Container(
                  child: Text("W= 100"),
                  width: 100,
                  height: 30,
                  color: Colors.lightBlue,
                ),
                Container(
                  child: Text("W= 100"),
                  width: 100,
                  height: 30,
                  color: Colors.yellow,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text("W= 301"),
                  width: 300,
                  height: 30,
                  color: Colors.cyanAccent,
                ),
                Container(
                  child: Text(""),
                  width: 1,
                  height: 30,
                  color: Colors.red,
                ),
              ],
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
