import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/offer.dart';
import '../../../core/theme.dart';
import '../../../widgets/animated_button.dart';
import 'package:intl/intl.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String offerId;

  const OfferDetailsScreen({
    super.key,
    required this.offerId,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  late PageController _imageController;
  int _currentImageIndex = 0;
  bool _isLoading = true;
  Offer? _offer;

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
    _loadOffer();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _loadOffer() async {
    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock data
      final offer = Offer(
        id: widget.offerId,
        sellerId: '1',
        sellerName: 'John\'s Store',
        title: 'Fresh Vegetables',
        description: 'Fresh organic vegetables from local farm. All vegetables are handpicked and delivered within 24 hours of harvest.',
        price: 20.0,
        discount: 15.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 2)),
        location: Location(latitude: 37.7749, longitude: -122.4194),
        category: 'Groceries',
        createdAt: DateTime.now(),
        images: [
          'https://picsum.photos/800/600',
          'https://picsum.photos/800/601',
          'https://picsum.photos/800/602',
        ],
        distance: 0.5,
      );

      if (mounted) {
        setState(() {
          _offer = offer;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_offer == null) {
      return const Scaffold(
        body: Center(
          child: Text('Offer not found'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _offer!.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_offer!.distance != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                '${_offer!.distance!.toStringAsFixed(1)} km away',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          if (_offer!.discount > 0) ...[
                            Text(
                              '\$${_offer!.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                          ],
                          Text(
                            '\$${_offer!.discountedPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          if (_offer!.discount > 0) ...[
                            const SizedBox(width: AppSpacing.md),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                _offer!.formattedDiscount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Valid until ${DateFormat('MMMM d, y').format(_offer!.endDate)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _offer!.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: SizedBox(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _offer!.location.latitude,
                                _offer!.location.longitude,
                              ),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId(_offer!.id),
                                position: LatLng(
                                  _offer!.location.latitude,
                                  _offer!.location.longitude,
                                ),
                              ),
                            },
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl * 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: AnimatedButton(
                  text: 'Contact Seller',
                  onPressed: () {
                    // TODO: Implement contact functionality
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return AspectRatio(
      aspectRatio: 4/3,
      child: Stack(
        children: [
          PageView.builder(
            controller: _imageController,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemCount: _offer!.images.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: 'offer-${_offer!.id}',
                child: Image.network(
                  _offer!.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
          if (_offer!.images.length > 1)
            Positioned(
              bottom: AppSpacing.md,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _offer!.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
