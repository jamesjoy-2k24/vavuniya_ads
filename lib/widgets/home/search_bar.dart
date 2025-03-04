import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isTyping = false;
  final List<String> _recentSearches = [
    "Laptop",
    "Phone",
    "Car"
  ]; // Example recent searches
  final List<String> _suggestions = [
    "Laptop Stand",
    "Phone Charger",
    "Car Accessories"
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isTyping = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        if (!_recentSearches.contains(query)) {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        }
      });
      final HomeController controller = Get.find<HomeController>();
      controller.searchAds(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isTyping = false;
    });
    _performSearch('');
  }

  List<String> _getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _suggestions
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Back icon when typing
              if (_isTyping)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.dark),
                  onPressed: _clearSearch,
                ),

              // Search Bar
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search in Vavuniya Ads...',
                    hintStyle:
                        AppTypography.caption.copyWith(color: AppColors.grey),
                    prefixIcon: const Icon(Icons.search, color: AppColors.dark),
                    suffixIcon: _isTyping
                        ? IconButton(
                            icon:
                                const Icon(Icons.clear, color: AppColors.dark),
                            onPressed: _clearSearch,
                          )
                        : IconButton(
                            icon: const Icon(Icons.filter_list,
                                color: AppColors.dark),
                            onPressed: () {
                              Get.snackbar(
                                "Filter",
                                "Filter options coming soon!",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppColors.dark,
                                colorText: Colors.white,
                              );
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  style:
                      AppTypography.body.copyWith(color: AppColors.textPrimary),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _performSearch,
                ),
              ),

              // Search button when typing
              if (_isTyping)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _performSearch(_searchController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),

          // Recent searches and suggestions below the bar
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_recentSearches.isNotEmpty) ...[
                    const Text("Recent Searches",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8.0,
                      children: _recentSearches
                          .map((search) => GestureDetector(
                                onTap: () {
                                  _searchController.text = search;
                                  _performSearch(search);
                                },
                                child: Chip(
                                  label: Text(search),
                                  backgroundColor: AppColors.lightGrey,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // get Suggestions
                  if (_getSuggestions(_searchController.text).isNotEmpty) ...[
                    const Text("Suggestions",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8.0,
                      children: _getSuggestions(_searchController.text)
                          .map((suggestion) => GestureDetector(
                                onTap: () {
                                  _searchController.text = suggestion;
                                  _performSearch(suggestion);
                                },
                                child: Chip(
                                  label: Text(suggestion),
                                  backgroundColor: AppColors.lightGrey,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
