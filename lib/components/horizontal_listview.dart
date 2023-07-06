import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          category(
              image_location: 'assets/types/O1.jpg',
              image_caption: 'Air Plants'),
          category(
              image_location: 'assets/types/O1.jpg',
              image_caption: 'Air Plants'),
          category(
              image_location: 'assets/types/O1.jpg',
              image_caption: 'Air Plants'),
          category(
              image_location: 'assets/types/O1.jpg',
              image_caption: 'Air Plants'),
          category(
              image_location: 'assets/types/O1.jpg',
              image_caption: 'Air Plants'),
        ],
      ),
    );
  }
}

class category extends StatelessWidget {
  late final String image_location;
  late final String image_caption;

  category({required this.image_location, required this.image_caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100.0,
          child: ListTile(
              title: Image.asset(
                image_location,
                width: 100.0,
                height: 80.0,
              ),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(image_caption),
              )),
        ),
      ),
    );
  }
}
