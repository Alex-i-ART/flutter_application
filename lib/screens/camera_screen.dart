import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      _initializeCamera(widget.cameras[0]);
    }
  }

  void _initializeCamera(CameraDescription camera) {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String picturePath = path.join(
        appDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile file = await _controller.takePicture();
      
      // Сохраняем файл в постоянное хранилище
      final File savedImage = File(picturePath);
      await File(file.path).copy(savedImage.path);

      setState(() {
        _capturedImage = XFile(savedImage.path);
      });
    } catch (e) {
      print("Ошибка при съемке: $e");
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    
    final newCamera = _isFrontCamera && widget.cameras.length > 1
        ? widget.cameras[1]
        : widget.cameras[0];
    
    _controller.dispose();
    _initializeCamera(newCamera);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Камера'),
      ),
      body: widget.cameras.isEmpty
          ? const Center(
              child: Text('Камера не найдена'),
            )
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            CameraPreview(_controller),
                            if (_capturedImage != null)
                              Positioned.fill(
                                child: Image.file(
                                  File(_capturedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: Colors.white,
                              ),
                              onPressed: _toggleFlash,
                            ),
                            ElevatedButton(
                              onPressed: _takePicture,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                              ),
                              child: const Icon(
                                Icons.camera,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cameraswitch,
                                color: Colors.white,
                              ),
                              onPressed: _switchCamera,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}