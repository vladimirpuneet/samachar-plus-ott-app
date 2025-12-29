import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/components/live_bottom_bar.dart';
import 'package:video_player/video_player.dart';

class LiveControls extends StatelessWidget {
  final LiveChannel channel;
  final VoidCallback onClose;

  const LiveControls({
    super.key,
    required this.channel,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context);
    final videoPlayerController = chewieController?.videoPlayerController;
    final isFullScreen = chewieController?.isFullScreen ?? false;

    return Stack(
      children: [
        // Close Button (Top Right) - Always Visible
        Positioned(
          top: 40,
          right: 20,
          child: GestureDetector(
            onTap: () {
              if (isFullScreen) {
                chewieController?.exitFullScreen();
              } else {
                onClose();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF374151), Color(0xFF111827)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ),

        // Bottom Control Bar - Only visible in Fullscreen
        if (isFullScreen)
          Align(
            alignment: Alignment.bottomCenter,
            child: LiveBottomBar(
              channel: channel,
              videoPlayerController: videoPlayerController,
              chewieController: chewieController,
            ),
          ),
      ],
    );
  }
}
