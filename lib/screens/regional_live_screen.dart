import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:samachar_plus_ott_app/components/live_video_player.dart';
import 'package:samachar_plus_ott_app/components/spinner.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class RegionalLiveScreen extends StatefulWidget {
  const RegionalLiveScreen({super.key});

  @override
  State<RegionalLiveScreen> createState() => _RegionalLiveScreenState();
}

class _RegionalLiveScreenState extends State<RegionalLiveScreen> {
  Map<String, List<LiveChannel>> _channelsByState = {};
  bool _isLoading = true;
  LiveChannel? _selectedChannel;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  void _loadChannels() {
    Future.delayed(const Duration(milliseconds: 500), () {
      final regionalChannels = LIVE_CHANNELS.where((c) => c.category == 'REGIONAL').toList();
      
      final Map<String, List<LiveChannel>> groupedByState = {};
      for (var channel in regionalChannels) {
        if (channel.states != null) {
          for (var state in channel.states!) {
            if (!groupedByState.containsKey(state)) {
              groupedByState[state] = [];
            }
            groupedByState[state]!.add(channel);
          }
        }
      }

      if (mounted) {
        setState(() {
          _channelsByState = groupedByState;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChannel != null) {
      return LiveVideoPlayer(
        channel: _selectedChannel!,
        onClose: () => setState(() => _selectedChannel = null),
      );
    }

    if (_isLoading) {
      return const Center(child: Spinner());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Regional Live',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Live news from your state.',
            style: TextStyle(color: AppTheme.gray600),
          ),
          const SizedBox(height: 24),
          if (_channelsByState.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No regional channels available.',
                  style: TextStyle(color: AppTheme.gray500),
                ),
              ),
            )
          else
            ..._channelsByState.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTheme.red500, width: 2)),
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gray800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final channel = entry.value[index];
                      return InkWell(
                        onTap: () => setState(() => _selectedChannel = channel),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: channel.logoUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(color: AppTheme.gray100),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              );
            }),
        ],
      ),
    );
  }
}
