import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRecipeScreen extends StatelessWidget {
  final String recipeId;
  final Map<String, dynamic> recipe;

  EditRecipeScreen({required this.recipeId, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    final TextEditingController nameController = TextEditingController(text: recipe['name']);
    final TextEditingController descriptionController = TextEditingController(text: recipe['description']);
    final TextEditingController tagsController = TextEditingController(text: (recipe['tags'] as List).join(', '));
    final TextEditingController ingredientsController = TextEditingController(text: (recipe['ingredients'] as List).join(', ')); // Ingredient controller
    final TextEditingController caloriesController = TextEditingController(text: recipe['nutrition']['calories'].toString());
    final TextEditingController proteinController = TextEditingController(text: recipe['nutrition']['protein'].toString());
    final TextEditingController carbsController = TextEditingController(text: recipe['nutrition']['carbs'].toString());
    final TextEditingController fatsController = TextEditingController(text: recipe['nutrition']['fats'].toString());
    final TextEditingController cuisineController = TextEditingController(text: recipe['cuisine']); // Cuisine controller
    final TextEditingController difficultyController = TextEditingController(text: recipe['difficulty'] ?? ''); // Difficulty controller
    final TextEditingController stepsController = TextEditingController(text: (recipe['steps'] as List).join('\n')); // Steps controller

    void _updateRecipe() async {
      final updatedRecipe = {
        'name': nameController.text,
        'description': descriptionController.text,
        'tags': tagsController.text.split(',').map((tag) => tag.trim()).toList(),
        'ingredients': ingredientsController.text.split(',').map((ingredient) => ingredient.trim()).toList(), // Add ingredients
        'steps': stepsController.text.split('\n').map((step) => step.trim()).toList(), // Add steps
        'nutrition': {
          'calories': int.tryParse(caloriesController.text) ?? 0,
          'protein': int.tryParse(proteinController.text) ?? 0,
          'carbs': int.tryParse(carbsController.text) ?? 0,
          'fats': int.tryParse(fatsController.text) ?? 0,
        },
        'cuisine': cuisineController.text, // Add cuisine
        'difficulty': difficultyController.text, // Add difficulty
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
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter text here...',
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter text here...',
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: InputDecoration(labelText: 'Tags (comma-separated)', prefixIcon: Icon(Icons.text_fields), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients (comma-separated)', prefixIcon: Icon(Icons.text_fields), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // Cuisine Field
              TextField(
                controller: cuisineController,
                decoration: InputDecoration(labelText: 'Cuisine', prefixIcon: Icon(Icons.food_bank), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // Difficulty Field
              TextField(
                controller: difficultyController,
                decoration: InputDecoration(labelText: 'Difficulty', prefixIcon: Icon(Icons.star_border), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              const Text('Nutrition Information', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Calories', prefixIcon: Icon(Icons.text_fields), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Protein', prefixIcon: Icon(Icons.text_fields), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Carbs', prefixIcon: Icon(Icons.text_fields), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: fatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Fats', prefixIcon: Icon(Icons.text_fields), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // Recipe Steps Field
              TextField(
                controller: stepsController,
                decoration: InputDecoration(
                  labelText: 'Steps to Prepare',
                  hintText: 'Enter steps here...',
                  prefixIcon: Icon(Icons.list),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,  // Allows multi-line input
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateRecipe,
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 26, 207, 44),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
