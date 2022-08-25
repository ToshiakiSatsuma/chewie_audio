import 'package:flutter/material.dart';

class ChewieAudioPlaybackSpeedDialog extends StatelessWidget {
  const ChewieAudioPlaybackSpeedDialog({
    Key? key,
    required this.chewie_speeds,
    required this.selectedColor,
    required this.selected,
  }) : super(key: key);

  final List<double>chewie_speeds;
  final Color selectedColor;
  final double selected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: chewie_speeds.length,
      itemBuilder: (context, index) {
        final speed = chewie_speeds[index];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              if (speed == selected)
                Icon(
                  Icons.check,
                  size: 20.0,
                  color: selectedColor,
                )
              else
                Container(width: 20.0),
              const SizedBox(width: 16.0),
              Text(speed.toString()),
            ],
          ),
          selected: speed == selected,
          onTap: () {
            Navigator.of(context).pop(speed);
          },
        );
      },
    );
  }
}
