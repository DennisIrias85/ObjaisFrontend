import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:math';
import 'package:my_project/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  OverlayEntry? _overlayEntry;

  void _showTooltip(
    BuildContext context,
    Offset position,
    String date,
    int views,
  ) {
    _removeTooltip();

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final tooltipPosition = Offset(position.dx - 50, position.dy - 50);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: tooltipPosition.dx,
        top: tooltipPosition.dy,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '$views Views',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Overview Cards
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Overview',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        '\$186.4k',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        // child: const Text(
                                        //   '+10%',
                                        //   style: TextStyle(
                                        //     color: Colors.green,
                                        //     fontSize: 12,
                                        //     fontWeight: FontWeight.w500,
                                        //   ),
                                        // ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Total Net Worth',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[100],
                                ),
                                child: const Icon(
                                  Icons.arrow_outward,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Sales History
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sales history',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[100],
                                        ),
                                        child: const Icon(
                                          Icons.bar_chart,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[100],
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  _buildLegendItem(
                                    'Views',
                                    AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildLegendItem(
                                    'Sales',
                                    const Color(0xFFFFB74D),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _buildBarPair(
                                          context,
                                          '27',
                                          0.9,
                                          0.0,
                                          3200,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '28',
                                          0.4,
                                          0.0,
                                          2100,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '1',
                                          0.7,
                                          0.3,
                                          2800,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '2',
                                          0.8,
                                          0.4,
                                          3100,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '3',
                                          0.6,
                                          0.5,
                                          2600,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '4',
                                          0.4,
                                          0.3,
                                          3570,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '5',
                                          0.7,
                                          0.3,
                                          2900,
                                        ),
                                        _buildBarPair(
                                          context,
                                          '6',
                                          0.9,
                                          0.4,
                                          3400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    top: 0,
                                    child: Row(
                                      children: [
                                        const Spacer(flex: 5),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const Spacer(flex: 2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'February',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'March',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Sales Breakdown
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Categories breakdown',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // IconButton(
                                  //   icon: const Icon(Icons.arrow_outward),
                                  //   onPressed: () {},
                                  //   padding: EdgeInsets.zero,
                                  //   constraints: const BoxConstraints(),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(height: 32),
                              Center(
                                child: CircularChart(
                                  totalAmount: 96.4,
                                  data: [
                                    ChartData(
                                      label: 'Art',
                                      amount: 48.3,
                                      color: Color(0xFFFFA00D9),
                                    ),
                                    ChartData(
                                      label: 'Photography',
                                      amount: 26.5,
                                      color: Color(0xFFFFB74D),
                                    ),
                                    ChartData(
                                      label: 'Trading cards',
                                      amount: 17.6,
                                      color: Color(0xFFE91E63),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildBreakdownItem(
                                'Art',
                                '\$48.3k',
                                AppColors.primaryColor,
                              ),
                              const SizedBox(height: 8),
                              _buildBreakdownItem(
                                'Photography',
                                '\$26.5k',
                                const Color(0xFFFFB74D),
                              ),
                              const SizedBox(height: 8),
                              _buildBreakdownItem(
                                'Trading cards',
                                '\$17.6k',
                                const Color(0xFFE91E63),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Bestsellers
                      // Collections(
                      //   items: [
                      //     BestsellerItem(
                      //       name: 'Bored Ape Yacht Club',
                      //       category: 'Art',
                      //       value: '4,915',
                      //       imageUrl:
                      //           'https://i.seadn.io/gae/Ju9CkWtV-1Okvf45wo8UctR-M9He2PjILP0oOvxE89AyiPPGtrR3gysu1Zgy0hjd2xKIgjJJtWIc0ybj4Vd7wv8t3pxDGHoJBzDB?auto=format&w=1000',
                      //       icon: Icons.verified,
                      //       iconColor: Colors.green,
                      //     ),
                      //     BestsellerItem(
                      //       name: 'Bored Ape Chemistry',
                      //       category: 'Photography',
                      //       value: '99.1',
                      //       imageUrl:
                      //           'https://i.seadn.io/gae/PhQxH9OE3_RSQf8UYD-2P-DNqXGNvWFXUKreH-bNHzH3HkneJTYUTVKGRJH1WOCCAhY8GnRSpZZu5HvYGt5_DPrB?auto=format&w=1000',
                      //       icon: Icons.token,
                      //       iconColor: Colors.blue,
                      //     ),
                      //     BestsellerItem(
                      //       name: 'RTFKT CloneX Mintvial',
                      //       category: 'Photography',
                      //       value: '4,310',
                      //       imageUrl:
                      //           'https://i.seadn.io/gae/XN0XuD8Uh3jyRWGtfunGqWpBWeyZxXlxqVEzkzBHGIJu1U8dQs1v4d_oHhGh4RIlZqQl_btJWqrLZPcJHJXn9GFwYGqYJFBOdoUe?auto=format&w=1000',
                      //       icon: Icons.diamond,
                      //       iconColor: Colors.blue,
                      //     ),
                      //     BestsellerItem(
                      //       name: 'Chromie Squiggle',
                      //       category: 'Art',
                      //       value: '3,905',
                      //       imageUrl:
                      //           'https://i.seadn.io/gae/0qG8Y78s198F2GZHhURw8_TEfxFlpS2XYnuLV_OW6TJin5AV1G2WOYjIvGV2DXjJhUZF9FqQLHhFjkHgqxmLgH1li3UHHPXYyNGX?auto=format&w=1000',
                      //       icon: Icons.verified,
                      //       iconColor: Colors.green,
                      //     ),
                      //     BestsellerItem(
                      //       name: 'Bored Ape Kennel',
                      //       category: 'Trading cards',
                      //       value: '3,570',
                      //       imageUrl:
                      //           'https://i.seadn.io/gae/l1wZXP2hHFUQ3turU5VQ9PpgVVasyQ79-ChvCgjoU5xKkBA50OGoJqKZeMOR-qLrzqwIfd1HpYmiv23JWm0EZ14owiPYZqTccMJE?auto=format&w=1000',
                      //       icon: Icons.token,
                      //       iconColor: Colors.blue,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                // Navigation handled in BottomNavBar
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarPair(
    BuildContext context,
    String label,
    double viewsHeight,
    double salesHeight,
    int viewsCount,
  ) {
    final bool isFebruary = label == '27' || label == '28';
    final String month = isFebruary ? 'February' : 'March';

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                _showTooltip(
                  context,
                  details.globalPosition,
                  '$month $label',
                  viewsCount,
                );
              },
              onTapUp: (_) => _removeTooltip(),
              onTapCancel: _removeTooltip,
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 3,
                      height: viewsHeight * 120,
                      margin: const EdgeInsets.only(right: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor
                            .withOpacity(label == '4' ? 0.3 : 1),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    if (salesHeight > 0)
                      Container(
                        width: 3,
                        height: salesHeight * 120,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFFB74D,
                          ).withOpacity(label == '4' ? 0.3 : 1),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: label == '4' ? Colors.black : Colors.grey,
              fontWeight: label == '4' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class CircularChart extends StatelessWidget {
  final List<ChartData> data;
  final double totalAmount;

  const CircularChart({
    super.key,
    required this.data,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: CircularChartPainter(data: data),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$${totalAmount}k',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Total',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final double amount;
  final Color color;

  ChartData({required this.label, required this.amount, required this.color});
}

class CircularChartPainter extends CustomPainter {
  final List<ChartData> data;

  CircularChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw background circles
    for (var i = 0; i < data.length; i++) {
      final radius = maxRadius - (i * 24); // Increased spacing between circles
      final bgPaint = Paint()
        ..color = Colors.grey[200]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16; // Increased stroke width

      canvas.drawCircle(center, radius - 8, bgPaint);
    }

    // Draw data arcs
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final radius = maxRadius - (i * 24); // Match spacing with background
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16 // Match stroke width
        ..strokeCap = StrokeCap.round;

      // Calculate sweep angle (using different proportions for each ring)
      final proportion =
          (data.length - i) / data.length * 0.8; // Varies from 0.8 to 0.27
      final sweepAngle = proportion * 2 * pi;
      const startAngle = -140 * (pi / 180); // Adjusted start angle

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 8),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BestsellerItem {
  final String name;
  final String category;
  final String value;
  final String imageUrl;
  final IconData icon;
  final Color iconColor;

  BestsellerItem({
    required this.name,
    required this.category,
    required this.value,
    required this.imageUrl,
    required this.icon,
    required this.iconColor,
  });
}

class Collections extends StatelessWidget {
  final List<BestsellerItem> items;

  const Collections({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Collections',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'See more',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items
                .map(
                  (item) => Column(
                    children: [
                      _buildBestsellerItem(item),
                      if (item != items.last) const Divider(height: 16),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBestsellerItem(BestsellerItem item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Icon(item.icon, size: 16, color: item.iconColor),
                  const Spacer(),
                  Text(
                    item.value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.category,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
