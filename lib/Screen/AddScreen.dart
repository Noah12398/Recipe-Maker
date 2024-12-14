import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  String name = '';
  String website = '';
  String description = '';
  String imagePath = '';
  String cuisine = ''; // Cuisine field
  String difficulty = 'Easy'; // Difficulty field, default to 'Easy'
  List<String> tags = [];
  List<String> ingredients = [];
  List<String> steps = [];  // Steps field
  Map<String, int> nutrition = {
    'calories': 0,
    'protein': 0,
    'carbs': 0,
    'fats': 0,
  };

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Save the form data to Firestore
        await _firestore.collection('recipes').add({
          'name': name,
          'website': website,
          'tags': tags,
          'description': description,
          'ingredients': ingredients,
          'nutrition': nutrition,
          'cuisine': cuisine,  // Save cuisine to Firestore
          'difficulty': difficulty,  // Save difficulty to Firestore
          'steps': steps,  // Save steps to Firestore
        });
        // Pop the current screen and return to the previous screen
        Navigator.pop(context);
      } catch (e) {
        print("Error saving recipe: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: SingleChildScrollView( // Make the form scrollable
        padding: const EdgeInsets.all(13.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Name
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
              const SizedBox(height: 13),

              // Website
              TextFormField(
                decoration: const InputDecoration(labelText: 'Website'),
                onSaved: (value) {
                  website = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a website';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Recipe Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Recipe Description'),
                onSaved: (value) {
                  description = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Cuisine
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cuisine (e.g., Italian, Chinese)'),
                onSaved: (value) {
                  cuisine = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a cuisine';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Difficulty
              DropdownButtonFormField<String>(
                value: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
                items: ['Easy', 'Medium', 'Hard']
                    .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Difficulty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a difficulty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Tags
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
                onSaved: (value) {
                  tags = value!.split(',').map((e) => e.trim()).toList();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some tags';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Ingredients (comma separated)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ingredients (comma separated)'),
                onSaved: (value) {
                  ingredients = value!.split(',').map((e) => e.trim()).toList();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some ingredients';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Nutrition Info (Calories, Protein, Carbs, Fats)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  nutrition['calories'] = int.tryParse(value!) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  nutrition['protein'] = int.tryParse(value!) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter protein content';
                  }
                  return null;
                },
              ),
              const SizedBox(height:13),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  nutrition['carbs'] = int.tryParse(value!) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter carbs content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Fats (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  nutrition['fats'] = int.tryParse(value!) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fats content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Steps (comma separated)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Steps (comma separated)'),
                onSaved: (value) {
                  steps = value!.split(',').map((e) => e.trim()).toList();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cooking steps';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 13),

              // Save Button
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
