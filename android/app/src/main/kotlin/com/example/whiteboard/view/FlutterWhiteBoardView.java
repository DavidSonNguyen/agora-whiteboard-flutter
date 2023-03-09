package com.example.whiteboard.view;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import androidx.annotation.NonNull;

import com.herewhite.sdk.Room;
import com.herewhite.sdk.RoomParams;
import com.herewhite.sdk.WhiteSdk;
import com.herewhite.sdk.WhiteSdkConfiguration;
import com.herewhite.sdk.WhiteboardView;
import com.herewhite.sdk.domain.AnimationMode;
import com.herewhite.sdk.domain.CameraConfig;
import com.herewhite.sdk.domain.ImageInformationWithUrl;
import com.herewhite.sdk.domain.MemberState;
import com.herewhite.sdk.domain.PptPage;
import com.herewhite.sdk.domain.Promise;
import com.herewhite.sdk.domain.Region;
import com.herewhite.sdk.domain.SDKError;
import com.herewhite.sdk.domain.Scene;
import com.herewhite.sdk.domain.SceneState;
import com.herewhite.sdk.domain.ViewMode;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class FlutterWhiteBoardView implements PlatformView, MethodChannel.MethodCallHandler {
    private WhiteboardView whiteboardView;
    private WhiteSdk whiteSdk;
    private Room room;
    private final WhiteBoardEventHandler eventHandler;
    final Context context;
    private ArrayList<Integer> colors = new ArrayList<>(Arrays.asList(58, 206, 133));
    private Double scalePpt = 1.0;
    private Double strokeSize = 4.0;
    private Double fontSize = 28.0;
    private boolean isTouchable = false;

    FlutterWhiteBoardView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params, WhiteBoardEventHandler eventHandler) {
        MethodChannel methodChannel = new MethodChannel(messenger, "whiteboard");
        methodChannel.setMethodCallHandler(this);
        whiteboardView = new WhiteboardView(context, null);
        whiteboardView.setBackgroundColor(Color.TRANSPARENT);
        whiteboardView.setOnTouchListener((v, event) -> !isTouchable);
        this.eventHandler = eventHandler;
        this.context = context;
    }

    @Override
    public View getView() {
        return whiteboardView;
    }

    @Override
    public void dispose() {
        whiteboardView = null;
        this.whiteSdk = null;
        this.room = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final MethodChannel.Result result) {
        String method = call.method;
        switch (method) {
            case "joinRoom":
                String appId = "";
                final String region = call.argument(ConstantKeys.REGION);
                if (this.whiteSdk == null) {
                    appId = call.argument(ConstantKeys.APP_IDENTIFIER);
                    WhiteSdkConfiguration configurationJoin = new WhiteSdkConfiguration(appId);
                    configurationJoin.setUserCursor(true);
                    if (region != null && !region.isEmpty()) {
                        configurationJoin.setRegion(Region.valueOf(region));
                    }
                    this.whiteSdk = new WhiteSdk(whiteboardView, context, configurationJoin);
                }
                final String uuid = call.argument(ConstantKeys.UUID);
                final String uid = call.argument(ConstantKeys.UID);
                final String roomToken = call.argument(ConstantKeys.ROOM_TOKEN);
                final String mode = call.argument(ConstantKeys.MODE);
                Boolean writable = call.argument(ConstantKeys.WRITABLE);
                final String userName = call.argument(ConstantKeys.USER_NAME);
                final Integer count = call.argument(ConstantKeys.COUNT);
                final Boolean disableCameraTransform = call.argument(ConstantKeys.DISABLE_CAMERA_TRANSFORM);
                if (writable == null) {
                    writable = true;
                }
                if (uuid == null && roomToken == null) {
                    result.error("missing_data", "Missing uuid and roomToken", null);
                } else if (uuid == null) {
                    result.error("missing_data", "Missing uuid", null);
                } else if (roomToken == null) {
                    result.error("missing_data", "Missing roomToken", null);
                } else {
                    eventHandler.onStart();
                    joinRoom(appId, uuid, roomToken, uid, mode, writable, userName, region, count, disableCameraTransform);
                    result.success(null);
                }
                break;
            case "leaveRoom":
                if (this.room != null) {
                    room.disconnect();
                    room = null;
                    whiteSdk = null;
                    result.success(null);
                }
                result.notImplemented();
                break;
            case "insertImageUrl": {
                if (room != null) {
                    String url = call.argument(ConstantKeys.URL);
                    if (url == null) {
                        url = "";
                    }
                    Double width = call.argument(ConstantKeys.WIDTH);
                    Double height = call.argument(ConstantKeys.HEIGHT);
                    if (width == null) {
                        width = 0.0;
                    }

                    if (height == null) {
                        height = 0.0;
                    }
                    if (this.room != null) {
                        ImageInformationWithUrl imageInformationWithUrl = new ImageInformationWithUrl(
                                0.0,
                                0.0,
                                width,
                                height,
                                url
                        );
                        this.room.insertImage(imageInformationWithUrl);
                        result.success(null);
                    }
                }
                result.notImplemented();
            }
            break;
            case "cleanScene":
                if (room != null) {
                    this.room.cleanScene(true);
                }
                result.success(null);
                break;
            case "switchToolTeaching": {
                if (room != null) {
                    String tool = call.argument(ConstantKeys.TOOL);
                    MemberState state = this.room.getMemberState();
                    state.setCurrentApplianceName(tool);
                    this.room.setMemberState(state);
                }
                result.success(null);
            }
            break;
            case "setViewMode":
                if (room != null) {
                    String m = call.argument(ConstantKeys.MODE);
                    this.room.setViewMode(ViewMode.valueOf(m));
                }
                result.success(null);
                break;
            case "disableCameraTransform":
                if (room != null) {
                    boolean disable = Boolean.TRUE.equals(call.argument(ConstantKeys.DISABLE));
                    this.room.disableCameraTransform(disable);
                }
                result.success(null);
                break;
            case "insertPptUrl": {
                if (room != null) {
                    String dir = call.argument(ConstantKeys.DIRECTORY);
                    String url = call.argument(ConstantKeys.URL);
                    int index = call.argument(ConstantKeys.INDEX);
                    if (url == null) {
                        url = "";
                    }
                    Double width = call.argument(ConstantKeys.WIDTH);
                    Double height = call.argument(ConstantKeys.HEIGHT);
                    if (width == null) {
                        width = 0.0;
                    }

                    if (height == null) {
                        height = 0.0;
                    }
                    Scene sc = new Scene(ConstantKeys.SCENE + index, new PptPage(url, width, height));
                    room.putScenes(dir, new Scene[]{sc}, index);
                    room.setScenePath(dir + "/" + ConstantKeys.SCENE + index);
                }
                result.success(null);
            }
            break;
            case "jumpToPage":
                if (room != null) {
                    String dir = call.argument(ConstantKeys.DIRECTORY);
                    int index = call.argument(ConstantKeys.INDEX);
                    String path = dir + "/" + ConstantKeys.SCENE + index;
                    room.setScenePath(path);
                }
                result.success(null);
                break;
            case "disableDeviceInputs":
                boolean disable = Boolean.TRUE.equals(call.argument(ConstantKeys.DISABLE));
                isTouchable = !disable;
                if (room != null) {
                    room.disableDeviceInputs(disable);
                }
                result.success(null);
                break;
            case "setPencilColor":
                colors = call.argument(ConstantKeys.COLOR);
                setPencilColor(colors);
                result.success(null);
                break;
            case "scalePptToFit":
                if (room != null) {
                    room.scalePptToFit(AnimationMode.Immediately);
                }
                result.success(null);
                break;
            case "refreshViewSize":
                if (room != null) {
                    room.refreshViewSize();
                }
                result.success(null);
                break;
            case "updateScalePpt":
                scalePpt = call.argument(ConstantKeys.SCALE_PPT);
                updateScalePpt();
                result.success(null);
                break;
            case "setTextSize":
                fontSize = call.argument(ConstantKeys.FONT_SIZE);
                setFontSize(fontSize);
                result.success(null);
                break;
            case "setStrokeWidth":
                strokeSize = call.argument(ConstantKeys.STROKE_WIDTH);
                setStrokeSize(strokeSize);
                result.success(null);
                break;
            case "redo":
                if (room != null) {
                    room.redo();
                }
                result.success(null);
                break;
            case "undo":
                if (room != null) {
                    room.undo();
                }
                result.success(null);
                break;
            case "getScenePreviewImage":
                if (room != null) {
                    String dir = call.argument(ConstantKeys.DIRECTORY);
                    String sceneName = call.argument(ConstantKeys.SCENE_NAME);
                    String imagePath = call.argument(ConstantKeys.IMAGE_PATH);
                    GetScenePreviewImageHandler handler = new GetScenePreviewImageHandler(room, eventHandler);
                    handler.handle(dir + "/" + sceneName, imagePath, dir, sceneName);
                }
                result.success(null);
                break;
            case "moveCamera":
                if (room != null) {
                    Double scale = call.argument(ConstantKeys.SCALE_PPT);
                    Double centerX = call.argument(ConstantKeys.CENTER_X);
                    Double centerY = call.argument(ConstantKeys.CENTER_Y);
                    CameraConfig cameraConfig = new CameraConfig();
                    cameraConfig.setScale(scale);
                    cameraConfig.setCenterX(centerX);
                    cameraConfig.setCenterY(centerY);
                    room.moveCamera(cameraConfig);
                }
                result.success(null);
                break;
            case "getCurrentSceneSizeWhiteboardAction":
                if (room != null) {
                    try {
                        int currentIndex = room.getSceneState().getIndex();
                        double width = room.getScenes()[currentIndex].getPpt().getWidth();
                        double height = room.getScenes()[currentIndex].getPpt().getHeight();
                        HashMap<String, Object> map = new HashMap<>();
                        map.put(ConstantKeys.WIDTH, width);
                        map.put(ConstantKeys.HEIGHT, height);
                        result.success(map);
                    } catch (Exception ignored) {}
                } else {
                    result.success(null);
                }
                break;
            case "setWhiteboardViewBackgroundColor":
                ArrayList<Integer> backgroundColor = call.argument(ConstantKeys.COLOR);
                if (backgroundColor != null) {
                    Integer red = backgroundColor.get(0);
                    Integer green = backgroundColor.get(1);
                    Integer blue = backgroundColor.get(2);
                    if (whiteboardView != null && room != null) {
                        whiteboardView.setBackgroundColor(Color.rgb(red, green, blue));
                    }
                }
                result.success(null);
                break;
            default:
                result.success(null);
                break;
        }
    }

    private void setPencilColor(ArrayList<Integer> colors) {
        if (room != null) {
            MemberState state = room.getMemberState();
            state.setStrokeColor(new int[]{colors.get(0), colors.get(1), colors.get(2)});
            room.setMemberState(state);
        }
    }

    private void updateScalePpt() {
        setStrokeSize(strokeSize);
        setFontSize(fontSize);
    }

    private void setStrokeSize(Double size) {
        if (room != null) {
            MemberState state = room.getMemberState();
            state.setStrokeWidth(size / scalePpt);
            room.setMemberState(state);
        }
    }

    private void setFontSize(Double size) {
        if (room != null) {
            MemberState state = room.getMemberState();
            state.setTextSize(size / scalePpt);
            room.setMemberState(state);
        }
    }

    private void setRoom(Room room, String mode) {
        this.room = room;
        this.room.setViewMode(parseViewMode(mode));
    }

    private void joinRoom(final String appId, final String uuid, final String roomToken, final String uid, final String mode, final Boolean writable, final String userName, final String region, final int count, final Boolean disableCameraTransform) {
        eventHandler.onJoining(count);
        if (this.whiteSdk == null) {
            WhiteSdkConfiguration configurationJoin = new WhiteSdkConfiguration(appId);
            configurationJoin.setUserCursor(true);
            if (!region.isEmpty()) {
                configurationJoin.setRegion(Region.valueOf(region));
            }

            this.whiteSdk = new WhiteSdk(whiteboardView, context, configurationJoin);
        }

        RoomParams roomParams = new RoomParams(uuid, roomToken, uid, new Cursor(userName));
        roomParams.setWritable(writable);
        roomParams.setDisableNewPencil(false);
        roomParams.setDisableCameraTransform(disableCameraTransform);
        if (!region.isEmpty()) {
            roomParams.setRegion(Region.valueOf(region));
        }

        this.whiteSdk.joinRoom(roomParams, eventHandler, new Promise<Room>() {
            @Override
            public void then(final Room room) {
                eventHandler.onJoinRoomResult(true, "", count);
                final SceneState sceneState = room.getSceneState();
                if (sceneState != null) {
                    final String path = sceneState.getScenePath();
                    String dir = path.split("/")[1];
                    int index = 0;
                    try {
                        index = Integer.parseInt(sceneState.getScenes()[sceneState.getIndex()].getName().replace(ConstantKeys.SCENE, ""));
                    } catch (Exception ignored) {
                    }
                    HashMap<String, Object> map = new HashMap<>();
                    map.put(ConstantKeys.DIRECTORY, dir);
                    map.put(ConstantKeys.INDEX, index);
                    eventHandler.sendEvent("onLoadedCurrentScene", map);
                }
                room.disableSerialization(false);
                setRoom(room, mode);
                if (writable) {
                    MemberState memberState = FlutterWhiteBoardView.this.room.getMemberState();
                    memberState.setCurrentApplianceName(ConstantKeys.SELECTOR);
                    FlutterWhiteBoardView.this.room.setMemberState(memberState);
                }
                FlutterWhiteBoardView.this.room.scalePptToFit(AnimationMode.Immediately);
                setPencilColor(colors);
                setStrokeSize(strokeSize);
                setFontSize(fontSize);
            }

            @Override
            public void catchEx(final SDKError sdkError) {
                eventHandler.onJoinRoomResult(false, sdkError.getMessage(), count);
            }
        });

    }

    private ViewMode parseViewMode(String mode) {
        switch (mode) {
            case "broadcaster":
                return ViewMode.Broadcaster;
            case "follower":
                return ViewMode.Follower;
            case "freedom":
                return ViewMode.Freedom;
        }
        return ViewMode.Freedom;
    }
}
