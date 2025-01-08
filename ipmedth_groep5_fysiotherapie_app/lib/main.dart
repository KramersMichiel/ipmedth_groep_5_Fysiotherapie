import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/modelTestPage.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/tempLandingPage.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'package:provider/provider.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/colorManager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ColorManager(),
      child: ChangeNotifierProvider(create: (context) => bodyTrackingManager(),child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final page_controller = PageController(initialPage: 0,);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    page_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: modelTestPage()
    );
  }
}