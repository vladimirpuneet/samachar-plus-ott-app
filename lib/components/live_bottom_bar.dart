import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:video_player/video_player.dart';

class LiveBottomBar extends StatelessWidget {
  final LiveChannel channel;
  final VideoPlayerController? videoPlayerController;
  final ChewieController? chewieController;

  const LiveBottomBar({
    super.key,
    required this.channel,
    required this.videoPlayerController,
    required this.chewieController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withValues(alpha: 0.9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Report Button
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report submitted')),
              );
            },
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            label: const Text(
              'REPORT NOT WORKING',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          // Channel Info (Centered)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  channel.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                if (channel.subCategory != null)
                  Text(
                    channel.subCategory!,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Controls (Mute & Fullscreen)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mute Toggle
              if (videoPlayerController != null)
                ValueListenableBuilder(
                  valueListenable: videoPlayerController!,
                  builder: (context, value, child) {
                    final isMuted = value.volume == 0;
                    return IconButton(
                      icon: Icon(
                        isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (isMuted) {
                          videoPlayerController!.setVolume(1);
                        } else {
                          videoPlayerController!.setVolume(0);
                        }
                      },
                    );
                  },
                ),

              // Fullscreen Toggle
              if (chewieController != null)
                AnimatedBuilder(
                  animation: chewieController!,
                  builder: (context, child) {
                    return IconButton(
                      icon: Icon(
                        chewieController!.isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (chewieController!.isFullScreen) {
                          chewieController!.exitFullScreen();
                        } else {
                          chewieController!.enterFullScreen();
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
