import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_image_list/error.dart';

GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main()
{
  runZonedGuarded(() async
  {
    // lancement :
    WidgetsFlutterBinding.ensureInitialized();

    // debug et tests :
    debugPrintMarkNeedsPaintStacks = false;
    debugProfilePaintsEnabled = false;
    debugProfileBuildsEnabled = false;
    debugRepaintRainbowEnabled = false;
    debugRepaintTextRainbowEnabled = false;
    debugPaintLayerBordersEnabled = false;

    // meilleur rendu des dégradés :
    Paint.enableDithering = true;

    // gestion erreurs :
    PlatformDispatcher.instance.onError = (error, stack) {
      log("$error\n\n$stack");
      return true;
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      log(details.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          _navigatorKey.currentState!.context,
          MaterialPageRoute(builder: (context) => ErrorPage(error: details.toString())),
        );
      });
    };
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    log("$error\n\n$stack");
    Navigator.push(
      _navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) => ErrorPage(error: "$error\n\n$stack")),
    );
  });
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{

  final _scrollController = ScrollController();
  
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("List demo"),
      ),
      body: SafeArea(
        child: AnimatedList(
          controller: _scrollController,
          initialItemCount: 100,
          itemBuilder: (context, index, animation)
          {
            return Container(
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    "http://s519716619.onlinehome.fr/test/image.jpg?id=$index",
                    width: 80,
                    height: 60,
                    cacheWidth: (MediaQuery.of(context).devicePixelRatio * 80).round(),
                    cacheHeight: (MediaQuery.of(context).devicePixelRatio * 60).round(),
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 60,
                        color: Colors.red,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Item $index",
                    ),
                  ),
                ]
              ),
            );
          },
        ),
      ),
    );
  }
  
}
