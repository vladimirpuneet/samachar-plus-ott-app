import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/components/icons.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class UniButton extends StatelessWidget {
  const UniButton({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final bool isLive = location.contains('live');
    final bool isRegionalActive = location == '/' || location == '/regional-live';
    final bool isNationalActive = location == '/national' || location == '/live';

    // Determine preference based on active route
    String preference = 'national';
    if (isRegionalActive) {
      preference = 'regional';
    } else if (isNationalActive) {
      preference = 'national';
    }

    final bool isSliderOnRegional = preference == 'regional';

    final String livePath = preference == 'regional' ? '/regional-live' : '/live';
    final String newsPath = preference == 'regional' ? '/' : '/national';

    return Container(
      width: 240, // Approximate width
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Live Icon
          InkWell(
            onTap: () => context.go(livePath),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LiveIcon(
                width: 50,
                height: 30,
                color: isLive ? AppTheme.red500 : AppTheme.gray500,
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
                        onTap: () => context.go(isLive ? '/live' : '/national'),
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
                        onTap: () => context.go(isLive ? '/regional-live' : '/'),
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

          // News Icon
          InkWell(
            onTap: () => context.go(newsPath),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextNewsIcon(
                width: 50,
                height: 30,
                color: !isLive ? AppTheme.red500 : AppTheme.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
