var room;
var penColor = [58, 206, 133];
var scalePpt = 1.0;
var textSize = 28.0;
var strokeSize = 4.0;
var whiteWebSdk;
var elementViewId;
var toolTeaching = "pencil";
var cursorAdapter = {
  createCursor: function (memberId) {
    return { x: -8, y: -8, width: 32, height: 32 };
  },
  onAddedCursor: function (cursor) {
    var name = "";
    var color;
    for (const member of room.state.roomMembers) {
      if (member.memberId === cursor.memberId) {
        if (
          member.payload.cursorName !== null &&
          member.payload.cursorName !== undefined
        ) {
          name = member.payload.cursorName;
          color = member.memberState.strokeColor;
        }
        break;
      }
    }
    if (name !== "") {
      cursor.onCursorMemberChanged = function (_) {
        var nameTag = document.getElementById(
          `${cursor.memberId}cursor-name-tag`
        );
        if (nameTag !== null && nameTag !== undefined) {
          for (const member of room.state.roomMembers) {
            if (member.memberId === cursor.memberId) {
              nameTag.style.backgroundColor = `rgb(${member.memberState.strokeColor[0]}, ${member.memberState.strokeColor[1]}, ${member.memberState.strokeColor[2]})`;
              break;
            }
          }
        }
      };
      cursor.divElement.append(
        createCursorNameTag(cursor.memberId, name, color)
      );
      cursor.divElement.style.width = "fit-content";
    }
  },
};

function createCursorNameTag(id, name, color) {
  var div = document.createElement("div");
  div.id = id + "cursor-name-tag";
  div.className = "cursor-name-tag";
  div.style.backgroundColor = `rgb(${color[0]}, ${color[1]}, ${color[2]})`;
  div.style.borderRadius = "5px";
  div.style.color = "white";
  div.style.overflow = "hidden";
  div.style.whiteSpace = "nowrap";
  div.style.textOverflow = "ellipsis";
  div.style.padding = "5px";
  div.style.margin = "auto";
  div.style.fontSize = "15px";
  div.style.textAlign = "center";
  div.style.verticalAlign = "middle";
  div.innerHTML = name;
  return div;
}

async function joinRoomWhiteboard(
  uuid,
  roomToken,
  userId,
  writable,
  viewMode,
  appIdentifier,
  region,
  viewId,
  userName,
  count,
  isDisableCameraTransform,
) {
  if (viewId != null && viewId != undefined) {
    elementViewId = viewId;
  }
  if (whiteWebSdk == null) {
    whiteWebSdk = new WhiteWebSdk({
      appIdentifier: appIdentifier,
      deviceType: "surface",
      screenType: "desktop",
    });
  }
  onEventWhiteboard("onStartJoin", JSON.stringify({}));
  if (isRoomValidForPerformAction()) {
    room.disconnect().then(function () {
      room = null;
      joinRoomRetry(
        uuid,
        roomToken,
        userId,
        writable,
        viewMode,
        region,
        elementViewId,
        userName,
        count,
        isDisableCameraTransform
      );
    });
  } else {
    joinRoomRetry(
      uuid,
      roomToken,
      userId,
      writable,
      viewMode,
      region,
      elementViewId,
      userName,
      count,
      isDisableCameraTransform
    );
  }
}

async function joinRoomRetry(
  uuid,
  roomToken,
  userId,
  writable,
  viewMode,
  region,
  viewId,
  userName,
  count,
  isDisableCameraTransform
) {
  var joinRoomParams = {
    uuid: uuid,
    roomToken: roomToken,
    uid: userId,
    isWritable: writable,
    disableNewPencil: false,
    cursorAdapter: cursorAdapter,
    userPayload: {
      cursorName: userName,
    },
    region: region,
  };
  onEventWhiteboard("onJoining", JSON.stringify({ count: count }));
  whiteWebSdk
    .joinRoom(joinRoomParams, {
      onPhaseChanged: function (roomPhase) {
        if (roomPhase == "disconnected") {
          room = null;
        }
        onEventWhiteboard(
          "onPhaseChanged",
          JSON.stringify({ roomPhase: roomPhase })
        );
      },
      onRoomStateChanged: function (modifyState) {
        if (
          modifyState.sceneState != undefined &&
          modifyState.sceneState.index != null &&
          modifyState.sceneState.index != undefined
        ) {
          try {
            var path = modifyState.sceneState.scenePath;
            var index = parseIndex(
              modifyState.sceneState.sceneName.replace("scene", "")
            );
            var dir = path.split("/")[1];
            setupToolConfig();
            onEventWhiteboard(
              "onLoadedCurrentScene",
              JSON.stringify({ dir: dir, index: index })
            );
          } catch (e) {
            onEventWhiteboard(
              "onLoadedCurrentScene",
              JSON.stringify({ dir: "", index: 0 })
            );
          }
        }

        if (modifyState.cameraState != undefined) {
          const cameraState = modifyState.cameraState;
          try {
            onEventWhiteboard(
              "onCameraStateChanged",
              JSON.stringify({
                centerX: cameraState.centerX,
                centerY: cameraState.centerY,
                width: cameraState.width,
                height: cameraState.height,
                scale: cameraState.scale,
              })
            );
          } catch (e) { }
        }

        if (modifyState.memberState != undefined) {
          if (modifyState.memberState.currentApplianceName != undefined) {
            onEventWhiteboard(
              "onToolTeachingChanged",
              JSON.stringify({
                tool: modifyState.memberState.currentApplianceName,
              })
            );
          }
        }
      },
    })
    .then(async function (room) {
      this.room = room;
      onEventWhiteboard(
        "onJoinedResult",
        JSON.stringify({ result: true, message: "", count: count })
      );
      room.bindHtmlElement(document.getElementById(viewId));
      room.setViewMode(viewMode);
      room.disableCameraTransform = isDisableCameraTransform;
      room.disableSerialization = false;
      room.disableAutoResize = true;
      room.scalePptToFit("immediately");
      try {
        let sceneState = room.state.sceneState;
        var path = sceneState.scenePath;
        var index = parseIndex(sceneState.sceneName.replace("scene", ""));
        var dir = path.split("/")[1];
        onEventWhiteboard(
          "onLoadedCurrentScene",
          JSON.stringify({ dir: dir, index: index })
        );
      } catch (e) {
        onEventWhiteboard(
          "onLoadedCurrentScene",
          JSON.stringify({ dir: "", index: 0 })
        );
      }
    })
    .catch(function (err) {
      if (navigator.onLine) {
        onEventWhiteboard(
          "onJoinedResult",
          JSON.stringify({ result: false, message: String(err), count: count })
        );
      }
    });
}

function setupToolConfig() {
  if (isRoomValidForPerformAction()) {
    room.setMemberState({
      currentApplianceName: toolTeaching,
      strokeColor: penColor,
      strokeWidth: strokeSize / scalePpt,
    });
  }
  setTextSize(textSize);
}

function parseIndex(name) {
  var index = 0;
  try {
    var tempIndex = parseInt(name);
    if (tempIndex != null && tempIndex != undefined && !isNaN(tempIndex)) {
      index = tempIndex;
    }
  } catch (e) { }
  return index;
}

// action function
function leaveRoom() {
  if (isRoomValidForPerformAction()) {
    room.disconnect().then(function () {
      room = null;
    });
  }
}

function cleanScene(retainPpt) {
  if (isRoomValidForPerformAction()) {
    room.cleanCurrentScene(retainPpt);
  }
}

function disableCameraTransform(disable) {
  if (isRoomValidForPerformAction()) {
    room.disableCameraTransform = disable;
  }
}

function disableDeviceInputs(disable) {
  if (isRoomValidForPerformAction()) {
    room.disableDeviceInputs = disable;
  }
}

function setPencilColor(r, g, b) {
  penColor = [r, g, b];
  if (isRoomValidForPerformAction()) {
    room.setMemberState({
      strokeColor: penColor,
    });
  }
}

function setViewMode(viewMode) {
  if (isRoomValidForPerformAction()) {
    room.setViewMode(viewMode);
  }
}

function switchToolTeaching(tool) {
  toolTeaching = tool;
  if (isRoomValidForPerformAction()) {
    room.setMemberState({
      currentApplianceName: tool,
    });
  }
}

async function insertImageUrl(url, width, height) {
  var timeStampUuid = Date.now();
  if (isRoomValidForPerformAction()) {
    await room.insertImage({
      uuid: timeStampUuid,
      centerX: 0,
      centerY: 0,
      width: width,
      height: height,
    });

    await room.completeImageUpload(timeStampUuid, url);
  }
}

async function insertPptUrl(dir, index, url, width, height) {
  if (index == null || index == undefined) {
    index = 0;
  }

  try {
    jumpToPage(dir, index);
  } catch (e) {
    if (isRoomValidForPerformAction()) {
      var scene = {
        name: "scene" + index.toString(),
        ppt: { src: url, width: width, height: height },
      };
      room.putScenes(dir, [scene], index);
      room.setScenePath(dir + "/" + "scene" + index);
      if (penColor != null) {
        setPencilColor(penColor);
      }
    }
  }
}

async function insertMultiPpt(dir, urls, index, widths, heights) {
  if (index == null || index == undefined) {
    index = 0;
  }
  try {
    jumpToPage(dir, index);
  } catch (e) {
    var scenes = [];
    if (isRoomValidForPerformAction()) {
      urls.forEach(function (url) {
        var scene = {
          name: "scene" + index.toString(),
          ppt: { src: url, width: widths[index], height: heights[index] },
        };
        scenes.push(scene);
        index++;
      });

      room.putScenes(dir, scenes, 0);
      room.setScenePath(dir + "/" + "scene" + 0);
      if (penColor != null) {
        setPencilColor(penColor);
      }
    }
  }
}

function jumpToPage(dir, index) {
  if (isRoomValidForPerformAction()) {
    var path = dir + "/" + "scene" + index;
    room.setScenePath(path);
  }
}

function jumpToInitPage() {
  if (isRoomValidForPerformAction()) {
    room.setScenePath("/init");
  }
}

function removeScene(path) {
  if (isRoomValidForPerformAction()) {
    room.removeScenes(path);
  }
}

function moveCamera(centerX, centerY, scale, animationMode) {
  if (isRoomValidForPerformAction()) {
    room.moveCamera({
      centerX: centerX,
      centerY: centerY,
      scale: scale,
      animationMode: animationMode,
    });
  }
}

function scalePptToFit() {
  if (isRoomValidForPerformAction()) {
    room.scalePptToFit("immediately");
  }
}

function refreshViewSize() {
  if (isRoomValidForPerformAction()) {
    room.refreshViewSize();
  }
}

async function updateScalePpt(scale) {
  if (scalePpt != scale) {
    if (isRoomValidForPerformAction()) {
      this.scalePpt = scale;
      setStrokeWidth(strokeSize);
      setTextSize(textSize);
    }
  }
}

function setStrokeWidth(strokeWidth) {
  if (isRoomValidForPerformAction()) {
    this.strokeSize = strokeWidth;
    try {
      room.setMemberState({
        strokeWidth: strokeWidth / scalePpt,
      });
    } catch (e) { }
  }
}

function setTextSize(fontSize) {
  if (isRoomValidForPerformAction()) {
    this.textSize = fontSize;
    try {
      room.setMemberState({
        textSize: fontSize / scalePpt,
      });
    } catch (e) { }
  }
}

function setCameraBound(centerX, centerY, minScale, maxScale, width, height) {
  if (isRoomValidForPerformAction()) {
    room.setCameraBound(
      {
        centerX: centerX,
        centerY: centerY,
        width: width,
        height: height,
        damping: 0.0,
        minContentMode: (screenSize, boundSize) => {
          return minScale;
        },
        maxContentMode: (screenSize, boundSize) => {
          return maxScale;
        }
      }
    );
  }
}

function redo() {
  if (isRoomValidForPerformAction()) {
    room.redo();
  }
}

function undo() {
  if (isRoomValidForPerformAction()) {
    room.undo();
  }
}

function scenePreview(dir, sceneName, imagePath, viewId) {
  if (isRoomValidForPerformAction()) {
    try {
      let isSceneExist = false;
      const existScenes = room.entireScenes();
      const currentScenes = existScenes[dir];
      for (const scene of currentScenes) {
        if (scene.name === sceneName) {
          isSceneExist = true;
          break;
        }
      }
      if (isSceneExist) {
        const previewWhiteboardView = document.getElementById(viewId);
        room.fillSceneSnapshot(`${dir}/${sceneName}`, previewWhiteboardView);
        onEventWhiteboard(
          "onGetScenePreviewImage",
          JSON.stringify({ result: true, placeHolder: "" })
        );
      } else {
        onEventWhiteboard(
          "onGetScenePreviewImage",
          JSON.stringify({ result: false, placeHolder: imagePath })
        );
      }
    } catch (e) {
      onEventWhiteboard(
        "onGetScenePreviewImage",
        JSON.stringify({ result: false, placeHolder: imagePath })
      );
    }
  }
}

function isRoomValidForPerformAction() {
  if (room != null && room != undefined && room?.phase == "connected") {
    return true;
  }
  return false;
}

async function getCurrentSceneSizeWhiteboardAction() {
  if (isRoomValidForPerformAction()) {
    try {
      const currentSceneIndex = room.state.sceneState.index;
      const width = room.state.sceneState.scenes[currentSceneIndex].ppt.width;
      const height = room.state.sceneState.scenes[currentSceneIndex].ppt.height;
      return JSON.stringify({ width: width, height: height });
    } catch (ignored) { }
  }
  return null;
}

function setWhiteboardViewBackgroundColor(r, g, b) {
  const element = document.getElementById(elementViewId);
  if (element !== undefined && element !== null) {
    element.style.backgroundColor = `rgb(${r}, ${g}, ${b})`;
  }
}