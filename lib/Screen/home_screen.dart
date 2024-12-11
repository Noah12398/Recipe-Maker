import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _drawerItem(Icons.add, 'Add Recipe', () {
              _navigateToAddRecipe(context);
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('recipes').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final recipes = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index].data() as Map<String, dynamic>;
                return _recipeCard(context, recipe, recipes[index].id);
              },
            );
          },
        ),
      ),
    );
  }

  // Drawer item helper
  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Navigate to Add Recipe Screen
  void _navigateToAddRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen()),
    );
  }

  // Recipe card helper
  Widget _recipeCard(BuildContext context, Map<String, dynamic> recipe, String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditRecipeScreen(recipeId: id, recipe: recipe),
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
              // Recipe name
              Text(
                recipe['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Recipe tags
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: (recipe['tags'] as List<dynamic>)
                    .map((tag) => Chip(label: Text(tag.toString())))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  String name = '';
  List<String> tags = [];

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _firestore.collection('recipes').add({
        'name': name,
        'tags': tags,
      });
      await _firestore.collection('recipes').add({
        'name': 'Make Ahead Breakfast Biscuit Sandwiches',
        'website': 'damndelicious.net',
        'tags': ['Medium', '60 mins', 'prep-friendly'],
        'imagePath': "build/Cloud.png",
        'description': 'Delicious and easy-to-make breakfast biscuits.',
        'nutrition': {
          'calories': 200,
          'protein': 25,
          'carbs': 5,
          'fats': 83,
        },
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                onSaved: (value) {
                  name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditRecipeScreen extends StatelessWidget {
  final String recipeId;
  final Map<String, dynamic> recipe;

  EditRecipeScreen({required this.recipeId, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    void _deleteRecipe() async {
      await _firestore.collection('recipes').doc(recipeId).delete();
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRecipe,
          ),
        ],
      ),
      body: Center(
        child: Text('Edit Recipe Feature Coming Soon!'),
      ),
    );
  }
}
