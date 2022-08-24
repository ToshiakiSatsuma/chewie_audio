import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChewieAudioControllerProvider extends InheritedWidget {
  const ChewieAudioControllerProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final ChewieAudioController controller;

  @override
  bool updateShouldNotify(ChewieAudioControllerProvider old) =>
      controller != old.controller;
}
