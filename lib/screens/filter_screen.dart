import 'package:flutter/material.dart';
import 'package:my_project/colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late RangeValues _currentPriceRange;
  final Map<String, bool> _selectedChains = {
    'Artworks': true,
    'Cars': false,
    'Boats': false,
    'Motorcycles': false,
  };
  final Map<String, int> _chainCounts = {
    'Artworks': 64,
    'Cars': 289,
    'Boats': 84,
    'Motorcycles': 12,
  };
  String _selectedStatus = 'Public'; // Default selection

  Map<String, bool> _expandedSections = {
    'Status': true,
    'Categories': true,
    'Price': true,
    'Primary colors': true,
    'Background': true,
  };

  @override
  void initState() {
    super.initState();
    _currentPriceRange = const RangeValues(15700, 38990);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            'Filters',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedStatus = 'Public'; // Reset status
                    _selectedChains.updateAll(
                      (key, value) => key == 'Artworks' ? true : false,
                    ); // Reset categories
                    _currentPriceRange = const RangeValues(
                      15700,
                      38990,
                    ); // Reset price range
                  });
                },
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('Reset'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              'Status',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Public', _selectedStatus == 'Public'),
                      _buildChip('Private', _selectedStatus == 'Private'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Categories',
              Column(
                children: _selectedChains.entries.map((entry) {
                  return _buildCheckboxTile(
                    entry.key,
                    entry.value,
                    _chainCounts[entry.key] ?? 0,
                    (bool? value) {
                      setState(() {
                        _selectedChains[entry.key] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Price',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: CustomPaint(
                      size: const Size(double.infinity, 100),
                      painter: HistogramPainter(),
                    ),
                  ),
                  RangeSlider(
                    values: _currentPriceRange,
                    min: 0,
                    max: 50000,
                    activeColor: AppColors.primaryColor,
                    inactiveColor: Colors.grey[300],
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentPriceRange = values;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${_currentPriceRange.start.toInt()}'),
                        Text('\$${_currentPriceRange.end.toInt()}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[title] = !(_expandedSections[title] ?? true);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _expandedSections[title] ?? true
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (_expandedSections[title] ?? true)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primaryColor : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      onSelected: (bool value) {
        setState(() {
          _selectedStatus = label;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.purple[50],
      side: BorderSide(
        color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      showCheckmark: false,
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool isChecked,
    int count,
    Function(bool?) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Text(title),
          const Spacer(),
          Text(count.toString(), style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class HistogramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    // Draw sample histogram bars
    final barWidth = size.width / 20;
    final random = List.generate(20, (i) => (i % 3 + 1) * 20.0);

    for (var i = 0; i < random.length; i++) {
      final height = random[i];
      final rect = Rect.fromLTWH(
        i * barWidth,
        size.height - height,
        barWidth * 0.8,
        height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
