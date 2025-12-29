import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/components/icons.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';

class UniButton extends StatelessWidget {
  const UniButton({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final String location = GoRouterState.of(context).uri.toString();
    
    // Determine current state based on NewsProvider for persistence
    // But fallback to URL if provider is not yet set (initial load) or out of sync
    // Prioritize URL for 'isLive' state, but use Provider for 'National/Regional' toggle state
    
    final bool isLive = location.contains('live');
    final String currentRegion = newsProvider.selectedRegion; // 'NATIONAL' or 'REGIONAL'
    final bool isSliderOnRegional = currentRegion == 'REGIONAL';

    // Calculate paths based on current Toggle State
    final String livePath = isSliderOnRegional ? '/regional-live' : '/live';
    final String newsPath = isSliderOnRegional ? '/' : '/national';

    return Container(
      width: 260, // Increased from 240 to accommodate wider button
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LIVE TV Icon
          InkWell(
            onTap: () {
               if (!isLive) {
                 context.go(livePath, extra: <String, dynamic>{'transition': 'horizontal'});
               }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: LiveIcon(
                width: 70, // Increased width for "LIVE TV"
                height: 30,
                color: isLive && !location.contains('/profile') && !location.contains('/notifications') ? AppTheme.red500 : AppTheme.gray500,
              ),
            ),
          ),

          // Toggle Switch
          Container(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.gray200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                // Animated Slider
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  alignment: isSliderOnRegional ? Alignment.bottomCenter : Alignment.topCenter,
                  child: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppTheme.red500,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Text Labels
                Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (isSliderOnRegional) {
                            // Switching to National
                            newsProvider.setSelectedRegion('NATIONAL');
                            final target = isLive ? '/live' : '/national';
                            context.go(target, extra: <String, dynamic>{'transition': 'vertical'});
                          } else {
                            if (!location.startsWith('/national') && location != '/live') {
                               context.go(isLive ? '/live' : '/national', extra: <String, dynamic>{'transition': 'vertical'});
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            'National',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: !isSliderOnRegional ? Colors.white : AppTheme.gray600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                           if (!isSliderOnRegional) {
                            // Switching to Regional
                            newsProvider.setSelectedRegion('REGIONAL');
                            final target = isLive ? '/regional-live' : '/';
                            context.go(target, extra: <String, dynamic>{'transition': 'vertical'});
                          } else {
                             if (location != '/' && location != '/regional-live') {
                               context.go(isLive ? '/regional-live' : '/', extra: <String, dynamic>{'transition': 'vertical'});
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            'Regional',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSliderOnRegional ? Colors.white : AppTheme.gray600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // NEWS Icon
          InkWell(
            onTap: () {
               if (isLive) {
                 context.go(newsPath, extra: <String, dynamic>{'transition': 'horizontal'});
               }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextNewsIcon(
                width: 60,
                height: 30,
                color: !isLive && !location.contains('/profile') && !location.contains('/notifications') ? AppTheme.red500 : AppTheme.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
