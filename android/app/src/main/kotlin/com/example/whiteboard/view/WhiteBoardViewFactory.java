package com.example.whiteboard.view;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class WhiteBoardViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final WhiteBoardEventHandler eventHandler;

    public WhiteBoardViewFactory(BinaryMessenger messenger, WhiteBoardEventHandler eventHandler) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.eventHandler = eventHandler;
    }



    @NonNull
    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new FlutterWhiteBoardView(context, messenger, id, params, eventHandler);
    }
}
