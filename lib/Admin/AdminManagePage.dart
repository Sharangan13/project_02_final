import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminManagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Admin Management'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPlantCategoriesPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 5),
                            color:
                                Theme.of(context).primaryColor.withOpacity(.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Plants',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminEquipmentPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 5),
                            color:
                                Theme.of(context).primaryColor.withOpacity(.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Equipment',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
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

class AdminPlantCategoriesPage extends StatelessWidget {
  final List<String> plantCategories = [
    'Indoor Plants',
    'Outdoor Plants',
    'Flowering Plants',
    'Medicinal Plants',
    'Rare and Exotic Plants',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Categories'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0, // Add a small gap between columns
          mainAxisSpacing: 10.0, // Add a small gap between rows
          children: List.generate(plantCategories.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPlantDetailsPage(
                      category: plantCategories[index],
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        color: Theme.of(context).primaryColor.withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      plantCategories[index],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AdminPlantDetailsPage extends StatelessWidget {
  final String category;

  AdminPlantDetailsPage({required this.category});

  // Add logic to update plant details here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Details'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Category: $category',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class AdminEquipmentPage extends StatelessWidget {
  // Add logic to display and update equipment details here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Admin Equipment Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
