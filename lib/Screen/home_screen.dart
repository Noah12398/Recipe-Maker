import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/Screen/Recipedetail.dart';
import 'EditScreen.dart';
import 'AddScreen.dart';
import 'MealPlan.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

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
  List<String> availableIngredients = [];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
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

  void _shareApp() async {
    const String text = 'Check out this amazing recipe app!';
    final Uri shareUri = Uri(
      scheme: 'mailto',
      path: '',
      query: 'subject=Check out this amazing recipe app&body=$text',
    );

    // Attempt to launch the URL, if the platform supports it
    if (await canLaunchUrl(shareUri)) {
      await launchUrl(shareUri);
    } else {
      throw 'Could not launch email';
    }
  }

  void _shareRecipe(String recipeName,String steps) async {
    final String text = "Check out this recipe: $recipeName!\n\n"
      "Here are the steps to make it:\n$steps\n\n"
      "It's delicious and easy to make!";
    final Uri shareUri = Uri(
      scheme: 'mailto',
      path: '',
      query: 'subject=Recipe: $recipeName&body=$text',
    );

    if (await canLaunchUrl(shareUri)) {
      await launchUrl(shareUri);
    } else {
      throw 'Could not launch email';
    }
  }

  void _navigateToMealPlan(BuildContext context) async {
    final recipes = await _firestore.collection('recipes').get().then(
          (query) => query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealPlanScreen(recipes: recipes),
      ),
    );
  }

  void _navigateToAddRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen()),
    );
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareApp(),  // Share app functionality
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
            _drawerItem(Icons.food_bank, 'Meal Recipes', () {
              _navigateToMealPlan(context);
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe['name'] ?? 'Recipe Name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87, // Darker color for text readability
                ),
              ),
              const SizedBox(height: 12),

              // Cuisine and Difficulty
              Wrap(
                spacing: 18.0,
                children: [
                  Text(
                    'Cuisine: ${recipe['cuisine'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Difficulty: ${recipe['difficulty'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ingredients
              Text(
                'Ingredients: ${recipe['ingredients']?.join(', ') ?? 'N/A'}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (recipe['tags'] as List<dynamic>? ?? [])
                    .map(
                      (tag) => Chip(
                        label: Text(
                          tag.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.green.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Edit and Share Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditRecipeScreen(recipeId: id, recipe: recipe),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.green),
                    onPressed: () {
                      final String recipeName = recipe['name'] ?? 'Unknown Recipe';
                      final String recipeSteps = (recipe['steps'] as List<dynamic>?)?.join('\n') ?? 'Steps not available.';
                      _shareRecipe(recipeName,recipeSteps);
                    },
                    tooltip: 'Share Recipe',
                  ),
                ],
              ),
            ],
          ),
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
                items: ['All', 'Italian', 'Indian', 'Chinese','American','Asian','Mexican']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedDifficulty,
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
                items: ['All', 'Easy', 'Medium', 'Hard']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              Wrap(
                children: availableIngredients
                    .map((ingredient) => FilterChip(
                          label: Text(ingredient),
                          selected: selectedIngredients.contains(ingredient),
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedIngredients.add(ingredient);
                              } else {
                                selectedIngredients.remove(ingredient);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
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
              child: const Text('Clear Filters'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
