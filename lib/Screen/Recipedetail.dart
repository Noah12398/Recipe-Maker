import 'package:flutter/material.dart';

// RecipeDetailScreen
class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  recipe['imagePath'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Recipe Name
              Text(
                recipe['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Website
              Text(
                recipe['website'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: recipe['tags']
                    .map<Widget>(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.green[100],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                recipe['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Nutritional Information Section
              Text(
                'Nutritional Information:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Nutritional Information Details
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2), // Nutrient column
                  1: FlexColumnWidth(1), // Value column
                },
                border: TableBorder.all(color: Colors.grey),
                children: [
                  _buildNutritionalRow('Calories', '${recipe['nutrition']['calories']} kcal'),
                  _buildNutritionalRow('Protein', '${recipe['nutrition']['protein']} g'),
                  _buildNutritionalRow('Carbs', '${recipe['nutrition']['carbs']} g'),
                  _buildNutritionalRow('Fats', '${recipe['nutrition']['fats']} g'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a table row for nutritional information
  TableRow _buildNutritionalRow(String nutrient, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            nutrient,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
