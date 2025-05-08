import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/cuisine_filter_widget.dart';
import './widgets/dietary_filter_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/price_range_filter_widget.dart';
import './widgets/restaurant_grid_item_widget.dart';
import './widgets/restaurant_list_item_widget.dart';
import './widgets/search_suggestion_widget.dart';

class SearchFiltersScreen extends StatefulWidget {
  const SearchFiltersScreen({Key? key}) : super(key: key);

  @override
  State<SearchFiltersScreen> createState() => _SearchFiltersScreenState();
}

class _SearchFiltersScreenState extends State<SearchFiltersScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearching = false;
  bool _isLoading = false;
  bool _isGridView = true;
  bool _showFilters = false;
  String _sortOption = 'Relevance';

  List<String> _activeFilters = [];
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [];
  List<String> _searchSuggestions = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize with mock data
    _recentSearches = ['Pizza', 'Burger', 'Sushi', 'Italian'];

    // Load initial results
    _loadInitialResults();

    // Setup scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);

    // Setup search focus listener
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });

    // Setup search text listener
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreResults();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
      return;
    }

    // Generate suggestions based on query
    setState(() {
      _searchSuggestions = [
        '$query restaurants',
        '$query near me',
        '$query delivery',
        'best $query',
      ];
    });
  }

  void _loadInitialResults() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _searchResults = restaurants;
        _isLoading = false;
      });
    });
  }

  void _loadMoreResults() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call for more results
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _searchResults.addAll(moreRestaurants);
        _isLoading = false;
      });
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = false;
      _isLoading = true;
      _searchFocusNode.unfocus();
    });

    // Add to recent searches if not already there
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }

    // Simulate search API call
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        // Filter results based on query
        _searchResults = restaurants
            .where((restaurant) =>
                restaurant['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                restaurant['cuisine']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        _isLoading = false;
      });
    });
  }

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  void _addFilter(String filter) {
    if (!_activeFilters.contains(filter)) {
      setState(() {
        _activeFilters.add(filter);
        _applyFilters();
      });
    }
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
      _applyFilters();
    });
  }

  void _clearFilters() {
    setState(() {
      _activeFilters.clear();
      _loadInitialResults();
    });
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    // Simulate filter API call
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (_activeFilters.isEmpty) {
          _searchResults = restaurants;
        } else {
          _searchResults = restaurants.where((restaurant) {
            // Check if restaurant matches any active filter
            for (var filter in _activeFilters) {
              if (restaurant['cuisine'].toString().contains(filter) ||
                  restaurant['dietaryOptions']?.contains(filter) == true ||
                  (filter == 'Free Delivery' &&
                      restaurant['deliveryFee'] == '\$0.00') ||
                  (filter == '4.5+' && restaurant['rating'] >= 4.5) ||
                  (filter.contains('\$') &&
                      restaurant['priceRange'] == filter)) {
                return true;
              }
            }
            return false;
          }).toList();
        }
        _isLoading = false;
      });
    });
  }

  void _changeSortOption(String option) {
    setState(() {
      _sortOption = option;

      // Sort results based on selected option
      switch (option) {
        case 'Rating':
          _searchResults.sort((a, b) => b['rating'].compareTo(a['rating']));
          break;
        case 'Delivery Time':
          _searchResults.sort((a, b) {
            final aTime = int.parse(a['deliveryTime'].toString().split('-')[0]);
            final bTime = int.parse(b['deliveryTime'].toString().split('-')[0]);
            return aTime.compareTo(bTime);
          });
          break;
        case 'Price: Low to High':
          _searchResults.sort((a, b) {
            final aPrice = a['priceRange'].toString().length;
            final bPrice = b['priceRange'].toString().length;
            return aPrice.compareTo(bPrice);
          });
          break;
        case 'Price: High to Low':
          _searchResults.sort((a, b) {
            final aPrice = a['priceRange'].toString().length;
            final bPrice = b['priceRange'].toString().length;
            return bPrice.compareTo(aPrice);
          });
          break;
        case 'Relevance':
        default:
          // Default sorting (by promoted and then rating)
          _searchResults.sort((a, b) {
            if (a['isPromoted'] == b['isPromoted']) {
              return b['rating'].compareTo(a['rating']);
            }
            return a['isPromoted'] ? -1 : 1;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.gray700,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home-screen');
          },
        ),
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isGridView ? 'view_list' : 'grid_view',
              color: AppTheme.gray700,
            ),
            onPressed: _toggleViewMode,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'tune',
              color: _activeFilters.isNotEmpty
                  ? AppTheme.primary
                  : AppTheme.gray700,
            ),
            onPressed: _toggleFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters
          if (_activeFilters.isNotEmpty) _buildActiveFilters(),

          // Sort Options
          _buildSortOptions(),

          // Main Content
          Expanded(
            child: _isSearching
                ? _buildSearchSuggestions()
                : _searchResults.isEmpty && !_isLoading
                    ? _buildEmptyState()
                    : _buildSearchResults(),
          ),
        ],
      ),
      // Filter Bottom Sheet
      bottomSheet: _showFilters ? _buildFilterBottomSheet() : null,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search for restaurants or dishes',
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.gray500,
          ),
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.gray500,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.gray500,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : IconButton(
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.gray500,
                  ),
                  onPressed: () {
                    // Voice search functionality
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray200,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _activeFilters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChipWidget(
                    label: filter,
                    onRemove: () => _removeFilter(filter),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray200,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _searchResults.isEmpty && !_isLoading
                ? 'No results found'
                : '${_searchResults.length} results found',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          DropdownButton<String>(
            value: _sortOption,
            icon: CustomIconWidget(
              iconName: 'arrow_drop_down',
              color: AppTheme.gray700,
            ),
            underline: const SizedBox(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray700,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _changeSortOption(newValue);
              }
            },
            items: <String>[
              'Relevance',
              'Rating',
              'Delivery Time',
              'Price: Low to High',
              'Price: High to Low',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: value == 'Rating'
                          ? 'star'
                          : value == 'Delivery Time'
                              ? 'access_time'
                              : value.contains('Price')
                                  ? 'attach_money'
                                  : 'sort',
                      color: AppTheme.gray700,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recent Searches
        if (_recentSearches.isNotEmpty && _searchController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _recentSearches.clear();
                        });
                      },
                      child: Text(
                        'Clear',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _recentSearches.map((search) {
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = search;
                        _performSearch(search);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.gray100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'history',
                              color: AppTheme.gray500,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              search,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Search Suggestions
        if (_searchSuggestions.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _searchSuggestions.length,
              itemBuilder: (context, index) {
                return SearchSuggestionWidget(
                  suggestion: _searchSuggestions[index],
                  onTap: () {
                    _searchController.text = _searchSuggestions[index];
                    _performSearch(_searchSuggestions[index]);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Stack(
      children: [
        // Results
        _isGridView
            ? GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return RestaurantGridItemWidget(
                    restaurant: _searchResults[index],
                    onTap: () {
                      Navigator.pushNamed(context, '/restaurant-details');
                    },
                  );
                },
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RestaurantListItemWidget(
                      restaurant: _searchResults[index],
                      onTap: () {
                        Navigator.pushNamed(context, '/restaurant-details');
                      },
                    ),
                  );
                },
              ),

        // Loading Indicator
        if (_isLoading)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.gray300,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: AppTheme.lightTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any restaurants matching your search or filters. Try adjusting your filters or try a different search term.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _clearFilters();
                _searchController.clear();
                _loadInitialResults();
              },
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.white,
              ),
              label: const Text('Reset Search & Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      height: 70.h,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.gray700,
                ),
                onPressed: _toggleFilters,
              ),
            ],
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Categories'),
              Tab(text: 'Dietary'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Categories Tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Cuisine Types
                      Text(
                        'Cuisine Types',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      CuisineFilterWidget(
                        cuisines: cuisineTypes,
                        activeFilters: _activeFilters,
                        onFilterSelected: _addFilter,
                        onFilterRemoved: _removeFilter,
                      ),

                      const SizedBox(height: 24),

                      // Price Range
                      Text(
                        'Price Range',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      PriceRangeFilterWidget(
                        activeFilters: _activeFilters,
                        onFilterSelected: _addFilter,
                        onFilterRemoved: _removeFilter,
                      ),

                      const SizedBox(height: 24),

                      // Delivery Time
                      Text(
                        'Delivery Time',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterOption('Under 15 min',
                              _activeFilters.contains('Under 15 min')),
                          _buildFilterOption('Under 30 min',
                              _activeFilters.contains('Under 30 min')),
                          _buildFilterOption('Under 45 min',
                              _activeFilters.contains('Under 45 min')),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Rating
                      Text(
                        'Rating',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterOption(
                              '4.5+', _activeFilters.contains('4.5+')),
                          _buildFilterOption(
                              '4.0+', _activeFilters.contains('4.0+')),
                          _buildFilterOption(
                              '3.5+', _activeFilters.contains('3.5+')),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Offers
                      Text(
                        'Offers',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterOption('Free Delivery',
                              _activeFilters.contains('Free Delivery')),
                          _buildFilterOption('Discounts',
                              _activeFilters.contains('Discounts')),
                          _buildFilterOption('Special Offers',
                              _activeFilters.contains('Special Offers')),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dietary Tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Dietary Restrictions
                      Text(
                        'Dietary Restrictions',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DietaryFilterWidget(
                        dietaryOptions: dietaryOptions,
                        activeFilters: _activeFilters,
                        onFilterSelected: _addFilter,
                        onFilterRemoved: _removeFilter,
                      ),

                      const SizedBox(height: 24),

                      // Allergens
                      Text(
                        'Allergen Free',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterOption('Gluten-Free',
                              _activeFilters.contains('Gluten-Free')),
                          _buildFilterOption('Dairy-Free',
                              _activeFilters.contains('Dairy-Free')),
                          _buildFilterOption(
                              'Nut-Free', _activeFilters.contains('Nut-Free')),
                          _buildFilterOption(
                              'Egg-Free', _activeFilters.contains('Egg-Free')),
                          _buildFilterOption(
                              'Soy-Free', _activeFilters.contains('Soy-Free')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _toggleFilters();
                _applyFilters();
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          _removeFilter(label);
        } else {
          _addFilter(label);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withAlpha(26) : AppTheme.gray100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.gray200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppTheme.primary : AppTheme.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Mock Data
  final List<Map<String, dynamic>> restaurants = [
    {
      "id": 1,
      "name": "Pizza Paradise",
      "cuisine": "Italian, Pizza",
      "rating": 4.8,
      "deliveryTime": "15-25 min",
      "deliveryFee": "\$1.99",
      "distance": "0.8 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
      "dietaryOptions": ["Vegetarian Options"],
    },
    {
      "id": 2,
      "name": "Burger Bliss",
      "cuisine": "American, Burgers",
      "rating": 4.5,
      "deliveryTime": "20-30 min",
      "deliveryFee": "\$2.49",
      "distance": "1.2 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": false,
      "dietaryOptions": ["Gluten-Free Options"],
    },
    {
      "id": 3,
      "name": "Sushi Sensation",
      "cuisine": "Japanese, Sushi",
      "rating": 4.7,
      "deliveryTime": "25-35 min",
      "deliveryFee": "\$3.99",
      "distance": "1.5 mi",
      "priceRange": "\$\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
      "dietaryOptions": ["Vegetarian Options", "Gluten-Free Options"],
    },
    {
      "id": 4,
      "name": "Taco Time",
      "cuisine": "Mexican, Tacos",
      "rating": 4.3,
      "deliveryTime": "15-25 min",
      "deliveryFee": "\$1.49",
      "distance": "0.5 mi",
      "priceRange": "\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": false,
      "dietaryOptions": ["Vegan Options"],
    },
    {
      "id": 5,
      "name": "Pasta Palace",
      "cuisine": "Italian, Pasta",
      "rating": 4.6,
      "deliveryTime": "25-35 min",
      "deliveryFee": "\$2.99",
      "distance": "1.8 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": false,
      "dietaryOptions": ["Vegetarian Options"],
    },
    {
      "id": 6,
      "name": "Salad Spot",
      "cuisine": "Healthy, Salads",
      "rating": 4.4,
      "deliveryTime": "15-25 min",
      "deliveryFee": "\$0.00",
      "distance": "0.7 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
      "dietaryOptions": ["Vegan Options", "Gluten-Free Options"],
    },
  ];

  final List<Map<String, dynamic>> moreRestaurants = [
    {
      "id": 7,
      "name": "Thai Delight",
      "cuisine": "Thai, Asian",
      "rating": 4.2,
      "deliveryTime": "30-40 min",
      "deliveryFee": "\$2.99",
      "distance": "2.1 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1559847844-5315695dadae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": false,
      "dietaryOptions": ["Vegetarian Options"],
    },
    {
      "id": 8,
      "name": "BBQ Barn",
      "cuisine": "BBQ, American",
      "rating": 4.7,
      "deliveryTime": "35-45 min",
      "deliveryFee": "\$3.49",
      "distance": "2.5 mi",
      "priceRange": "\$\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
      "dietaryOptions": [],
    },
    {
      "id": 9,
      "name": "Pho Fusion",
      "cuisine": "Vietnamese, Asian",
      "rating": 4.5,
      "deliveryTime": "25-35 min",
      "deliveryFee": "\$2.49",
      "distance": "1.7 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": false,
      "dietaryOptions": ["Gluten-Free Options"],
    },
    {
      "id": 10,
      "name": "Mediterranean Meze",
      "cuisine": "Mediterranean, Greek",
      "rating": 4.6,
      "deliveryTime": "30-40 min",
      "deliveryFee": "\$0.00",
      "distance": "1.9 mi",
      "priceRange": "\$\$",
      "imageUrl":
          "https://images.unsplash.com/photo-1544250634-1f4a34d879e5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
      "dietaryOptions": ["Vegetarian Options", "Vegan Options"],
    },
  ];

  final List<String> cuisineTypes = [
    "Italian",
    "American",
    "Japanese",
    "Mexican",
    "Chinese",
    "Thai",
    "Indian",
    "Mediterranean",
    "Vietnamese",
    "Korean",
    "French",
    "Greek",
    "Spanish",
    "Middle Eastern",
    "Caribbean",
  ];

  final List<String> dietaryOptions = [
    "Vegetarian Options",
    "Vegan Options",
    "Gluten-Free Options",
    "Dairy-Free Options",
    "Keto-Friendly",
    "Paleo-Friendly",
    "Low-Carb Options",
    "Organic",
    "Halal",
    "Kosher",
  ];
}
