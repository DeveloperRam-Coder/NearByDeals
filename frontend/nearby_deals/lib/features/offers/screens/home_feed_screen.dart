import 'package:flutter/material.dart';
import '../models/offer.dart';
import '../widgets/offer_card.dart';
import '../../../core/theme.dart';
import '../../../widgets/animated_button.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;
  List<Offer> _offers = [];
  String _selectedCategory = 'All';
  double _radius = 5.0; // km

  @override
  void initState() {
    super.initState();
    _loadOffers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOffers() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Mock data
      final newOffers = [
        Offer(
          id: '1',
          sellerId: '1',
          sellerName: 'John\'s Store',
          title: 'Fresh Vegetables',
          description: 'Fresh organic vegetables from local farm',
          price: 20.0,
          discount: 15.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 2)),
          location: Location(latitude: 37.7749, longitude: -122.4194),
          category: 'Groceries',
          createdAt: DateTime.now(),
          images: ['https://picsum.photos/200'],
          distance: 0.5,
        ),
        // Add more mock offers...
      ];

      setState(() {
        _offers.addAll(newOffers);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              'Nearby Deals',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showFilterBottomSheet(context),
              ),
            ],
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            _offers.clear();
            await _loadOffers();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      _CategoryChip(
                        label: 'All',
                        isSelected: _selectedCategory == 'All',
                        onTap: () => setState(() => _selectedCategory = 'All'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _CategoryChip(
                        label: 'Food',
                        isSelected: _selectedCategory == 'Food',
                        onTap: () => setState(() => _selectedCategory = 'Food'),
                      ),
                      // Add more categories...
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= _offers.length) {
                        return _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox();
                      }
                      return OfferCard(
                        offer: _offers[index],
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/offer-details',
                          arguments: {'id': _offers[index].id},
                        ),
                      );
                    },
                    childCount: _offers.length + 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-offer'),
        icon: const Icon(Icons.add),
        label: const Text('Create Offer'),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Offers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Distance (km)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: _radius,
                min: 1,
                max: 20,
                divisions: 19,
                label: '${_radius.round()} km',
                onChanged: (value) => setState(() => _radius = value),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedButton(
                text: 'Apply Filters',
                onPressed: () {
                  Navigator.pop(context);
                  _offers.clear();
                  _loadOffers();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
