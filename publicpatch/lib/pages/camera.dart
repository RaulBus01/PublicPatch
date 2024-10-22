import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/pages/imagePreview.dart';
import 'dart:math' as math;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.cameras});

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraController? _cameraController;
  bool _isRearCameraSelected = true;
  bool _isFlashOn = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera(widget.cameras![0]);
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);
    try {
      await _cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      debugPrint('Error: Camera is not initialized');
      return null;
    }
    if (_cameraController!.value.isTakingPicture) {
      debugPrint('Camera is busy taking picture');
      return null;
    }
    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.torch);
      } else {
        await _cameraController!.setFlashMode(FlashMode.off);
      }
      XFile picture = await _cameraController!.takePicture();
      await _cameraController!.setFlashMode(FlashMode.off);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImagePreviewPage(picture: picture)));
    } catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    } finally {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      }
    }
  }

  Future toggleFlash() async {
    if (!_cameraController!.value.isInitialized) {
      debugPrint('Error: Camera is not initialized');
      return null;
    }
    setState(() => _isFlashOn = !_isFlashOn);
    debugPrint(
        'Flash is ${_isFlashOn ? 'enabled' : 'disabled'} for next photo');
  }

  @override
  Widget build(BuildContext context) {
    return cameraUI();
  }

  Scaffold cameraUI() {
    final size = MediaQuery.of(context).size;
    final double mirror = _isRearCameraSelected ? 0 : math.pi;
    return Scaffold(
      body: Stack(
        children: [
          (_cameraController!.value.isInitialized)
              ? SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                          width: 100,
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(
                                  mirror), // This is the line that flips the camera

                              child: CameraPreview(_cameraController!)))))
              : Container(
                  color: Colors.transparent,
                  child: const Center(child: CircularProgressIndicator())),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(12, 10),
                      bottom: Radius.elliptical(12, 10)),
                  color: Color.fromARGB(138, 30, 30, 30)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                _isRearCameraSelected
                    ? Expanded(
                        child: IconButton(
                        onPressed: () => toggleFlash(),
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                            _isFlashOn
                                ? Ionicons.flash_outline
                                : Ionicons.flash_off_outline,
                            color: Color(0xff9DA4B3)),
                      ))
                    : const Expanded(child: SizedBox(width: 50)),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Ionicons.radio_button_on_outline,
                      color: Color(0xff9DA4B3)),
                )),
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRearCameraSelected
                          ? Ionicons.camera_reverse
                          : Ionicons.camera_reverse_outline,
                      color: Color(0xff9DA4B3)),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                )),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
