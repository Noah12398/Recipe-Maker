import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes Gallery"),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _drawerItem(Icons.favorite, 'Favorites'),
            _drawerItem(Icons.fastfood, 'Quick & Easy'),
            const ExpansionTile(
              title: Text('Meals'),
              children: [
                ListTile(title: Text('Breakfast')),
                ListTile(title: Text('Main Courses')),
                ListTile(title: Text('Side Dishes')),
                ListTile(title: Text('Snacks')),
                ListTile(title: Text('Desserts')),
                ListTile(title: Text('Beverages')),
              ],
            ),
            const ExpansionTile(
              title: Text('Categories'),
              children: [
                ListTile(title: Text('Meat')),
                ListTile(title: Text('Poultry')),
                ListTile(title: Text('Seafood')),
                ListTile(title: Text('Vegetables Based')),
                ListTile(title: Text('Rice & Pasta')),
                ListTile(title: Text('Baking')),
                ListTile(title: Text('Others')),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RecipeGallery(),
      ),
    );
  }

  // Drawer item helper
  ListTile _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {},
    );
  }
}

class RecipeGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of items per row
        crossAxisSpacing: 10, // Space between rows
        mainAxisSpacing: 10, // Space between columns
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return _recipeCard(recipes[index]);
      },
    );
  }

  // Recipe card helper
  Widget _recipeCard(Map<String, dynamic> recipe) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                recipe['imagePath'],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Recipe name and website
            Text(
              recipe['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              recipe['website'],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            // Tags and details
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: recipe['tags']
                  .map<Widget>(
                    (tag) => Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 10)),
                      backgroundColor: Colors.green[100],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample recipes data
List<Map<String, dynamic>> recipes = [
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },

  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'assets/images/Cloud.png',
  },
  // Add more recipes...
];
