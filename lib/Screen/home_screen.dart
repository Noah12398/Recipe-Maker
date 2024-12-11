import 'package:flutter/material.dart';
import 'Item.dart';
import 'Recipedetail.dart';
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _drawerItem(Icons.favorite, 'Favorites'),
            _drawerItem(Icons.fastfood, 'Quick & Easy'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ItemScreen()), // Navigate to NewScreen
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Button text color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Go to New Screen'),
            ),
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RecipeGallery(),
      ),
    );
  }

  // Drawer item helper
  ListTile _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        // Add functionality if needed for the menu items
      },
    );
  }
}

class RecipeGallery extends StatelessWidget {
  const RecipeGallery({super.key});

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
        return _recipeCard(context, recipes[index]); // Pass context here
      },
    );
  }

  // Recipe card helper
  Widget _recipeCard(BuildContext context, Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        // Navigate to the new screen, passing the recipe data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Card(
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
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Make Ahead Breakfast Biscuit Sandwiches',
    'website': 'damndelicious.net',
    'tags': ['Medium', '60 mins', 'prep-friendly'],
    'imagePath': 'build/Cloud.png',
  },
  {
    'name': 'Strawberry Overnight Oats',
    'website': 'lifemadesweeter.com',
    'tags': ['Easy', '5 mins', 'quick and easy', 'healthy'],
    'imagePath': 'build/Cloud.png',
  },
  // Add more recipes...
];
