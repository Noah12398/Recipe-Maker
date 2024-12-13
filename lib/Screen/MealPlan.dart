import 'package:flutter/material.dart';

class MealPlanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recipes;

  const MealPlanScreen({required this.recipes, Key? key}) : super(key: key);

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final Map<String, Map<String, dynamic>?> _mealPlan = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Planning"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _mealPlan.keys.map((day) {
                return ListTile(
                  title: Text(day),
                  subtitle: Text(
                    _mealPlan[day]?['name'] ?? 'No recipe selected',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final selectedRecipe = await _selectRecipe(context);
                    if (selectedRecipe != null) {
                      setState(() {
                        _mealPlan[day] = selectedRecipe;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _generateIngredientList,
            child: const Text('Generate Ingredient List'),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _selectRecipe(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Recipe"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.recipes.length,
              itemBuilder: (context, index) {
                final recipe = widget.recipes[index];
                return ListTile(
                  title: Text(recipe['name']),
                  onTap: () {
                    Navigator.of(context).pop(recipe);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

 void _generateIngredientList() {
  final allIngredients = <String, int>{};

  // Iterate over all selected recipes in the meal plan
  _mealPlan.values.where((recipe) => recipe != null).forEach((recipe) {
    // Safely access the ingredients field
    final ingredients = recipe!['ingredients'];
    
    // Check if ingredients is a List before processing
    if (ingredients != null && ingredients is List<dynamic>) {
      for (var ingredient in ingredients) {
        allIngredients[ingredient] = (allIngredients[ingredient] ?? 0) + 1;
      }
    } else {
      // Handle the case where ingredients is null or not a List
      print("Warning: 'ingredients' field is missing or not a List in recipe: ${recipe['name']}");
    }
  });

  // Show the ingredient list in a dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Ingredient List"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: allIngredients.entries.map((entry) {
              return Text('${entry.key}: ${entry.value}');
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

}
