import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:samachar_plus_ott_app/components/live_video_player.dart';
import 'package:samachar_plus_ott_app/widgets/channel_card.dart';

class RegionalLiveScreen extends StatefulWidget {
  const RegionalLiveScreen({super.key});

  @override
  State<RegionalLiveScreen> createState() => _RegionalLiveScreenState();
}

class _RegionalLiveScreenState extends State<RegionalLiveScreen> {
  Map<String, List<LiveChannel>> _channelsByState = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  void _loadChannels() {
    setState(() {
      isLoading = true;
    });

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

    setState(() {
      _channelsByState = groupedByState;
      isLoading = false;
    });
  }

  void _handleChannelTap(LiveChannel channel) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5), // Dimmed background
      barrierDismissible: true, // Allow clicking outside to close
      builder: (context) => LiveVideoPlayer(
        channel: channel,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CustomSpinner());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Regional Live',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Live news from your state.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
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
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFDC2626),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 3;
                      if (constraints.maxWidth > 600) {
                        crossAxisCount = 4;
                      }
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 5;
                      }
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 6;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          return ChannelCard(
                            channel: entry.value[index],
                            onTap: () => _handleChannelTap(entry.value[index]),
                          );
                        },
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
