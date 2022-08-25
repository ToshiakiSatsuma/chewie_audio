import 'package:chewie_audio/src/view/tool/components/chewie_audio_play_button_icon.dart';
import 'package:flutter/material.dart';

class ChewieAudioPlayButton extends StatelessWidget {
  const ChewieAudioPlayButton({
    Key? key,
    this.foregroundColor,
    required this.backgroundColor,
    this.iconSize = 32,
    this.buttonSize = 60,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
  }) : super(key: key);

  final Color? foregroundColor;
  final Color backgroundColor;
  final double iconSize;
  final double buttonSize;
  final bool show;
  final bool isPlaying;
  final bool isFinished;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: iconSize,
            icon: isFinished
                ? Icon(Icons.replay, color: foregroundColor)
                : ChewieAudioPlayButtonIcon(
              color: foregroundColor,
              playing: isPlaying,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
