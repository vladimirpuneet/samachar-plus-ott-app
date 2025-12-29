import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/widgets/channel_card.dart';
import 'package:samachar_plus_ott_app/components/live_video_player.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';

class LiveNewsScreen extends StatefulWidget {
  const LiveNewsScreen({super.key});

  @override
  State<LiveNewsScreen> createState() => _LiveNewsScreenState();
}

class _LiveNewsScreenState extends State<LiveNewsScreen> {
  Map<String, List<LiveChannel>> categorizedChannels = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).setSelectedRegion('NATIONAL');
    });
    _loadChannels();
  }

  void _loadChannels() {
    setState(() {
      isLoading = true;
    });

    // Filter for NATIONAL category channels only
    final nationalChannels = LIVE_CHANNELS
        .where((channel) => channel.category == 'NATIONAL')
        .toList();

    // Group by subCategory
    final Map<String, List<LiveChannel>> grouped = {};
    for (var channel in nationalChannels) {
      final subCat = channel.subCategory ?? 'Other';
      if (!grouped.containsKey(subCat)) {
        grouped[subCat] = [];
      }
      grouped[subCat]!.add(channel);
    }

    // Order by subCategory
    const subCategoryOrder = ['HINDI', 'ENGLISH', 'BUSINESS'];
    final Map<String, List<LiveChannel>> orderedGrouped = {};
    for (var subCategory in subCategoryOrder) {
      if (grouped.containsKey(subCategory)) {
        orderedGrouped[subCategory] = grouped[subCategory]!;
      }
    }

    setState(() {
      categorizedChannels = orderedGrouped;
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live News',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Watch national news channels live.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ...categorizedChannels.entries.map((entry) {
              return _buildCategorySection(entry.key, entry.value);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<LiveChannel> channels) {
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
            category,
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
              itemCount: channels.length,
              itemBuilder: (context, index) {
                return ChannelCard(
                  channel: channels[index],
                  onTap: () => _handleChannelTap(channels[index]),
                );
              },
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
