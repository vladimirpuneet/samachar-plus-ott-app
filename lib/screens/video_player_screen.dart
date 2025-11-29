import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/components/live_video_player.dart';
import 'package:samachar_plus_ott_app/models.dart';

class VideoPlayerScreen extends StatelessWidget {
  final LiveChannel channel;

  const VideoPlayerScreen({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LiveVideoPlayer(
        channel: channel,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}
