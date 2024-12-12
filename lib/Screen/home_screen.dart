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

    // Controllers for form fields
    final TextEditingController nameController = TextEditingController(text: recipe['name']);
    final TextEditingController descriptionController = TextEditingController(text: recipe['description']);
    final TextEditingController tagsController = TextEditingController(text: (recipe['tags'] as List).join(', '));
    final TextEditingController caloriesController = TextEditingController(text: recipe['nutrition']['calories'].toString());
    final TextEditingController proteinController = TextEditingController(text: recipe['nutrition']['protein'].toString());
    final TextEditingController carbsController = TextEditingController(text: recipe['nutrition']['carbs'].toString());
    final TextEditingController fatsController = TextEditingController(text: recipe['nutrition']['fats'].toString());

    // Function to update the recipe in Firestore
    void _updateRecipe() async {
      final updatedRecipe = {
        'name': nameController.text,
        'description': descriptionController.text,
        'tags': tagsController.text.split(',').map((tag) => tag.trim()).toList(),
        'nutrition': {
          'calories': int.tryParse(caloriesController.text) ?? 0,
          'protein': int.tryParse(proteinController.text) ?? 0,
          'carbs': int.tryParse(carbsController.text) ?? 0,
          'fats': int.tryParse(fatsController.text) ?? 0,
        },
      };

      await _firestore.collection('recipes').doc(recipeId).update(updatedRecipe);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _firestore.collection('recipes').doc(recipeId).delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration:  InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration:  InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: InputDecoration(labelText: 'Tags (comma-separated)',
                 hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 16),
              const Text('Nutrition Information', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(labelText: 'Calories',

                 hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 8),
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Protein',
                hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 8),
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(labelText: 'Carbs',
                hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 8),
              TextField(
                controller: fatsController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(labelText: 'Fats',
                hintText: 'Enter text here...', // Hint shown inside the field when empty
                  prefixIcon: Icon(Icons.text_fields), // Icon at the start

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  filled: true, // To enable background color
                  fillColor: Colors.grey[200], // Background color of the text field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border when not focused
                  ),
                  errorText: null, // Add error validation messages here
                ),
                style: TextStyle(
                  fontSize: 16.0, // Font size
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
                maxLines: 1, // Restrict to one line (use null for multiline)
                textCapitalization: TextCapitalization.words, // Capitalize each word
                cursorColor: Colors.blue, // Cursor color
                cursorWidth: 2.0, // Cursor width
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateRecipe,
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 26, 207, 44), // Button background color
                  onPrimary: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Button padding
                  shape: RoundedRectangleBorder( // Button shape
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Shadow effect
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

