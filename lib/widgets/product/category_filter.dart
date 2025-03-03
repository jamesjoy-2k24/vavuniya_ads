// widgets/app/category_filter.dart
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All"
        itemBuilder: (context, index) {
          final category = index == 0 ? "All" : categories[index - 1];
          final isSelected = category == (selectedCategory ?? "All");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) =>
                  onCategorySelected(index == 0 ? null : category),
              selectedColor: AppColors.dark.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? AppColors.dark : Colors.grey[800],
              ),
            ),
          );
        },
      ),
    );
  }
}
