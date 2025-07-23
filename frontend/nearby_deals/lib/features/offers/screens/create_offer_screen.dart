import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/animated_button.dart';
import '../models/offer.dart';

class CreateOfferScreen extends StatefulWidget {
  final Offer? offer; // If provided, we're editing an existing offer

  const CreateOfferScreen({
    super.key,
    this.offer,
  });

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _images = [];
  Location? _location;
  String _category = 'Food';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _titleController.text = widget.offer!.title;
      _descriptionController.text = widget.offer!.description;
      _priceController.text = widget.offer!.price.toString();
      _discountController.text = widget.offer!.discount.toString();
      _startDate = widget.offer!.startDate;
      _endDate = widget.offer!.endDate;
      _images.addAll(widget.offer!.images);
      _location = widget.offer!.location;
      _category = widget.offer!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          // TODO: Upload image to server and get URL
          _images.add(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _pickLocation() async {
    // TODO: Implement location picker
    setState(() {
      _location = Location(
        latitude: 37.7749,
        longitude: -122.4194,
      );
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
        return;
      }
      if (_location == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select offer dates')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        // TODO: Implement API call
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.offer == null ? 'Create Offer' : 'Edit Offer'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _buildImagePicker(),
            const SizedBox(height: AppSpacing.xl),
            CustomTextField(
              label: 'Title',
              hint: 'Enter offer title',
              controller: _titleController,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            CustomTextField(
              label: 'Description',
              hint: 'Enter offer description',
              controller: _descriptionController,
              maxLines: 3,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Price',
                    hint: '0.00',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Required';
                      }
                      if (double.tryParse(value!) == null) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomTextField(
                    label: 'Discount %',
                    hint: '0',
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isNotEmpty ?? false) {
                        final discount = double.tryParse(value!);
                        if (discount == null || discount < 0 || discount > 100) {
                          return 'Invalid';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              title: const Text('Offer Dates'),
              subtitle: Text(
                _startDate != null && _endDate != null
                    ? '${_startDate!.toString().split(' ')[0]} to ${_endDate!.toString().split(' ')[0]}'
                    : 'Select date range',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateRange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              title: const Text('Location'),
              subtitle: Text(_location != null
                  ? 'Location selected'
                  : 'Select offer location'),
              trailing: const Icon(Icons.location_on),
              onTap: _pickLocation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            if (_location != null) ...[
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _location!.latitude,
                        _location!.longitude,
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('offer'),
                        position: LatLng(
                          _location!.latitude,
                          _location!.longitude,
                        ),
                      ),
                    },
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl * 2),
            AnimatedButton(
              text: widget.offer == null ? 'Create Offer' : 'Save Changes',
              onPressed: _submitForm,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          ..._images.map((image) => Stack(
            children: [
              Container(
                width: 120,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 12,
                child: GestureDetector(
                  onTap: () => setState(() => _images.remove(image)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )).toList(),
        ],
      ),
    );
  }
}
