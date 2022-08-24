import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    const ChewieAudioDemo(),
  );
}

class ChewieAudioDemo extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ChewieAudioDemo({this.title = 'Chewie Audio Demo'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieAudioDemoState();
  }
}

class _ChewieAudioDemoState extends State<ChewieAudioDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController;
  late ChewieAudioController _chewieAudioController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieAudioController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network('https://www.w3schools.com/html/mov_bbb.mp4');
    await _videoPlayerController.initialize();
    _chewieAudioController = ChewieAudioController(
      thumbnail: Container(
        width: double.infinity,
        height: 200,
        color: Colors.white,
      ),
      videoPlayerController: _videoPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: FutureBuilder<void>(
                  future: initializePlayer(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return Center(
                      child: snapshot.connectionState == ConnectionState.done &&
                              _chewieAudioController.videoPlayerController.value.isInitialized
                          ? ChewieAudioPlayer(
                              controller: _chewieAudioController,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text('Loading'),
                              ],
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
