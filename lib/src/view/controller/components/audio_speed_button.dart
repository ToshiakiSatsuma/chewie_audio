import 'package:chewie_audio/src/view/controller/components/animated_play_pause.dart';
import 'package:flutter/material.dart';

class AudioSpeedButton extends StatelessWidget {
  const AudioSpeedButton({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        height: height,
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: const Icon(Icons.speed),
      ),
    );
  }
}
