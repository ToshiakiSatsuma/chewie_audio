import 'package:flutter/material.dart';

class ChewieAudioOptionItem {
  ChewieAudioOptionItem({
    required this.onTap,
    required this.iconData,
    required this.title,
    this.subtitle,
  });

  Function()? onTap;
  IconData iconData;
  String title;
  String? subtitle;

  ChewieAudioOptionItem copyWith({
    Function()? onTap,
    IconData? iconData,
    String? title,
    String? subtitle,
  }) {
    return ChewieAudioOptionItem(
      onTap: onTap ?? this.onTap,
      iconData: iconData ?? this.iconData,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  String toString() =>
      'OptionItem(onTap: $onTap, iconData: $iconData, title: $title, subtitle: $subtitle)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChewieAudioOptionItem &&
        other.onTap == onTap &&
        other.iconData == iconData &&
        other.title == title &&
        other.subtitle == subtitle;
  }

  @override
  int get hashCode =>
      onTap.hashCode ^ iconData.hashCode ^ title.hashCode ^ subtitle.hashCode;
}
