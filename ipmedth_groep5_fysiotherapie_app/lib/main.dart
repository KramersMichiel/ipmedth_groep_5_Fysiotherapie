import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/modelTestPage.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/tempLandingPage.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'package:provider/provider.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/colorManager.dart';
import 'views/videoImportPage.dart';
import 'widgets/helpDialog.dart';

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
  final page_controller = PageController(
    initialPage: 0,
  );

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
      backgroundColor: const Color(0xFFE3F0F4), // Lichtblauw, nog ENV VAR maken
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                iconSize: 64,
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => HelpDialog(),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset(
                      'assets/images/logo_tekst2x.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 80),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoImportPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 64,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF77BFDC),
                            Color(0xFF76A9BE),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(64),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.5), // Shadow color
                            blurRadius: 4, // Spread of the shadow
                            offset:
                                Offset(0, 4), // Position of the shadow (x, y)
                          ),
                        ],
                      ),
                      child: const Text(
                        'Start analyse',
                        style: TextStyle(
                          fontFamily: 'Lato-regular',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
