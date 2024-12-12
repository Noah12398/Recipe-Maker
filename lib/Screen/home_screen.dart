import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/Screen/Recipedetail.dart';
import 'EditScreen.dart';
import 'AddScreen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  String selectedCuisine = 'All';
  String selectedDifficulty = 'All';
  List<String> selectedIngredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes Gallery"),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(context),
            ),
          ),
        ],
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
            _drawerItem(Icons.filter_list, 'Filter Recipes', () {
              _showFilterDialog(context);
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
            final filteredRecipes = recipes.where((recipe) {
              final recipeData = recipe.data() as Map<String, dynamic>;

              final nameMatch = recipeData['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());

              final cuisineMatch = selectedCuisine == 'All' ||
                  recipeData['cuisine'] == selectedCuisine;

              final difficultyMatch = selectedDifficulty == 'All' ||
                  recipeData['difficulty'] == selectedDifficulty;

              final ingredientsMatch = selectedIngredients.isEmpty ||
                  (recipeData['ingredients'] as List<dynamic>)
                      .any((ingredient) =>
                          selectedIngredients.contains(ingredient));

              return nameMatch && cuisineMatch && difficultyMatch && ingredientsMatch;
            }).toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index].data() as Map<String, dynamic>;
                return _recipeCard(context, recipe, filteredRecipes[index].id);
              },
            );
          },
        ),
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateToAddRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen()),
    );
  }

  Widget _recipeCard(BuildContext context, Map<String, dynamic> recipe, String id) {
    return GestureDetector(
      onTap: () {
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRecipeScreen(recipeId: id, recipe: recipe),
                    ),
                  );
                },
                child: const Text('Edit Recipe'),  // Add a child widget here, such as Text
              ),

              Text(
                recipe['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search Recipes"),
          content: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: const InputDecoration(hintText: 'Enter recipe name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Filter Recipes"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedCuisine,
                onChanged: (value) {
                  setState(() {
                    selectedCuisine = value!;
                  });
                },
                items: ['All', 'Italian', 'Indian', 'Chinese', 'Mexican']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedDifficulty,
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
                items: ['All', 'Easy', 'Medium', 'Hard']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 10),
              MultiSelectDialogField(
                items: [
                  MultiSelectItem<String>('Tomato', 'Tomato'),
                  MultiSelectItem<String>('Chicken', 'Chicken'),
                  MultiSelectItem<String>('Cheese', 'Cheese'),
                ],
                initialValue: selectedIngredients,
                onConfirm: (values) {
                  setState(() {
                    selectedIngredients = values!;
                  });
                },
                title: const Text('Select Ingredients'),
                buttonText: const Text('Select Ingredients'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedCuisine = 'All';
                  selectedDifficulty = 'All';
                  selectedIngredients = [];
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear Filters'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filters'),
            ),
          ],
        );
      },
    );
  }
}
