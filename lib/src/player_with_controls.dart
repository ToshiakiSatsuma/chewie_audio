import 'dart:ui';

import 'package:chewie_audio/src/chewie_player.dart';
import 'package:chewie_audio/src/cupertino_controls.dart';
import 'package:chewie_audio/src/view/controller/material_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieAudioController chewieController = ChewieAudioController.of(context);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            chewieController.thumbnail,
            if (chewieController.showControls)
              chewieController.customControls ?? const MaterialController()
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
