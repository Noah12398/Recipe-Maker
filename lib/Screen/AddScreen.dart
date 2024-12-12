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
  List<String> tags = [];
  Map<String, int> nutrition = {
    'calories': 0,
    'protein': 0,
    'carbs': 0,
    'fats': 0,
  };

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _firestore.collection('recipes').add({
        'name': name,
        'website': website,
        'tags': tags,
        'description': description,
        'nutrition': nutrition,
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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

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