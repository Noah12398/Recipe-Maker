import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name'] ?? 'No Name'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: recipe['imagePath'] != null
                    ? Image.asset(
                        recipe['imagePath'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.broken_image, size: 100),
              ),
              const SizedBox(height: 16),
              Text(recipe['name'] ?? 'No Name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(recipe['website'] ?? 'No website', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: recipe['tags'] != null
                    ? (recipe['tags'] as List<dynamic>).map<Widget>((tag) => Chip(label: Text(tag), backgroundColor: Colors.green[100])).toList()
                    : [Text('No tags available')],
              ),
              const SizedBox(height: 16),
              Text(recipe['description'] ?? 'No description available', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text('Ingredients:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              recipe['ingredients'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (recipe['ingredients'] as List<dynamic>)
                          .map<Widget>((ingredient) => Text('- $ingredient', style: TextStyle(fontSize: 16)))
                          .toList(),
                    )
                  : const Text('No ingredients available', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text('Cuisine: ${recipe['cuisine'] ?? 'No cuisine available'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              Text('Difficulty: ${recipe['difficulty'] ?? 'No difficulty available'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              Text('Nutritional Information:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                border: TableBorder.all(color: Colors.grey),
                children: [
                  _buildNutritionalRow('Calories', '${recipe['nutrition']['calories']} kcal'),
                  _buildNutritionalRow('Protein', '${recipe['nutrition']['protein']} g'),
                  _buildNutritionalRow('Carbs', '${recipe['nutrition']['carbs']} g'),
                  _buildNutritionalRow('Fats', '${recipe['nutrition']['fats']} g'),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text('Steps to Prepare:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              recipe['steps'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (recipe['steps'] as List<dynamic>)
                          .map<Widget>((step) => Text('• $step', style: TextStyle(fontSize: 16)))
                          .toList(),
                    )
                  : const Text('No steps available', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildNutritionalRow(String nutrient, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(nutrient, style: TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
