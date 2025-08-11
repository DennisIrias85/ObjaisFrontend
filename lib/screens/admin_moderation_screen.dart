import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminModerationScreen extends StatefulWidget {
  @override
  AdminModerationScreenState createState() => AdminModerationScreenState();
}

class AdminModerationScreenState extends State<AdminModerationScreen> {
  List<Map<String, dynamic>> pendingItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingItems();
  }

  Future<void> fetchPendingItems() async {
    final baseUrl = dotenv.env['BASE_URL']!;
    print("🌍 FETCHING FROM: $baseUrl/api/moderation");

    try {
      final response = await http.get(Uri.parse("$baseUrl/api/moderation"));
      print("📩 STATUS: ${response.statusCode}");
      print("📦 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("✅ DECODED: $decoded");

        setState(() {
          pendingItems = List<Map<String, dynamic>>.from(decoded);
          loading = false;
        });
      } else {
        print("❌ FAILED TO LOAD ITEMS: ${response.body}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("💥 EXCEPTION: $e");
      setState(() => loading = false);
    }
  }

  Future<void> handleAction(String id, bool approved) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final endpoint = approved ? 'approve' : 'deny';

    try {
      await http.post(
        Uri.parse("$baseUrl/api/moderation/$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      setState(() => pendingItems.removeWhere((item) => item['_id'] == id));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: approved ? AppColors.legacyDark : AppColors.danger,
          duration: Duration(seconds: 3),
          content: Row(
            children: [
              Icon(
                approved ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Item ${approved ? 'approved' : 'rejected'} successfully!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print("Action failed: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 3),
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Action failed. Please try again.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> showDetailsDialog(String imageUrl) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/scrape/fromImage"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"imageUrl": imageUrl}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Scraped Details"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['model'] != null)
                    Text("Model: ${data['model']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['brand'] != null)
                    Text("Brand: ${data['brand']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['year'] != null || data['yearBuilt'] != null)
                    Text("Year: ${data['year'] ?? data['yearBuilt']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['engine'] != null || data['horsePower'] != null)
                    Text("Engine: ${data['engine'] ?? data['horsePower']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['length'] != null)
                    Text("Length: ${data['length']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['location'] != null)
                    Text("Location: ${data['location']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['priceFormatted'] != null || data['price'] != null)
                    Text("Price: ${data['priceFormatted'] ?? data['price']}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  if (data['createdAt'] != null)
                    Text(
                      'Added on: ${DateFormat('dd MMM yyyy | HH:mm').format(DateTime.parse(data['createdAt']))}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      } else {
        print("Scraper returned error: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch scraped details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Moderation")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pendingItems.length,
              itemBuilder: (context, index) {
                final item = pendingItems[index];
                return Card(
                  color: AppColors.background,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Builder(builder: (_) {
                                String imageUrl = item['imageUrl'] ?? '';
                                if (imageUrl.contains('localhost')) {
                                  imageUrl = imageUrl.replaceAll(
                                      'localhost', '18.206.227.2');
                                }
                                print('🖼️ Final Image URL: $imageUrl');
                                return Image.network(
                                  imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image_not_supported,
                                          size: 60, color: Colors.grey),
                                );
                              }),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Yacht',
                                    style: TextStyle(
                                      color: AppColors.fontDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Price: ${item['price'] ?? 'N/A'}"),
                                  Text("Brand: ${item['brand'] ?? 'N/A'}"),
                                  Text("Year: ${item['yearBuilt'] ?? 'N/A'}"),
                                  Text("Model: ${item['model'] ?? 'N/A'}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  showDetailsDialog(item['imageUrl']),
                              icon: Icon(Icons.search, color: AppColors.purple),
                              tooltip: 'Preview scraped details',
                            ),
                            TextButton(
                              onPressed: () => handleAction(item['_id'], true),
                              child: Text("Approve",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                            ),
                            TextButton(
                              onPressed: () => handleAction(item['_id'], false),
                              child: Text("Reject",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
