import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/color_button.dart';
import 'package:provider/provider.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/colorManager.dart';

class tempLandingPage extends StatefulWidget {
  const tempLandingPage({super.key});

  @override
  State<tempLandingPage> createState() => _tempLandingPageState();
}

class _tempLandingPageState extends State<tempLandingPage> {
  int _counter = 0;
  Color _currentColor = Colors.blue;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ColorManager(),
      child: Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Provider.of<ColorManager>(context).getMarkerColor(Markers.markerPoint),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("a"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${_counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Consumer<ColorManager>(
                builder: (context, colorManager, child) {
                  return Column(
                    children: [
                      Color_button(
                        lineColor: colorManager.getMarkerColor(Markers.markerPoint),
                        onPressed: (color) {
                          colorManager.setMarkerColor(Markers.markerPoint, Colors.blue);
                        },
                      ),
                      Color_button(
                        lineColor: colorManager.getMarkerColor(Markers.markerLeft),
                        onPressed: (color) {
                          colorManager.setMarkerColor(Markers.markerLeft, Colors.red);
                        },
                      ),
                      Color_button(
                        lineColor: colorManager.getMarkerColor(Markers.markerRight),
                        onPressed: (color) {
                          colorManager.setMarkerColor(Markers.markerRight, Colors.yellow);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    )
  );}
}