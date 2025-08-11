import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:my_project/colors.dart';
import '../../models/boat.dart';
import '../../services/boat_storage_service.dart';
import 'choose_collection_screen.dart';
import 'package:intl/intl.dart';

class BoatDetailInputScreen extends StatefulWidget {
  final File? boatImage;
  final String? estimatedModel;
  final String? estimatedEngineDetails;
  final String? estimatedYearBuilt;
  final String? estimatedBrand;
  final String? estimatedPrice;
  final String? estimatedImage;
  final String? estimatedCategory;

  const BoatDetailInputScreen({
    super.key,
    this.boatImage,
    this.estimatedModel,
    this.estimatedEngineDetails,
    this.estimatedYearBuilt,
    this.estimatedBrand,
    this.estimatedPrice,
    this.estimatedImage,
    this.estimatedCategory,
  });

  @override
  State<BoatDetailInputScreen> createState() => _BoatDetailInputScreenState();
}

class _BoatDetailInputScreenState extends State<BoatDetailInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _engineDetailsController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _yearBuiltController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with estimated data if available
    _modelController.text = widget.estimatedModel ?? '';
    _engineDetailsController.text = widget.estimatedEngineDetails ?? '';
    _brandController.text = widget.estimatedBrand ?? '';
    _yearBuiltController.text = widget.estimatedYearBuilt?.toString() ?? '';
    _priceController.text = widget.estimatedPrice?.toString() ?? '';
    _categoryController.text = 'motorboat';
  }

  @override
  void dispose() {
    _modelController.dispose();
    _engineDetailsController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _yearBuiltController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF410332),
              Color(0xFF510440),
              Color(0xFF61054E),
              Color(0xFF70055C),
              Color(0xFF800066),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 10, left: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logotwo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.go('/');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Yacht Details',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please fill in the details of your yacht',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (widget.boatImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    widget.boatImage!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _modelController,
                                decoration: const InputDecoration(
                                  labelText: 'Yacht Model',
                                  hintText: 'Enter yacht model',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a boat model';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _engineDetailsController,
                                decoration: const InputDecoration(
                                  labelText: 'Total Horse Power',
                                  hintText: 'Select total horse power',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Select Total Horse Power'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              title: const Text('<400HP'),
                                              onTap: () {
                                                setState(() {
                                                  _engineDetailsController
                                                      .text = '<400HP';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('400-1000HP'),
                                              onTap: () {
                                                setState(() {
                                                  _engineDetailsController
                                                      .text = '400-1000HP';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('>1000HP'),
                                              onTap: () {
                                                setState(() {
                                                  _engineDetailsController
                                                      .text = '>1000HP';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select total horse power';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _brandController,
                                decoration: const InputDecoration(
                                  labelText: 'Brand',
                                  hintText: 'Enter boat brand',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a brand';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Price',
                                  hintText: 'Enter price',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    final number = int.parse(value);
                                    final formatted = NumberFormat.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                      locale: 'en_US',
                                    ).format(number);
                                    _priceController.text = formatted;
                                    _priceController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: _priceController.text.length),
                                    );
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a price';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _yearBuiltController,
                                decoration: const InputDecoration(
                                  labelText: 'Year Built',
                                  hintText: 'e.g. 2024',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the year built';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _categoryController.text.isEmpty
                                    ? null
                                    : _categoryController.text,
                                decoration: const InputDecoration(
                                  labelText: 'Type',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'motorboat',
                                    child: Text('Motorboat'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'sailboat',
                                    child: Text('Sailboat'),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _categoryController.text = newValue ?? '';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Create boat object
                                  final boat = Boat(
                                    model: _modelController.text,
                                    engineDetails:
                                        _engineDetailsController.text,
                                    brand: _brandController.text,
                                    price: _priceController.text,
                                    yearBuilt: _yearBuiltController.text,
                                    category: _categoryController.text,
                                    imageUrl: widget.estimatedImage,
                                    boatImage: widget.boatImage,
                                    horsePower: _engineDetailsController.text,
                                    type: _categoryController.text,
                                  );
                                  print(boat.imageUrl);
                                  print(boat.boatImage);
                                  // Save boat to local storage

                                  // Navigate to collection screen
                                  if (mounted) {
                                    context.go('/choose-collection',
                                        extra: {'boat': boat});
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF410332),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
