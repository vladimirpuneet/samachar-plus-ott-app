import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/widgets/channel_card.dart';
import 'package:samachar_plus_ott_app/widgets/shimmer_loader.dart';
import 'package:samachar_plus_ott_app/components/live_video_player.dart';

class LiveTVScreen extends StatefulWidget {
  const LiveTVScreen({super.key});

  @override
  State<LiveTVScreen> createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  Map<String, List<LiveChannel>> categorizedChannels = {};
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

    // Show ALL channels (both NATIONAL and REGIONAL)
    final allChannels = LIVE_CHANNELS;

    // Group by category first (NATIONAL vs REGIONAL)
    final Map<String, List<LiveChannel>> groupedByCategory = {};
    for (var channel in allChannels) {
      final category = channel.category;
      if (!groupedByCategory.containsKey(category)) {
        groupedByCategory[category] = [];
      }
      groupedByCategory[category]!.add(channel);
    }

    // Further group NATIONAL channels by subCategory
    final Map<String, List<LiveChannel>> finalGrouped = {};
    
    // Process NATIONAL channels
    if (groupedByCategory.containsKey('NATIONAL')) {
      final nationalChannels = groupedByCategory['NATIONAL']!;
      final Map<String, List<LiveChannel>> nationalSubGroups = {};
      
      for (var channel in nationalChannels) {
        final subCat = channel.subCategory ?? 'Other';
        if (!nationalSubGroups.containsKey(subCat)) {
          nationalSubGroups[subCat] = [];
        }
        nationalSubGroups[subCat]!.add(channel);
      }
      
      // Add national subcategories in order
      const subCategoryOrder = ['HINDI', 'ENGLISH', 'BUSINESS'];
      for (var subCategory in subCategoryOrder) {
        if (nationalSubGroups.containsKey(subCategory)) {
          finalGrouped['National - $subCategory'] = nationalSubGroups[subCategory]!;
        }
      }
      
      // Add any remaining national subcategories
      nationalSubGroups.forEach((subCat, channels) {
        if (!subCategoryOrder.contains(subCat)) {
          finalGrouped['National - $subCat'] = channels;
        }
      });
    }

    // Process REGIONAL channels
    if (groupedByCategory.containsKey('REGIONAL')) {
      final regionalChannels = groupedByCategory['REGIONAL']!;
      final Map<String, List<LiveChannel>> regionalSubGroups = {};
      
      for (var channel in regionalChannels) {
        final subCat = channel.subCategory ?? 'Other';
        if (!regionalSubGroups.containsKey(subCat)) {
          regionalSubGroups[subCat] = [];
        }
        regionalSubGroups[subCat]!.add(channel);
      }
      
      // Add regional subcategories
      regionalSubGroups.forEach((subCat, channels) {
        finalGrouped['Regional - $subCat'] = channels;
      });
    }

    setState(() {
      categorizedChannels = finalGrouped;
      isLoading = false;
    });
  }

  void _handleChannelTap(LiveChannel channel) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      barrierDismissible: true,
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
            'Live TV',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Watch all news channels live - National and Regional.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          if (isLoading)
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 600 ? 5 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) => const ShimmerChannelCard(),
                );
              },
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
