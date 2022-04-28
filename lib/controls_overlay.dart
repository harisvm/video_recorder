import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : const Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 50.0,
                  semanticLabel: 'Play',
                ),
              ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
          },
        ),

      ],
    );
  }
}