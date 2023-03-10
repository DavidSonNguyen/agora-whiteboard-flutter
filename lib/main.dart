import 'package:flutter/material.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/widgets/whiteboard.dart';
import 'package:whiteboard/widgets/whiteboard_controller.dart';

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
  final controller = WhiteboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              // Get uuid, token and AppIdentifier with document https://docs.agora.io/en/interactive-whiteboard/reference/whiteboard-api/overview?platform=web
              child:
              Whiteboard(
              roomUuid: '<uuid>',
              roomToken: '<token>',
              appIdentifier: '<AppIdentifier>',
              userId: 'userId',
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    controller.switchToolTeaching(ToolTeaching.pencil);
                  },
                  child: const Text('Pen'),
                ),
                const SizedBox(width: 10.0),
                TextButton(
                  onPressed: () {
                    controller.switchToolTeaching(ToolTeaching.eraser);
                  },
                  child: const Text('Eraser'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
