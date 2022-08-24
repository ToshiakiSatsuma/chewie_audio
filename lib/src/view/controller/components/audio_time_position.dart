import 'package:chewie_audio/src/utils.dart';
import 'package:chewie_audio/src/utils/string_util.dart';
import 'package:flutter/material.dart';

class AudioTimePosition extends StatelessWidget {
  const AudioTimePosition({
    Key? key,
    required this.position,
    required this.duration,
    this.color = Colors.black,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  final Duration position;
  final Duration duration;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${formatDuration(position)} / ${formatDuration(duration)}',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
