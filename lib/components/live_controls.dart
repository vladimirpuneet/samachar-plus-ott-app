import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:video_player/video_player.dart';

class LiveControls extends StatefulWidget {
  final LiveChannel channel;
  final VoidCallback onClose;

  const LiveControls({
    super.key,
    required this.channel,
    required this.onClose,
  });

  @override
  State<LiveControls> createState() => _LiveControlsState();
}

class _LiveControlsState extends State<LiveControls> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chewieController = ChewieController.of(context);
    _videoPlayerController = _chewieController?.videoPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Close Button (Top Right)
        Positioned(
          top: 40,
          right: 20,
          child: GestureDetector(
            onTap: () {
              if (_chewieController?.isFullScreen ?? false) {
                _chewieController?.exitFullScreen();
              } else {
                widget.onClose();
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
                border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ),

        // Bottom Control Bar
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF111827).withOpacity(0.9),
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
                        widget.channel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.channel.subCategory != null)
                        Text(
                          widget.channel.subCategory!,
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
                    StatefulBuilder(
                      builder: (context, setState) {
                        final isMuted = _videoPlayerController?.value.volume == 0;
                        return IconButton(
                          icon: Icon(
                            isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isMuted) {
                                _videoPlayerController?.setVolume(1);
                              } else {
                                _videoPlayerController?.setVolume(0);
                              }
                            });
                          },
                        );
                      },
                    ),
                    // Fullscreen Toggle
                    IconButton(
                      icon: Icon(
                        (_chewieController?.isFullScreen ?? false)
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_chewieController?.isFullScreen ?? false) {
                          _chewieController?.exitFullScreen();
                        } else {
                          _chewieController?.enterFullScreen();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
