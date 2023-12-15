import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_data_and_display/product_details_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
    await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('products')) {
        setState(() {
          products = List.from(data['products']);
        });
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
      // Display an error message to the user
    }
  }

  // Sign out user method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    String thumbnailUrl = product['thumbnail'] as String? ?? '';
    String title = product['title'] as String? ?? 'No Title';
    num price = product['price'] as num? ?? 0.0;
    num rating = product['rating'] as num? ?? 0.0;
    String brand = product['brand'] as String? ?? 'No Brand';
    String description = product['description'] as String? ?? 'No Description';
    List<String> images = product['images']?.cast<String>() ?? [];

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                title: title,
                brand: brand,
                price: price,
                description: description,
                images: images,
                rating: rating,
              ),
            ),
          );
        },
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.purple[100],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        thumbnailUrl.isNotEmpty
                            ? thumbnailUrl
                            : 'https://example.com/dummy-image.jpg',
                        width: 170.0,
                        height: 130.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Expanded(
                    child: Column(
                      
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Brand: $brand',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Price: \$${price.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout), // Use the exit icon
          ),
        ],
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          const Text(
            'Welcome to Online Shopping',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.purple,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            user?.email ?? 'Not logged in',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: (products.length / 2).ceil(),
                itemBuilder: (context, index) {
                  int firstProductIndex = index * 2;
                  int secondProductIndex = (index * 2) + 1;

                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      children: [
                        if (firstProductIndex < products.length)
                          buildProductCard(products[firstProductIndex]),
                        SizedBox(width: 10),
                        if (secondProductIndex < products.length)
                          buildProductCard(products[secondProductIndex]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
