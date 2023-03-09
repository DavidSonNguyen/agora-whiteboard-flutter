package com.example.whiteboard

import com.example.whiteboard.view.WhiteBoardEventHandler
import com.example.whiteboard.view.WhiteBoardViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val eventHandler = WhiteBoardEventHandler()
        val message = flutterEngine.dartExecutor.binaryMessenger
        eventHandler.startListening(message);
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("whiteboard", WhiteBoardViewFactory(message, eventHandler))
    }
}

