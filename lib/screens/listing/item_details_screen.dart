import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard_screen.dart';
import 'ready_to_publish_screen.dart';
import 'dart:io';
import 'choose_collection_screen.dart';
import 'package:my_project/colors.dart';

class ItemDetailsScreen extends StatefulWidget {
  final File? itemImage;
  final String? estimatedTitle;
  final String? estimatedDescription;
  final String? estimatedYear;
  final String? estimatedCreator;
  final String? estimatedPrice;
  final String? estimatedImage;
  final String? estimatedCategory;
  final String? estimatedSize;
  final String? estimatedBirthCountry;
  final String? estimatedAuctionHouseResult;
  final String? estimatedTurnoverEvolution;
  final String? estimatedWorldRanking;
  final String? estimatedYearBirth;
  final String? estimatedSubType;
  const ItemDetailsScreen({
    super.key,
    this.itemImage,
    this.estimatedTitle,
    this.estimatedDescription,
    this.estimatedYear,
    this.estimatedCreator,
    this.estimatedPrice,
    this.estimatedImage,
    this.estimatedCategory,
    this.estimatedSize,
    this.estimatedBirthCountry,
    this.estimatedAuctionHouseResult,
    this.estimatedTurnoverEvolution,
    this.estimatedWorldRanking,
    this.estimatedYearBirth,
    this.estimatedSubType,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _creatorController = TextEditingController();
  final _priceController = TextEditingController();
  final _yearController = TextEditingController();
  final _aiQuotePriceController = TextEditingController();
  final _auctionHousePriceController = TextEditingController();
  final _birthCountryController = TextEditingController();
  final _sizeController = TextEditingController();
  final _yearBirthController = TextEditingController();
  final _auctionHouseResultController = TextEditingController();
  final _turnoverEvolutionController = TextEditingController();
  final _worldRankingController = TextEditingController();
  final _categoryController = TextEditingController();
  final _subTypeController = TextEditingController();
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with estimated data if available
    _nameController.text = widget.estimatedTitle ?? '';
    _descriptionController.text = widget.estimatedDescription ?? '';
    _creatorController.text = widget.estimatedCreator ?? '';
    _yearController.text = widget.estimatedYear?.toString() ?? '';
    _priceController.text = widget.estimatedPrice?.toString() ?? '';
    _aiQuotePriceController.text = widget.estimatedPrice?.toString() ?? '';
    _birthCountryController.text = widget.estimatedBirthCountry ?? '';
    _sizeController.text = widget.estimatedSize ?? '';
    _yearBirthController.text = widget.estimatedYearBirth?.toString() ?? '';
    _auctionHouseResultController.text =
        widget.estimatedAuctionHouseResult ?? '';
    _turnoverEvolutionController.text = widget.estimatedTurnoverEvolution ?? '';
    _worldRankingController.text = widget.estimatedWorldRanking ?? '';
    _categoryController.text = widget.estimatedCategory ?? '';
    _subTypeController.text = widget.estimatedSubType ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _creatorController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _aiQuotePriceController.dispose();
    _auctionHousePriceController.dispose();
    _birthCountryController.dispose();
    _sizeController.dispose();
    _yearBirthController.dispose();
    _auctionHouseResultController.dispose();
    _turnoverEvolutionController.dispose();
    _worldRankingController.dispose();
    _categoryController.dispose();
    _subTypeController.dispose();
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
            // Container(padding: const EdgeInsets.only(top: 60)),
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
                // margin: const EdgeInsets.only(top: 40),
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
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
                            'Item Details',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'They all serve the same purpose, but each\none takes a different',
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
                              // if (widget.itemImage != null)
                              //   ClipRRect(
                              //     borderRadius: BorderRadius.circular(12),
                              //     child: Image.file(
                              //       widget.itemImage!,
                              //       width: double.infinity,
                              //       height: 200,
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // if (widget.estimatedImage != null)
                              //   ClipRRect(
                              //     borderRadius: BorderRadius.circular(12),
                              //     child: Image.file(
                              //       widget.estimatedImage!,
                              //       width: double.infinity,
                              //       height: 200,
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Item Name',
                                  hintText: 'Enter item name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an item name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Short Description',
                                  hintText: 'Enter a short description',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _creatorController,
                                decoration: const InputDecoration(
                                  labelText: 'Artist Name',
                                  hintText: 'Enter Artist name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a artist name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Price',
                                  hintText: 'e.g. 99.99',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a price';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _aiQuotePriceController,
                                decoration: const InputDecoration(
                                  labelText: 'AI Quote Estimated Price',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                enabled: false,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _auctionHousePriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Auction House Estimated Price',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                enabled: false,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _yearController,
                                decoration: const InputDecoration(
                                  labelText: 'Year',
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
                                    return 'Please enter a year';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _birthCountryController,
                                decoration: const InputDecoration(
                                  labelText: 'Birth Country',
                                  hintText: 'Enter birth country',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _sizeController,
                                decoration: const InputDecoration(
                                  labelText: 'Size',
                                  hintText: 'Enter size (e.g. 24x36)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an size';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _yearBirthController,
                                decoration: const InputDecoration(
                                  labelText: 'Year of Birth',
                                  hintText: 'Enter year of birth',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _auctionHouseResultController,
                                decoration: const InputDecoration(
                                  labelText: 'Auction House Result',
                                  hintText: 'Enter auction house result',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _turnoverEvolutionController,
                                decoration: const InputDecoration(
                                  labelText: 'Turnover Evolution',
                                  hintText: 'Enter turnover evolution',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _worldRankingController,
                                decoration: const InputDecoration(
                                  labelText: 'World Ranking',
                                  hintText: 'Enter world ranking',
                                  border: OutlineInputBorder(),
                                ),
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
                                      value: 'painting',
                                      child: Text('Painting')),
                                  DropdownMenuItem(
                                      value: 'sculpture',
                                      child: Text('Sculpture')),
                                  DropdownMenuItem(
                                      value: 'drawing', child: Text('Drawing')),
                                  DropdownMenuItem(
                                      value: 'photography',
                                      child: Text('Photography')),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _categoryController.text = newValue ?? '';
                                    // Reset subtype when main type changes
                                    _subTypeController.text = '';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a type';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _subTypeController.text.isEmpty
                                    ? null
                                    : _subTypeController.text,
                                decoration: const InputDecoration(
                                  labelText: 'Sub Type',
                                  border: OutlineInputBorder(),
                                ),
                                items: _categoryController.text == 'painting'
                                    ? const [
                                        DropdownMenuItem(
                                            value: 'contemporary_abstract',
                                            child: Text(
                                                'Contemporary Abstract Painting')),
                                        DropdownMenuItem(
                                            value: 'watercolor',
                                            child: Text('Watercolor')),
                                        DropdownMenuItem(
                                            value: 'contemporary_figurative',
                                            child: Text(
                                                'Contemporary Figurative Painting')),
                                        DropdownMenuItem(
                                            value: 'hyperrealism',
                                            child: Text('Hyperrealism')),
                                        DropdownMenuItem(
                                            value: 'mixed_media',
                                            child: Text('Mixed Media')),
                                        DropdownMenuItem(
                                            value: 'emerging_painter',
                                            child: Text('Emerging Painter')),
                                        DropdownMenuItem(
                                            value: 'surrealist',
                                            child: Text('Surrealist Painting')),
                                        DropdownMenuItem(
                                            value: 'street_art',
                                            child: Text('Street Art')),
                                      ]
                                    : _categoryController.text == 'sculpture'
                                        ? const [
                                            DropdownMenuItem(
                                                value: 'traditional',
                                                child: Text(
                                                    'Traditional Sculpture')),
                                            DropdownMenuItem(
                                                value: 'contemporary',
                                                child: Text(
                                                    'Contemporary Sculpture')),
                                          ]
                                        : _categoryController.text == 'drawing'
                                            ? const [
                                                DropdownMenuItem(
                                                    value: 'pencil',
                                                    child: Text('Pencil')),
                                                DropdownMenuItem(
                                                    value: 'ink',
                                                    child: Text('Ink')),
                                                DropdownMenuItem(
                                                    value: 'charcoal',
                                                    child: Text('Charcoal')),
                                              ]
                                            : _categoryController.text ==
                                                    'photography'
                                                ? const [
                                                    DropdownMenuItem(
                                                        value:
                                                            'traditional_photography',
                                                        child: Text(
                                                            'Traditional Photography')),
                                                    DropdownMenuItem(
                                                        value:
                                                            'digital_photography',
                                                        child: Text(
                                                            'Digital Photography')),
                                                  ]
                                                : const [],
                                onChanged: (_categoryController.text ==
                                            'painting' ||
                                        _categoryController.text ==
                                            'sculpture' ||
                                        _categoryController.text == 'drawing' ||
                                        _categoryController.text ==
                                            'photography')
                                    ? (String? newValue) {
                                        setState(() {
                                          _subTypeController.text =
                                              newValue ?? '';
                                        });
                                      }
                                    : null,
                                validator: (value) {
                                  if ((_categoryController.text == 'painting' ||
                                          _categoryController.text ==
                                              'sculpture' ||
                                          _categoryController.text ==
                                              'drawing' ||
                                          _categoryController.text ==
                                              'photography') &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please select a sub type';
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseCollectionScreen(
                                        itemName: _nameController.text,
                                        description:
                                            _descriptionController.text,
                                        creator: _creatorController.text,
                                        price: _priceController.text,
                                        year: _yearController.text,
                                        itemImage: widget.itemImage,
                                        estimatedImageUrl:
                                            widget.estimatedImage,
                                        birthCountry:
                                            _birthCountryController.text,
                                        size: _sizeController.text,
                                        yearBirth: _yearBirthController.text,
                                        auctionHouseResult:
                                            _auctionHouseResultController.text,
                                        turnoverEvolution:
                                            _turnoverEvolutionController.text,
                                        worldRanking:
                                            _worldRankingController.text,
                                        category: _categoryController.text,
                                        subtype: _subTypeController.text,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
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
