package com.example.whiteboard.view;

import android.graphics.Bitmap;

import com.herewhite.sdk.Room;
import com.herewhite.sdk.domain.Promise;
import com.herewhite.sdk.domain.SDKError;
import com.herewhite.sdk.domain.Scene;

import java.io.ByteArrayOutputStream;
import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;

class GetScenePreviewImageHandler {
    private final WeakReference<Room> roomReference;
    private final WeakReference<WhiteBoardEventHandler> eventHandlerReference;

    private Room getRoom() {
        return roomReference.get();
    }

    private WhiteBoardEventHandler getEventHandler() {
        return eventHandlerReference.get();
    }

    GetScenePreviewImageHandler(Room room, WhiteBoardEventHandler eventHandler) {
        this.roomReference = new WeakReference<>(room);
        this.eventHandlerReference = new WeakReference<>(eventHandler);
    }

    public void handle(final String scenePath,
                       final String imagePath,
                       final String dir,
                       final String sceneName) {
        final Room room = getRoom();
        if (room != null) {
            room.getEntireScenes(entireScenesPromise(scenePath, imagePath, dir, sceneName));
        }
    }

    private void getScenePreviewImage(String scenePath,
                                      String imagePath) {
        final Room room = getRoom();
        if (room != null) {
            room.getSceneSnapshotImage(scenePath, sceneSnapshotImagePromise(imagePath));
        }
    }

    private Promise<Bitmap> sceneSnapshotImagePromise(final String placeholder) {
        return new Promise<Bitmap>() {
            @Override
            public void then(final Bitmap bitmap) {
                HashMap<String, Object> map = new HashMap<>();
                if (bitmap != null) {
                    byte[] imageData = convertBitmapToJPEG(bitmap);
                    map.put(ConstantKeys.RESULT, true);
                    map.put(ConstantKeys.IMAGE_DATA, imageData);
                } else {
                    map.put(ConstantKeys.RESULT, false);
                }
                map.put(ConstantKeys.PLACE_HOLDER, placeholder);
                final WhiteBoardEventHandler eventHandler = getEventHandler();
                if (eventHandler != null) {
                    eventHandler.sendEvent("onGetScenePreviewImage", map);
                }
            }

            @Override
            public void catchEx(final SDKError sdkError) {
                HashMap<String, Object> defaultMap = new HashMap<>();
                defaultMap.put(ConstantKeys.RESULT, false);
                defaultMap.put(ConstantKeys.PLACE_HOLDER, placeholder);
                final WhiteBoardEventHandler eventHandler = getEventHandler();
                if (eventHandler != null) {
                    eventHandler.sendEvent("onGetScenePreviewImage", defaultMap);
                }
            }
        };
    }

    private Promise<Map<String, Scene[]>> entireScenesPromise(final String scenePath,
                                                              final String imagePath,
                                                              final String dir,
                                                              final String sceneName) {
        final HashMap<String, Object> defaultMap = new HashMap<>();
        defaultMap.put(ConstantKeys.RESULT, false);
        defaultMap.put(ConstantKeys.PLACE_HOLDER, imagePath);
        return new Promise<Map<String, Scene[]>>() {
            @Override
            public void then(final Map<String, Scene[]> result) {
                Scene[] scenes = result.get(dir);
                boolean contains = false;
                if (scenes != null) {
                    for (Scene scene : scenes) {
                        if (scene.getName().equals(sceneName)) {
                            contains = true;
                            break;
                        }
                    }
                }
                if (contains) {
                    getScenePreviewImage(scenePath, imagePath);
                } else {
                    final WhiteBoardEventHandler eventHandler = getEventHandler();
                    if (eventHandler != null) {
                        eventHandler.sendEvent("onGetScenePreviewImage", defaultMap);
                    }
                }
            }

            @Override
            public void catchEx(final SDKError sdkError) {
                final WhiteBoardEventHandler eventHandler = getEventHandler();
                if (eventHandler != null) {
                    eventHandler.sendEvent("onGetScenePreviewImage", defaultMap);
                }
            }
        };
    }

    private byte[] convertBitmapToJPEG(Bitmap bmp) {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, stream);
        byte[] byteArray = stream.toByteArray();
        bmp.recycle();
        return byteArray;
    }
}

