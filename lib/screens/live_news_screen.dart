import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:samachar_plus_ott_app/components/live_video_player.dart';
import 'package:samachar_plus_ott_app/components/spinner.dart';
import 'package:samachar_plus_ott_app/constants.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class LiveNewsScreen extends StatefulWidget {
  const LiveNewsScreen({super.key});

  @override
  State<LiveNewsScreen> createState() => _LiveNewsScreenState();
}

class _LiveNewsScreenState extends State<LiveNewsScreen> {
  Map<String, List<LiveChannel>> _categorizedChannels = {};
  bool _isLoading = true;
  LiveChannel? _selectedChannel;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  void _loadChannels() {
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      final nationalChannels = LIVE_CHANNELS.where((c) => c.category == 'NATIONAL').toList();
      
      final Map<String, List<LiveChannel>> grouped = {};
      for (var channel in nationalChannels) {
        final subCat = channel.subCategory ?? 'Other';
        if (!grouped.containsKey(subCat)) {
          grouped[subCat] = [];
        }
        grouped[subCat]!.add(channel);
      }

      // Sort keys: HINDI, ENGLISH, BUSINESS
      final sortedKeys = ['HINDI', 'ENGLISH', 'BUSINESS'];
      final Map<String, List<LiveChannel>> orderedGrouped = {};
      
      for (var key in sortedKeys) {
        if (grouped.containsKey(key)) {
          orderedGrouped[key] = grouped[key]!;
        }
      }
      // Add any others
      grouped.forEach((key, value) {
        if (!sortedKeys.contains(key)) {
          orderedGrouped[key] = value;
        }
      });

      if (mounted) {
        setState(() {
          _categorizedChannels = orderedGrouped;
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
            'Live News',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Watch national news channels live.',
            style: TextStyle(color: AppTheme.gray600),
          ),
          const SizedBox(height: 24),
          ..._categorizedChannels.entries.map((entry) {
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
                    crossAxisCount: 3, // Mobile usually 3
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
                          fit: BoxFit.contain, // Logos usually need contain
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
