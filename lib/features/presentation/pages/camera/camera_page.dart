import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:expense_app/core/util/application_state_observer.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with AppLifecycleCallback {

  CameraController? controller;

  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();

    _checkPermissionAndInitialize();
    ApplicationStateObserver.registerApplicationStateCallback(this);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || controller?.value.isInitialized == false) {
      return Container();
    }

    return MaterialApp(
      home: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(controller!),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: _buildTakePictureButton()
              ),
            ),
            left: 0,
            right: 0,
            bottom: 16,
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 32),
              child: _buildBackButton()
            ),
            left: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  Widget _buildTakePictureButton() {
    return FloatingActionButton(
        heroTag: "scan",
        child: Image.asset("assets/ic_scan.png", height: 24, width: 24, color: Colors.white,),
        onPressed: () {
          _takePicture();
        }
    );
  }

  Widget _buildBackButton() {
    return FloatingActionButton(
        mini: true,
        heroTag: "back",
        child: const Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white, size: 24,),
        onPressed: () {
          Navigator.pop(context);
        }
    );
  }

  @override
  void dispose() {
    ApplicationStateObserver.unregisterApplicationStateCallback(getRegistrantId());
    super.dispose();
  }

  Future<void> _initDefaultValue() async {
    _cameras = await availableCameras();

    if (_cameras.isEmpty) {
      return;
    }

    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }

  void _checkPermissionAndInitialize() async {
    var statusCamera = await Permission.camera.status;
    var statusStorage = await Permission.storage.status;

    if (statusCamera != PermissionStatus.granted) {
      await Permission.camera.request();
    }
    if (statusStorage != PermissionStatus.granted) {
      await Permission.storage.request();
    }

    statusCamera = await Permission.camera.status;
    statusStorage = await Permission.storage.status;

    if (!statusCamera.isGranted || !statusStorage.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Akses kamera/storage dibutuhkan bro")));
      return;
    }

    _initDefaultValue();
  }

  @override
  void onStateChanged(AppLifecycleState state) {
    if (controller?.value.isInitialized == false) {
      return;
    }
    if (controller == null) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        _showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          _showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          _showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
        // iOS only
          _showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          _showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          _showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
        // iOS only
          _showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showInSnackBar(e.toString());
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _takePicture() async {
    if (controller == null) {
      return;
    }

    if (controller?.value.isInitialized == false) {
      _showInSnackBar('Error: select a camera first.');
      return;
    }

    if (controller?.value.isTakingPicture == true) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile? file = await controller?.takePicture();
      if (file != null) {
        Navigator.pop(context, ImageResult(bytes: await file.readAsBytes()));
      } else {
        _showInSnackBar("Failed to captue image, try again");
      }

    } on CameraException catch (e) {
      _showInSnackBar(e.toString());
    }
  }
}

class ImageResult {

  final Uint8List bytes;

  ImageResult({required this.bytes});

}
