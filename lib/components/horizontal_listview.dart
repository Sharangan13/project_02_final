import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Equipments',
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Flowering Plants',
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Indoor Plants',
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Medicinal Plants',
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Exotic Plants',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String imageLocation;
  final String imageCaption;

  const Category({
    required this.imageLocation,
    required this.imageCaption,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          // Handle category tap
        },
        child: Container(
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imageLocation,
                  width: 100.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                imageCaption,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
