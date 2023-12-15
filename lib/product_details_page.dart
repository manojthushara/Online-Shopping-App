import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_data_and_display/components/my_button.dart';

import 'components/my_button02.dart';

class ProductDetailPage extends StatelessWidget {
  final String title;
  final String brand;
  final num price;
  final String description;
  final List<String> images;
  final num rating;

  ProductDetailPage({
    required this.title,
    required this.brand,
    required this.price,
    required this.description,
    required this.images,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.purple[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20,bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Images in a Slider
              images.isNotEmpty
                  ? CarouselSlider(
                items: images.map((image) {
                  return Image.network(
                    image,
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                ),
              )
                  : Image.network(
                'https://example.com/dummy-image.jpg',
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
              ),

              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(

                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 250,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Brand: $brand',style:
                          TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),),
                        SizedBox(height: 5,),
                        Text('Price: \$${price.toString()}',style:

                        TextStyle(
                          color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5,),
                        Text('Ratings: ${rating.toString()}',style:
                        TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5,),
                        Text('Description: $description',style:
                        TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyButton02(onTop: () {}, text: 'Buy Now'),
                            SizedBox(width: 10,),
                            MyButton02(onTop: () {}, text: 'Add to cart')
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
