package com.example.whiteboard.view;

import static android.content.ContentValues.TAG;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.herewhite.sdk.RoomListener;
import com.herewhite.sdk.domain.CameraState;
import com.herewhite.sdk.domain.RoomPhase;
import com.herewhite.sdk.domain.RoomState;
import com.herewhite.sdk.domain.SceneState;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

public class WhiteBoardEventHandler implements EventChannel.StreamHandler, RoomListener {
    private final Handler mEventHandler = new Handler(Looper.getMainLooper());
    private EventChannel.EventSink sink;
    private EventChannel channel;


    public void startListening(BinaryMessenger messenger) {
        if (channel != null) {
            Log.wtf(TAG, "Setting a method call handler before the last was disposed.");
            stopListening();
        }

        channel = new EventChannel(messenger, "whiteboard_event_channel");
        channel.setStreamHandler(this);
    }

    public void stopListening() {
        if (channel == null) {
            Log.d(TAG, "Tried to stop listening when no EventChannel had been initialized.");
            return;
        }

        channel.setStreamHandler(null);
        channel = null;
    }

    public void sendEvent(final String eventName, final HashMap<String, Object> map) {
        map.put("event", eventName);
        mEventHandler.post(() -> {
            if (sink != null) {
                sink.success(map);
            }
        });
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.sink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        this.sink = null;
    }

    public void onJoinRoomResult(Boolean result, String message, int count) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(ConstantKeys.RESULT, result);
        map.put(ConstantKeys.MESSAGE, message);
        map.put(ConstantKeys.COUNT, count);
        sendEvent("onJoinRoomResult", map);
    }

    public void onJoining(int count) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(ConstantKeys.COUNT, count);
        sendEvent("onJoining", map);
    }

    public void onStart() {
        HashMap<String, Object> map = new HashMap<>();
        sendEvent("onStart", map);
    }

    @Override
    public void onPhaseChanged(RoomPhase phase) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(ConstantKeys.ROOM_PHASE, phase.toString());
        sendEvent("onPhaseChanged", map);
    }

    @Override
    public void onDisconnectWithError(Exception e) {

    }

    @Override
    public void onKickedWithReason(String reason) {

    }

    @Override
    public void onRoomStateChanged(RoomState modifyState) {
        final SceneState sceneState = modifyState.getSceneState();
        if (sceneState != null) {
            final String path = sceneState.getScenePath();
            int index = 0;
            try {
                index = Integer.parseInt(sceneState.getScenes()[sceneState.getIndex()].getName().replace(ConstantKeys.SCENE, ""));
            } catch (Exception e) {
                System.out.println(e);
            }
            String dir = path.split("/")[1];
            HashMap<String, Object> map = new HashMap<>();
            map.put(ConstantKeys.DIRECTORY, dir);
            map.put(ConstantKeys.INDEX, index);
            sendEvent("onLoadedCurrentScene", map);
        }

        final CameraState cameraState = modifyState.getCameraState();
        if (cameraState != null) {
            HashMap<String, Object> map = new HashMap<>();
            map.put(ConstantKeys.CENTER_X, cameraState.getCenterX());
            map.put(ConstantKeys.CENTER_Y, cameraState.getCenterY());
            map.put(ConstantKeys.SCALE_PPT, cameraState.getScale());
            sendEvent("onCameraStateChanged", map);
        }
    }

    @Override
    public void onCanUndoStepsUpdate(long canUndoSteps) {

    }

    @Override
    public void onCanRedoStepsUpdate(long canRedoSteps) {

    }

    @Override
    public void onCatchErrorWhenAppendFrame(long userId, Exception error) {

    }
}
