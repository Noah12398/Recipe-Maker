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
            // Description or Additional Details (Placeholder for now)
            const Text(
              'Description: This recipe is a perfect choice for anyone looking to enjoy a delicious and quick meal. Check out the details on the website for preparation tips!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
