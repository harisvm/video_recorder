import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/camera_overlay.dart';
import 'package:flutter_video/home.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    setToLandScape();

    _initCamera();
    _progressValue = 0.0;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController =
        CameraController(front, ResolutionPreset.max, enableAudio: true);
    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation();

    setState(() => _isLoading = false);
  }

  _recordOrStopVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Home(
          isFromVideoPage: true,
          filePath: file.path,
        ),
      );
      setToPortrait();

      Navigator.pushReplacement(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      _updateProgress();

      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: _isLoading
          ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Colors.white,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      overflow: Overflow.visible,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Opacity(
                              opacity: 1,
                                alwaysIncludeSemantics: true,

                                child: CameraPreview(_cameraController))),


                        Visibility(
                          visible: _isRecording,
                          child: Positioned(
                            top: (MediaQuery.of(context).size.height / 2) - 150,
                            child: Opacity(
                              opacity: 1,
                              child: Container(
                                height: 220,
                                width: 220,
                                margin: const EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    )),
                                // child:const Text(''),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !_isRecording,
                          child: Positioned(
                              top: MediaQuery.of(context).size.height / 2,
                              child: const Text(
                                'You can record maximum 30s of video',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        Positioned(
                          right: 30,
                          bottom: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: FloatingActionButton(
                              backgroundColor: Colors.red,
                              child: Icon(
                                  _isRecording ? Icons.stop : Icons.circle),
                              onPressed: () => _recordOrStopVideo(),
                            ),
                          ),
                        ),
                        _isRecording
                            ? Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: SliderTheme(
                                        data: const SliderThemeData(
                                            thumbColor: Colors.blue,
                                            trackHeight: 2,
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.grey),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Slider(
                                            value: _progressValue,
                                            max: 30,
                                            divisions: 30,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          _progressValue.toStringAsFixed(0) +
                                              "s",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                              )
                            : Container(
                                height: 0,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );

    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordOrStopVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }

  void setToLandScape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void setToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      _progressValue += 1;
      setState(() {});
      if (_progressValue.toStringAsFixed(1) == '30.0') {
        t.cancel();
        _progressValue = 0.0;
        _recordOrStopVideo();
      }
    });
  }
}
