import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/landingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gait Analysis Demo',
      theme: ThemeData(
        colorScheme: const GaitAnalysisColorScheme(),
        useMaterial3: true,
      ),
      home: Landingpage(),
      debugShowCheckedModeBanner: false,
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
  final page_controller = PageController(
    initialPage: 0,
  );

  Widget tempLandingPage() {
    return Center(
      child: Text('Temporary Landing Page'),
    );
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
      body: PageView(
        controller: page_controller,
        children: [
          tempLandingPage(),
        ],
      ),
    );
  }
}

class GaitAnalysisColorScheme extends ColorScheme {
  static const Color primaryColor = Color(0xff2C8C39);
  static const Color onPrimaryColor = Color(0xffFFFFFF);

  static const Color secondaryColor = Color(0xffEFF5E0);
  static const Color onSecondaryColor = Color(0xff161412);

  static const Color surfaceColor = Color(0xffEFF5E0);
  static const Color onSurfaceColor = Color(0xff161412);

  static const Color backgroundColor = Color(0xffF7FAF0);
  static const Color onBackgroundColor = Color(0xff161412);

  static const Color errorColor = Color(0xffBA1200);
  static const Color onErrorColor = Color(0xffFFFFFF);

  // Override the constructor
  const GaitAnalysisColorScheme({
    // Set your custom colors as primary and secondary
    Color primary = primaryColor,
    Color onPrimary = onPrimaryColor,
    Color secondary = secondaryColor,
    Color onSecondary = onSecondaryColor,
    Color surface = surfaceColor,
    Color onSurface = onSurfaceColor,
    Color background = backgroundColor,
    Color onBackground = onBackgroundColor,
    Color error = errorColor,
    Color onError = onErrorColor,

    // Include other color properties from the super class
    // such as background, surface, onBackground, etc.
  }) : super(
            brightness: Brightness.light,
            primary: primary,
            secondary: secondary,
            background: background,
            onPrimary: onPrimary,
            onSecondary: onSecondary,
            onBackground: onBackground,
            surface: surface,
            onSurface: onSurface,
            error: error,
            onError: onError);
}
