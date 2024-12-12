import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/Screen/Recipedetail.dart';
import 'EditScreen.dart';
import 'AddScreen.dart';

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
  List<String> selectedIngredients = []; // Initialize as an empty list
  List<String> availableIngredients = []; // To hold available ingredients options

  @override
  void initState() {
    super.initState();
    _fetchIngredients(); // Fetch the available ingredients from Firestore
  }

  void _fetchIngredients() async {
    final querySnapshot = await _firestore.collection('recipes').get();
    final ingredients = <String>{};
    for (var doc in querySnapshot.docs) {
      final recipe = doc.data() as Map<String, dynamic>;
      final recipeIngredients = recipe['ingredients'] as List<dynamic>?;
      if (recipeIngredients != null) {
        ingredients.addAll(recipeIngredients.cast<String>());
      }
    }
    setState(() {
      availableIngredients = ingredients.toList();
    });
  }

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
            _drawerItem(Icons.filter_alt, 'Filter Recipes', () {
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
                  (recipeData['ingredients'] as List<dynamic>? ?? [])
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
                child: const Text('Edit Recipe'),
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
  print('Available Ingredients: $availableIngredients'); // Debug print
  print('Selected Ingredients: $selectedIngredients');   // Debug print

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Filter Recipes"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cuisine filter
              DropdownButton<String>(
                value: selectedCuisine,
                onChanged: (newValue) {
                  setState(() {
                    selectedCuisine = newValue!;
                  });
                },
                items: <String>['All', 'Italian', 'Chinese', 'Indian', 'Mexican']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Difficulty filter
              DropdownButton<String>(
                value: selectedDifficulty,
                onChanged: (newValue) {
                  setState(() {
                    selectedDifficulty = newValue!;
                  });
                },
                items: <String>['All', 'Easy', 'Medium', 'Hard']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Ingredients filter as a dropdown
              DropdownButtonFormField<String>(
                hint: const Text("Select Ingredients"),
                isExpanded: true,
                items: availableIngredients.map<DropdownMenuItem<String>>((String ingredient) {
                  return DropdownMenuItem<String>(
                    value: ingredient,
                    child: Text(ingredient),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null && !selectedIngredients.contains(value)) {
                      selectedIngredients.add(value);
                    }
                  });
                  print('Selected Ingredients Updated: $selectedIngredients'); // Debug print
                },
              ),
              // Display selected ingredients
              Wrap(
                children: selectedIngredients.map((ingredient) {
                  return Chip(
                    label: Text(ingredient),
                    onDeleted: () {
                      setState(() {
                        selectedIngredients.remove(ingredient);
                      });
                      print('Ingredient Removed: $ingredient'); // Debug print
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedCuisine = 'All';
                selectedDifficulty = 'All';
                selectedIngredients.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
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
