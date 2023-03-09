import 'package:flutter/material.dart';
import 'package:whiteboard/widgets/whiteboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            // Get uuid, token and AK with document https://docs.agora.io/en/interactive-whiteboard/reference/whiteboard-api/overview?platform=web
            child: Whiteboard(
              roomUuid: '<uuid>',
              roomToken: '<token>',
              appIdentifier: '<AK>',
              userId: 'userId',
            ),
          ),
        ],
      ),
    );
  }
}
