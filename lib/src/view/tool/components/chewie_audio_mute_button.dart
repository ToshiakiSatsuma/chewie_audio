import 'package:chewie_audio/src/view/tool/components/chewie_audio_play_button_icon.dart';
import 'package:flutter/material.dart';

class ChewieAudioMuteButton extends StatelessWidget {
  const ChewieAudioMuteButton({
    Key? key,
    required this.height,
    required this.iconData,
    this.onTap,
  }) : super(key: key);

  final double height;
  final IconData iconData;
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
          child: Icon(
            iconData,
          ),
        ),
      ),
    );
  }
}
