import 'package:chewie_audio/src/view/controller/animated_play_pause.dart';
import 'package:flutter/material.dart';

class AudioMuteButton extends StatelessWidget {
  const AudioMuteButton({
    Key? key,
    required this.height,
    required this.iconData,
  }) : super(key: key);

  final double height;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        height: height,
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: Icon(
          iconData,
        ),
      ),
    );
  }
}
