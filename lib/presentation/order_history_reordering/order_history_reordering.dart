import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/empty_order_widget.dart';
import './widgets/favorite_order_card_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/order_card_widget.dart';

class OrderHistoryReorderingScreen extends StatefulWidget {
  const OrderHistoryReorderingScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryReorderingScreen> createState() =>
      _OrderHistoryReorderingScreenState();
}

class _OrderHistoryReorderingScreenState
    extends State<OrderHistoryReorderingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Simulate loading data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    if (_searchQuery.isEmpty && _selectedFilter == 'All') {
      return orderHistory;
    }

    return orderHistory.where((order) {
      // Filter by status if needed
      if (_selectedFilter != 'All' && order['status'] != _selectedFilter) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final String restaurantName = order['restaurantName'].toLowerCase();
        final List<String> items = List<String>.from(order['items']);
        final bool matchesRestaurant = restaurantName.contains(_searchQuery);
        final bool matchesItems =
            items.any((item) => item.toLowerCase().contains(_searchQuery));

        return matchesRestaurant || matchesItems;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredOrders = _getFilteredOrders();
    final bool hasOrders = orderHistory.isNotEmpty;
    final bool hasFilteredOrders = filteredOrders.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search orders...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray500,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _updateSearchQuery,
              )
            : const Text('Order History'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: AppTheme.gray700,
            ),
            onPressed: _toggleSearch,
          ),
          if (!_isSearching)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.gray700,
              ),
              onPressed: () {
                // Show filter options
                _showFilterBottomSheet(context);
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Orders'),
            Tab(text: 'Past Orders'),
            Tab(text: 'Ongoing'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : !hasOrders
              ? EmptyOrderWidget(
                  onExplore: () {
                    Navigator.pushNamed(context, '/home-screen');
                  },
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // All Orders Tab
                    _buildOrdersTab(filteredOrders, hasFilteredOrders),

                    // Past Orders Tab
                    _buildOrdersTab(
                      filteredOrders
                          .where((order) =>
                              order['status'] == 'Delivered' ||
                              order['status'] == 'Cancelled')
                          .toList(),
                      hasFilteredOrders,
                    ),

                    // Ongoing Tab
                    _buildOrdersTab(
                      filteredOrders
                          .where((order) =>
                              order['status'] == 'In Progress' ||
                              order['status'] == 'On the way')
                          .toList(),
                      hasFilteredOrders,
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Orders tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home-screen');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.gray500,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.gray500,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: AppTheme.gray500,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.primary,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.gray500,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your orders...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(
      List<Map<String, dynamic>> orders, bool hasFilteredOrders) {
    if (!hasFilteredOrders) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.gray500,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.gray500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedFilter = 'All';
                  _isSearching = false;
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refreshing data
        setState(() {
          _isLoading = true;
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      color: AppTheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favorite Orders Section
              if (favoriteOrders.isNotEmpty && _searchQuery.isEmpty)
                _buildFavoriteOrdersSection(),

              // Filter Chips
              if (_searchQuery.isEmpty) _buildFilterChips(),

              // Order History
              _buildOrderHistory(orders),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favorite Orders',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // View all favorites
                },
                child: Text(
                  'See All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: favoriteOrders.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: FavoriteOrderCardWidget(
                  order: favoriteOrders[index],
                  onTap: () {
                    _showReorderConfirmation(context, favoriteOrders[index]);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            FilterChipWidget(
              label: 'All',
              isSelected: _selectedFilter == 'All',
              onTap: () => _setFilter('All'),
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'Delivered',
              isSelected: _selectedFilter == 'Delivered',
              onTap: () => _setFilter('Delivered'),
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'In Progress',
              isSelected: _selectedFilter == 'In Progress',
              onTap: () => _setFilter('In Progress'),
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'On the way',
              isSelected: _selectedFilter == 'On the way',
              onTap: () => _setFilter('On the way'),
            ),
            const SizedBox(width: 8),
            FilterChipWidget(
              label: 'Cancelled',
              isSelected: _selectedFilter == 'Cancelled',
              onTap: () => _setFilter('Cancelled'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistory(List<Map<String, dynamic>> orders) {
    // Group orders by date
    final Map<String, List<Map<String, dynamic>>> groupedOrders = {};

    for (final order in orders) {
      final String dateGroup = order['dateGroup'];
      if (!groupedOrders.containsKey(dateGroup)) {
        groupedOrders[dateGroup] = [];
      }
      groupedOrders[dateGroup]!.add(order);
    }

    // Sort date groups
    final List<String> sortedDateGroups = groupedOrders.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;
        if (a == 'This Week') return -1;
        if (b == 'This Week') return 1;
        return a.compareTo(b);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedDateGroups.map((dateGroup) {
        final List<Map<String, dynamic>> dateOrders = groupedOrders[dateGroup]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                dateGroup,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dateOrders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: OrderCardWidget(
                    order: dateOrders[index],
                    onTap: () {
                      _showOrderDetails(context, dateOrders[index]);
                    },
                    onReorder: () {
                      _showReorderConfirmation(context, dateOrders[index]);
                    },
                    onViewRestaurant: () {
                      Navigator.pushNamed(context, '/restaurant-details');
                    },
                  ),
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Orders',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.gray700,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Order Status',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterOption('All', setState),
                      _buildFilterOption('Delivered', setState),
                      _buildFilterOption('In Progress', setState),
                      _buildFilterOption('On the way', setState),
                      _buildFilterOption('Cancelled', setState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Time Period',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTimeFilterChip('Last 7 days'),
                      _buildTimeFilterChip('Last 30 days'),
                      _buildTimeFilterChip('Last 3 months'),
                      _buildTimeFilterChip('Last 6 months'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedFilter = 'All';
                            });
                            this.setState(() {
                              _selectedFilter = 'All';
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(String filter, StateSetter setState) {
    final bool isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
        this.setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withAlpha(26) : AppTheme.gray100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.gray200,
            width: 1.5,
          ),
        ),
        child: Text(
          filter,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppTheme.primary : AppTheme.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.gray200,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.gray700,
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.gray300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order ID and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order['id']}',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order['date'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.gray500,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusBadge(order['status']),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Restaurant Info
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CustomImageWidget(
                              imageUrl: order['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['restaurantName'],
                                style:
                                    AppTheme.lightTheme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${order['items'].length} items • \$${order['total']}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/restaurant-details');
                          },
                          child: Text(
                            'View Menu',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Divider(color: AppTheme.gray200, thickness: 1),
                    const SizedBox(height: 16),

                    // Order Items
                    Text(
                      'Order Items',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order['itemDetails'].length,
                      itemBuilder: (context, index) {
                        final item = order['itemDetails'][index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['quantity']}x',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.gray700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (item['options'] != null &&
                                        item['options'].isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          item['options'].join(', '),
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.gray500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${item['price']}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Divider
                    Divider(color: AppTheme.gray200, thickness: 1),
                    const SizedBox(height: 16),

                    // Order Summary
                    Text(
                      'Order Summary',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Subtotal', '\$${order['subtotal']}'),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                        'Delivery Fee', '\$${order['deliveryFee']}'),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Tax', '\$${order['tax']}'),
                    const SizedBox(height: 8),
                    if (order['discount'] != null)
                      _buildSummaryRow('Discount', '-\$${order['discount']}',
                          isDiscount: true),
                    if (order['discount'] != null) const SizedBox(height: 8),
                    Divider(color: AppTheme.gray200, thickness: 1),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Total', '\$${order['total']}',
                        isTotal: true),
                    const SizedBox(height: 24),

                    // Delivery Address
                    Text(
                      'Delivery Address',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.gray700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order['deliveryAddress'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Payment Method
                    Text(
                      'Payment Method',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: order['paymentMethod'].contains('Card')
                              ? 'credit_card'
                              : 'payments',
                          color: AppTheme.gray700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          order['paymentMethod'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        if (order['status'] == 'Delivered')
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Show review dialog
                                Navigator.pop(context);
                                _showReviewDialog(context, order);
                              },
                              icon: CustomIconWidget(
                                iconName: 'star',
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              label: const Text('Leave Review'),
                            ),
                          ),
                        if (order['status'] == 'Delivered')
                          const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Reorder
                              Navigator.pop(context);
                              _showReorderConfirmation(context, order);
                            },
                            icon: CustomIconWidget(
                              iconName: 'replay',
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text('Reorder'),
                          ),
                        ),
                      ],
                    ),
                    if (order['status'] == 'Delivered')
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Report an issue
                              Navigator.pop(context);
                              _showReportIssueDialog(context, order);
                            },
                            icon: CustomIconWidget(
                              iconName: 'report_problem',
                              color: AppTheme.error,
                              size: 20,
                            ),
                            label: Text(
                              'Report an Issue',
                              style: TextStyle(color: AppTheme.error),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.error,
                              side: BorderSide(color: AppTheme.error),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Delivered':
        backgroundColor = AppTheme.success.withAlpha(26);
        textColor = AppTheme.success;
        break;
      case 'In Progress':
        backgroundColor = AppTheme.info.withAlpha(26);
        textColor = AppTheme.info;
        break;
      case 'On the way':
        backgroundColor = AppTheme.delivery.withAlpha(26);
        textColor = AppTheme.delivery;
        break;
      case 'Cancelled':
        backgroundColor = AppTheme.error.withAlpha(26);
        textColor = AppTheme.error;
        break;
      default:
        backgroundColor = AppTheme.gray200;
        textColor = AppTheme.gray700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.gray700,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isDiscount ? AppTheme.success : AppTheme.gray900,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                ),
        ),
      ],
    );
  }

  void _showReorderConfirmation(
      BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reorder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Would you like to reorder from ${order['restaurantName']}?',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Your order:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                order['items'].length > 3 ? 3 : order['items'].length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'circle',
                        color: AppTheme.gray500,
                        size: 8,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order['items'][index],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (order['items'].length > 3)
                Text(
                  '+ ${order['items'].length - 3} more items',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.gray500,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${order['total']}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              child: const Text('Reorder Now'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, Map<String, dynamic> order) {
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate Your Experience'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How was your order from ${order['restaurantName']}?',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: CustomIconWidget(
                          iconName: index < rating ? 'star' : 'star_border',
                          color: index < rating
                              ? AppTheme.warning
                              : AppTheme.gray300,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Share your experience (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for your feedback!'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  child: const Text('Submit Review'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReportIssueDialog(
      BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report an Issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What went wrong with your order?',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _buildIssueOption('Missing items'),
              _buildIssueOption('Food quality issues'),
              _buildIssueOption('Late delivery'),
              _buildIssueOption('Incorrect order'),
              _buildIssueOption('Other issue'),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Provide additional details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Issue reported. We\'ll get back to you soon.'),
                    backgroundColor: AppTheme.info,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIssueOption(String issue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'radio_button_unchecked',
            color: AppTheme.gray700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            issue,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // Mock Data
  final List<Map<String, dynamic>> favoriteOrders = [
    {
      "id": 1,
      "restaurantName": "Pizza Paradise",
      "items": ["Pepperoni Pizza", "Garlic Bread", "Coke"],
      "total": "32.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "frequency": "Ordered 5 times",
    },
    {
      "id": 2,
      "restaurantName": "Burger Bliss",
      "items": ["Double Cheeseburger", "Fries", "Milkshake"],
      "total": "28.50",
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "frequency": "Ordered 3 times",
    },
    {
      "id": 3,
      "restaurantName": "Taco Town",
      "items": ["Taco Combo", "Nachos", "Guacamole"],
      "total": "24.75",
      "imageUrl":
          "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "frequency": "Ordered 2 times",
    },
  ];

  final List<Map<String, dynamic>> orderHistory = [
    {
      "id": "ORD8765",
      "restaurantName": "Pizza Paradise",
      "items": ["Pepperoni Pizza", "Garlic Bread", "Coke"],
      "itemDetails": [
        {
          "name": "Pepperoni Pizza",
          "quantity": 1,
          "price": "18.99",
          "options": ["Extra Cheese", "Thin Crust"]
        },
        {"name": "Garlic Bread", "quantity": 1, "price": "5.99", "options": []},
        {
          "name": "Coke",
          "quantity": 2,
          "price": "3.99",
          "options": ["Large"]
        }
      ],
      "date": "Oct 15, 2023 • 7:30 PM",
      "dateGroup": "Today",
      "status": "Delivered",
      "total": "32.96",
      "subtotal": "28.97",
      "deliveryFee": "2.99",
      "tax": "1.00",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "30 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
    {
      "id": "ORD8764",
      "restaurantName": "Sushi Sensation",
      "items": ["California Roll", "Miso Soup", "Edamame", "Green Tea"],
      "itemDetails": [
        {
          "name": "California Roll",
          "quantity": 2,
          "price": "12.99",
          "options": []
        },
        {"name": "Miso Soup", "quantity": 1, "price": "3.99", "options": []},
        {
          "name": "Edamame",
          "quantity": 1,
          "price": "4.99",
          "options": ["Spicy"]
        },
        {"name": "Green Tea", "quantity": 2, "price": "2.99", "options": []}
      ],
      "date": "Oct 15, 2023 • 1:15 PM",
      "dateGroup": "Today",
      "status": "Delivered",
      "total": "40.94",
      "subtotal": "35.95",
      "deliveryFee": "3.99",
      "tax": "1.00",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "45 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "PayPal",
    },
    {
      "id": "ORD8763",
      "restaurantName": "Burger Bliss",
      "items": ["Double Cheeseburger", "Fries", "Chocolate Shake"],
      "itemDetails": [
        {
          "name": "Double Cheeseburger",
          "quantity": 1,
          "price": "12.99",
          "options": ["No Onions", "Extra Pickles"]
        },
        {
          "name": "Fries",
          "quantity": 1,
          "price": "4.99",
          "options": ["Large"]
        },
        {
          "name": "Chocolate Shake",
          "quantity": 1,
          "price": "5.99",
          "options": []
        }
      ],
      "date": "Oct 14, 2023 • 8:20 PM",
      "dateGroup": "Yesterday",
      "status": "Delivered",
      "total": "26.97",
      "subtotal": "23.97",
      "deliveryFee": "1.99",
      "tax": "1.01",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "25 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
    {
      "id": "ORD8762",
      "restaurantName": "Taco Town",
      "items": ["Taco Combo", "Nachos", "Guacamole", "Mexican Soda"],
      "itemDetails": [
        {
          "name": "Taco Combo",
          "quantity": 1,
          "price": "14.99",
          "options": ["Chicken", "Corn Tortilla"]
        },
        {
          "name": "Nachos",
          "quantity": 1,
          "price": "8.99",
          "options": ["Extra Cheese"]
        },
        {"name": "Guacamole", "quantity": 1, "price": "3.99", "options": []},
        {"name": "Mexican Soda", "quantity": 1, "price": "2.99", "options": []}
      ],
      "date": "Oct 12, 2023 • 7:45 PM",
      "dateGroup": "This Week",
      "status": "Delivered",
      "total": "33.96",
      "subtotal": "30.96",
      "deliveryFee": "1.99",
      "tax": "1.01",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "35 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Apple Pay",
    },
    {
      "id": "ORD8761",
      "restaurantName": "Pasta Palace",
      "items": ["Fettuccine Alfredo", "Garlic Bread", "Tiramisu"],
      "itemDetails": [
        {
          "name": "Fettuccine Alfredo",
          "quantity": 1,
          "price": "16.99",
          "options": ["Add Chicken"]
        },
        {"name": "Garlic Bread", "quantity": 1, "price": "4.99", "options": []},
        {"name": "Tiramisu", "quantity": 1, "price": "6.99", "options": []}
      ],
      "date": "Oct 10, 2023 • 6:30 PM",
      "dateGroup": "This Week",
      "status": "Delivered",
      "total": "31.97",
      "subtotal": "28.97",
      "deliveryFee": "1.99",
      "tax": "1.01",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "40 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
    {
      "id": "ORD8760",
      "restaurantName": "Salad Spot",
      "items": ["Caesar Salad", "Fruit Smoothie"],
      "itemDetails": [
        {
          "name": "Caesar Salad",
          "quantity": 1,
          "price": "12.99",
          "options": ["Add Chicken", "No Croutons"]
        },
        {
          "name": "Fruit Smoothie",
          "quantity": 1,
          "price": "6.99",
          "options": ["Strawberry Banana"]
        }
      ],
      "date": "Oct 5, 2023 • 12:15 PM",
      "dateGroup": "Last Month",
      "status": "Delivered",
      "total": "22.98",
      "subtotal": "19.98",
      "deliveryFee": "1.99",
      "tax": "1.01",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "20 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
    {
      "id": "ORD8759",
      "restaurantName": "Pizza Paradise",
      "items": ["Margherita Pizza", "Caesar Salad", "Lemonade"],
      "itemDetails": [
        {
          "name": "Margherita Pizza",
          "quantity": 1,
          "price": "16.99",
          "options": ["Large"]
        },
        {"name": "Caesar Salad", "quantity": 1, "price": "8.99", "options": []},
        {"name": "Lemonade", "quantity": 2, "price": "3.99", "options": []}
      ],
      "date": "Oct 15, 2023 • 8:30 PM",
      "dateGroup": "Today",
      "status": "In Progress",
      "total": "33.96",
      "subtotal": "29.97",
      "deliveryFee": "2.99",
      "tax": "1.00",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "Preparing",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
    {
      "id": "ORD8758",
      "restaurantName": "Burger Bliss",
      "items": ["Veggie Burger", "Sweet Potato Fries", "Iced Tea"],
      "itemDetails": [
        {
          "name": "Veggie Burger",
          "quantity": 1,
          "price": "11.99",
          "options": ["Add Avocado"]
        },
        {
          "name": "Sweet Potato Fries",
          "quantity": 1,
          "price": "5.99",
          "options": []
        },
        {"name": "Iced Tea", "quantity": 1, "price": "2.99", "options": []}
      ],
      "date": "Oct 15, 2023 • 7:45 PM",
      "dateGroup": "Today",
      "status": "On the way",
      "total": "23.97",
      "subtotal": "20.97",
      "deliveryFee": "1.99",
      "tax": "1.01",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "Arriving in 10 min",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
    {
      "id": "ORD8757",
      "restaurantName": "Sushi Sensation",
      "items": ["Dragon Roll", "Tempura", "Sake"],
      "itemDetails": [
        {"name": "Dragon Roll", "quantity": 1, "price": "15.99", "options": []},
        {
          "name": "Tempura",
          "quantity": 1,
          "price": "9.99",
          "options": ["Vegetable"]
        },
        {
          "name": "Sake",
          "quantity": 1,
          "price": "8.99",
          "options": ["Small"]
        }
      ],
      "date": "Oct 8, 2023 • 8:15 PM",
      "dateGroup": "This Week",
      "status": "Cancelled",
      "total": "37.97",
      "subtotal": "34.97",
      "deliveryFee": "1.99",
      "tax": "1.01",
      "discount": null,
      "imageUrl":
          "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "deliveryTime": "Cancelled",
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4242",
    },
  ];
}
