import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/components/news_card.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class NationalNewsScreen extends StatefulWidget {
  const NationalNewsScreen({super.key});

  @override
  State<NationalNewsScreen> createState() => _NationalNewsScreenState();
}

class _NationalNewsScreenState extends State<NationalNewsScreen> {
  List<NewsArticle> _news = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _news = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CustomSpinner());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'National News',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray800,
            ),
          ),
          const SizedBox(height: 16),
          if (_news.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _news.length,
              itemBuilder: (context, index) {
                return NewsCard(article: _news[index]);
              },
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No national news available right now.',
                  style: TextStyle(color: AppTheme.gray500),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
