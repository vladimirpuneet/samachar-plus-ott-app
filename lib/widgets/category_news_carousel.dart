import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';

class CategoryNewsCarousel extends StatelessWidget {
  const CategoryNewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NewsProvider, AuthProvider>(
      builder: (context, newsProvider, authProvider, child) {
        final categories = newsProvider.getCategories();
        
        return SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: _CategoryChip(
                  category: category,
                  isSelected: newsProvider.selectedCategory == category,
                  onTap: () {
                    newsProvider.setCategory(category);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.red[600]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}