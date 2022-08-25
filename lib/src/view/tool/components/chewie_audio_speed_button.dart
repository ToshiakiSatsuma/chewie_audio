import 'package:chewie_audio/src/view/tool/components/chewie_audio_play_button_icon.dart';
import 'package:flutter/material.dart';

class ChewieAudioSpeedButton extends StatelessWidget {
  const ChewieAudioSpeedButton({
    Key? key,
    required this.height,
    this.onTap,
  }) : super(key: key);

  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRect(
        child: Container(
          height: height,
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: const Icon(Icons.speed),
        ),
      ),
    );
  }
}
