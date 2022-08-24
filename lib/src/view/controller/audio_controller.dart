import 'dart:async';

import 'package:chewie_audio/src/chewie_audio_player.dart';
import 'package:chewie_audio/src/chewie_progress_colors.dart';
import 'package:chewie_audio/src/notifiers/play_notifier.dart';
import 'package:chewie_audio/src/view/controller/components/audio_play_button.dart';
import 'package:chewie_audio/src/view/controller/components/audio_progress_bar.dart';
import 'package:chewie_audio/src/view/controller/components/audio_option_dialog.dart';
import 'package:chewie_audio/src/view/controller/components/audio_option_item.dart';
import 'package:chewie_audio/src/view/controller/components/audio_playback_speed_dialog.dart';
import 'package:chewie_audio/src/view/controller/components/audio_time_position.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AudioController extends StatefulWidget {
  const AudioController({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AudioControllerState();
  }
}

class _AudioControllerState extends State<AudioController> with SingleTickerProviderStateMixin {
  late PlayerNotifier notifier;
  late VideoPlayerValue _latestValue;
  Timer? _hideTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  late VideoPlayerController controller;
  ChewieAudioController? _chewieController;

  // We know that _chewieController is set in didChangeDependencies
  ChewieAudioController get chewieController => _chewieController!;

  @override
  void initState() {
    super.initState();
    notifier = Provider.of<PlayerNotifier>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    final _oldController = _chewieController;
    _chewieController = ChewieAudioController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder?.call(
            context,
            chewieController.videoPlayerController.value.errorDescription!,
          ) ??
          const Center(
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 42,
            ),
          );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: notifier.hideStuff,
          child: AnimatedOpacity(
            opacity: notifier.hideStuff ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildHitArea(),
                if (chewieController.showOptions)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildOptionsButton(),
                  ),
                if (chewieController.showOptions)
                  Positioned(
                    bottom: 0,
                    child: _buildBottomBar(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHitArea() {
    final bool isFinished = _latestValue.position >= _latestValue.duration;

    return GestureDetector(
      onTap: () {
        if (_latestValue.isPlaying) {
          if (_displayTapped) {
            setState(() {
              notifier.hideStuff = true;
            });
          } else {
            _cancelAndRestartTimer();
          }
        } else {
          _playPause();

          setState(() {
            notifier.hideStuff = true;
          });
        }
      },
      child: AnimatedOpacity(
        opacity: _dragging ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: AudioPlayButton(
          backgroundColor: Colors.black54,
          iconColor: Colors.white,
          isFinished: isFinished,
          isPlaying: controller.value.isPlaying,
          show: !_dragging && !notifier.hideStuff,
          onPressed: _playPause,
        ),
      ),
    );
  }

  Widget _buildOptionsButton() {
    return IconButton(
      onPressed: () async {
        _hideTimer?.cancel();

        await showModalBottomSheet<AudioOptionItem>(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) => AudioOptionsDialog(
            options: <AudioOptionItem>[
              AudioOptionItem(
                onTap: () async {
                  Navigator.pop(context);
                  final chosenSpeed = await showModalBottomSheet<double>(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    builder: (context) => AudioPlaybackSpeedDialog(
                      speeds: chewieController.playbackSpeeds,
                      selectedColor: Theme.of(context).primaryColor,
                      selected: _latestValue.playbackSpeed,
                    ),
                  );

                  if (chosenSpeed != null) {
                    controller.setPlaybackSpeed(chosenSpeed);
                  }
                },
                iconData: Icons.speed,
                title: 'Playback speed',
              )
            ],
            cancelButtonText: 'Cancel',
          ),
        );

        if (_latestValue.isPlaying) {
          _startHideTimer();
        }
      },
      icon: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.button!.color;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: barHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimerPosition(),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildTimerPosition() {
    final position = _latestValue.position;
    final duration = _latestValue.duration;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: AudioTimePosition(
        position: position,
        duration: duration,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: AudioProgressBar(
          controller: controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              ChewieProgressColors(
                playedColor: Theme.of(context).accentColor,
                handleColor: Theme.of(context).accentColor,
                bufferedColor: Theme.of(context).backgroundColor,
                backgroundColor: Theme.of(context).disabledColor,
              ),
          barHeight: 2,
          handleHeight: 6,
          drawShadow: false,
        ),
      ),
    );
  }

  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.isPlaying) {
        notifier.hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration.zero);
          }
          controller.play();
        }
      }
    });
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      notifier.hideStuff = false;
      _displayTapped = true;
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        notifier.hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Future<void> _initialize() async {
    controller.addListener(_updateState);
    _updateState();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

// NOTE(ToshiakiSatsuma): 今後同様の機能を実装する際参考にできるため残しておく
// Widget _buildSpeedButton(
//   VideoPlayerController controller,
// ) {
//   return GestureDetector(
//     onTap: () async {
//       final chosenSpeed = await showModalBottomSheet<double>(
//         context: context,
//         isScrollControlled: true,
//         useRootNavigator: true,
//         builder: (context) => _PlaybackSpeedDialog(
//           speeds: chewieController.playbackSpeeds,
//           selected: _latestValue.playbackSpeed,
//         ),
//       );
//
//       if (chosenSpeed != null) {
//         controller.setPlaybackSpeed(chosenSpeed);
//       }
//     },
//     child: AudioSpeedButton(
//       height: barHeight,
//     ),
//   );
// }

// NOTE(ToshiakiSatsuma): 今後同様の機能を実装する際参考にできるため残しておく
// GestureDetector _buildMuteButton(
//   VideoPlayerController controller,
// ) {
//   return GestureDetector(
//     onTap: () {
//       if (_latestValue.volume == 0) {
//         controller.setVolume(_latestVolume ?? 0.5);
//       } else {
//         _latestVolume = controller.value.volume;
//         controller.setVolume(0.0);
//       }
//     },
//     child: AudioMuteButton(
//       height: barHeight,
//       iconData: _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
//     ),
//   );
// }
}
