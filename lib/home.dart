import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/camera_page.dart';
import 'package:flutter_video/video_page.dart';

class Home extends StatefulWidget {
  bool isFromVideoPage;
  String filePath;

  Home({Key? key, this.isFromVideoPage = false, this.filePath = ''})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    setToPortrait();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.isFromVideoPage) {
        showVideoAlert(context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Recorder'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Record'),
              onPressed: () {
                navigateToCamera(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void navigateToCamera(BuildContext context) {
           final route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const CameraPage(),
    );

    Navigator.pushReplacement(context, route);
  }

  void setToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> showVideoAlert({
    required BuildContext context,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, stateSetter) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Your Profile Video",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () {},
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      padding: EdgeInsets.all(8.0),
                      transform: Matrix4.translationValues(20, 0, 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                    label: const Text(''),
                    color: Colors.transparent,
                    height: 26,
                    minWidth: 60,
                  ),
                )
              ],
            ),
            insetPadding:const EdgeInsets.all(1),
            shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            // contentPadding: EdgeInsets.all(20.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 200,
                      child: VideoPage(filePath: widget.filePath)),
                ],
              ),
            ),
            actionsPadding:const EdgeInsets.all(20),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  navigateToCamera(context);

                },
                child:const Text('Record Again'),
              ),
              ElevatedButton(
                onPressed: () async {},
                child: const Text('Upload'),
              )
            ],
          );
        });
      },
    );
  }
}
