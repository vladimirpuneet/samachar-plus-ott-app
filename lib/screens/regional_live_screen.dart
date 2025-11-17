import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/header.dart';
import '../widgets/live_channel_card.dart';
import '../widgets/live_video_player.dart';
import '../models/news_model.dart';

class RegionalLiveScreen extends StatefulWidget {
  const RegionalLiveScreen({super.key});

  @override
  State<RegionalLiveScreen> createState() => _RegionalLiveScreenState();
}

class _RegionalLiveScreenState extends State<RegionalLiveScreen> {
  LiveChannel? _selectedChannel;
  bool _isLoading = true;
  String? _error;
  Map<String, List<LiveChannel>> _categorizedChannels = {};

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  void _loadChannels() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final channels = newsProvider.liveChannels;
      
      // Filter regional channels
      final regionalChannels = channels.where((c) => c.category == 'REGIONAL').toList();
      
      // Group by subCategory (states)
      final Map<String, List<LiveChannel>> grouped = {};
      for (final channel in regionalChannels) {
        final subCategory = (channel as dynamic).subCategory ?? 'OTHER';
        if (subCategory is List) {
          for (final state in subCategory) {
            if (!grouped.containsKey(state)) {
              grouped[state] = [];
            }
            grouped[state]!.add(channel);
          }
        } else {
          if (!grouped.containsKey(subCategory)) {
            grouped[subCategory] = [];
          }
          grouped[subCategory]!.add(channel);
        }
      }
      
      setState(() {
        _categorizedChannels = grouped;
        _isLoading = false;
      });

    } catch (err) {
      setState(() {
        _error = "Failed to load regional live channels.";
        _isLoading = false;
      });
    }
  }

  void _handleSelectChannel(LiveChannel channel) {
    setState(() {
      _selectedChannel = channel;
    });
  }

  void _handleClosePlayer() {
    setState(() {
      _selectedChannel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      
      // Video player overlay
      if (_selectedChannel != null) ...[
        Positioned.fill(
          child: LiveVideoPlayer(
            channel: _selectedChannel!,
            onClose: _handleClosePlayer,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadChannels,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Regional Live News',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Watch regional news channels live.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: _categorizedChannels.isEmpty
              ? const Center(
                  child: Text(
                    'No regional live channels available',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: _categorizedChannels.entries.map((entry) {
                      return _buildCategorySection(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String state, List<LiveChannel> channels) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.red[600]!,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              state,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Grid view for channels
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return LiveChannelCard(
                channel: channel,
                onSelect: () => _handleSelectChannel(channel),
              );
            },
          ),
        ],
      ),
    );
  }
}