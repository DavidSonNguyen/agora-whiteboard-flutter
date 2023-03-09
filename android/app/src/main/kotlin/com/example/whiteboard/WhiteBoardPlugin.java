package com.example.whiteboard;

import androidx.annotation.NonNull;

import com.example.whiteboard.view.WhiteBoardEventHandler;
import com.example.whiteboard.view.WhiteBoardViewFactory;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * WhiteBoardPlugin
 */
public class WhiteBoardPlugin implements FlutterPlugin {
    private WhiteBoardEventHandler eventHandler;
    private WhiteBoardViewFactory factory;

    public static void registerWith(Registrar registrar) {
        WhiteBoardEventHandler eventHandler = new WhiteBoardEventHandler();
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "whiteboard", new WhiteBoardViewFactory(registrar.messenger(), eventHandler));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        eventHandler = new WhiteBoardEventHandler();
        eventHandler.startListening(binding.getBinaryMessenger());

        factory = new WhiteBoardViewFactory(binding.getBinaryMessenger(), eventHandler);
        binding.getPlatformViewRegistry().registerViewFactory("whiteboard", factory);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        factory = null;
        eventHandler = null;
    }
}