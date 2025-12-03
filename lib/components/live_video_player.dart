import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/components/live_controls.dart';

class LiveVideoPlayer extends StatefulWidget {
  final LiveChannel channel;
  final VoidCallback onClose;

  const LiveVideoPlayer({
    super.key,
    required this.channel,
    required this.onClose,
  });

  @override
  State<LiveVideoPlayer> createState() => _LiveVideoPlayerState();
}

class _LiveVideoPlayerState extends State<LiveVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.channel.streamUrl),
        formatHint: VideoFormat.hls, // Hint for HLS streams
      );
      
      await _videoPlayerController.initialize();
      await _videoPlayerController.setLooping(true); // Helps with live streams on web

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        isLive: true,
        showControls: true, // Enable controls logic
        customControls: LiveControls(
          channel: widget.channel,
          onClose: widget.onClose,
        ),
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load video: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use a transparent Material to allow the overlay effect
    return SizedBox.expand(
      child: Material(
        color: Colors.transparent, 
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main Player Container
            Container(
              constraints: const BoxConstraints(maxWidth: 900), // max-w-4xl
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized)
                        Chewie(controller: _chewieController!)
                      else
                        const CustomSpinner(color: Colors.white),
                      
                      if (_isLoading)
                        const CustomSpinner(color: Colors.white),

                      if (_error != null)
                        Center(child: Text(_error!, style: const TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
