import 'dart:async';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui show window;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'dart:collection';
import 'dart:ui' as ui show window, PointerDataPacket;

void runFxApp(Widget app, {@required Size uiSize}) {
  _FxWidgetsFlutterBinding.ensureInitialized(uiSize)
    ..scheduleAttachRootWidget(app)
    ..scheduleWarmUpFrame();
}

class _FxWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static final String TAG = "【_FxWidgetsFlutterBinding】";
  final Size _uiSize;

  _FxWidgetsFlutterBinding(this._uiSize);

  static _FxWidgetsFlutterBinding ensureInitialized(Size uiSize) {
    assert(uiSize != null);
    if (WidgetsBinding.instance == null) _FxWidgetsFlutterBinding(uiSize);
    double ratio;
    double uiWidth = uiSize.width;
    print(
        "$TAG 设计稿标准尺寸 = ${uiSize.toString()} h/w tanθ= ${1 / uiSize.aspectRatio}");
    print(
        "$TAG 设备的屏幕尺寸 =${ui.window.physicalSize}  h/w tanθ=${1 / ui.window.physicalSize.aspectRatio}");
    if (ui.window.physicalSize.aspectRatio > uiSize.aspectRatio) {
      print("$TAG 尺码过大 请启用纵向滑动式适配");
    } else if (ui.window.physicalSize.aspectRatio < uiSize.aspectRatio) {
      print("$TAG 尺码过小 设置需要留白的区域");
    } else {
      print("$TAG 尺码完全符合");
    }
    if (uiSize.width > 720) {
      print("warn 请以pt初始化ui尺寸");
    }

    ratio = (ui.window.physicalSize.width / uiWidth);
    print("$TAG 原本屏幕尺寸比率=${ui.window.devicePixelRatio}");
    print("$TAG 转换后的屏幕尺寸比率=${ratio}");
    return WidgetsBinding.instance;
  }

  @protected
  void scheduleAttachRootWidget(Widget rootWidget) {
    Timer.run(() {
      attachRootWidget(RoorRenderObjectWidget(rootWidget));
    });
  }

  ///override RendererBinding
  @override
  ViewConfiguration createViewConfiguration() {
    //super.createViewConfiguration();
    return ViewConfiguration(
      size: window.physicalSize / _getAdapterDevicePixelRatio(),
      devicePixelRatio: _getAdapterDevicePixelRatio(),
    );
  }

  ///override GestureBinding
  @override
  void initInstances() {
    super.initInstances();
    ui.window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(ui.PointerDataPacket packet) {
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data, _getAdapterDevicePixelRatio()));
    if (!locked) _flushPointerEventQueue();
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked)
      scheduleMicrotask(_flushPointerEventQueue);
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty)
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult result;
    if (event is PointerDownEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
      assert(() {
        if (debugPrintHitTestResults) debugPrint('$event: $result');
        return true;
      }());
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer);
    } else if (event.down) {
      result = _hitTests[event.pointer];
    } else {
      return; // We currently ignore add, remove, and hover move events.
    }
    if (result != null) dispatchEvent(event, result);
  }

  double _getAdapterDevicePixelRatio() {
    return ui.window.physicalSize.width / _uiSize.width;
  }
}

class RoorRenderObjectWidget extends SingleChildRenderObjectWidget {
  RoorRenderObjectWidget(rootChild) : super(child: rootChild);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderInner();
  }
}

class RenderInner extends RenderPadding {
  RenderInner() : super(padding: EdgeInsets.all(0));

  @override
  // TODO: implement size
  Size get size => printSize();

  printSize() {
    print("printSize    " + (super.size).toString());
    return super.size;
  }
}
