import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class RecipeScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe['name'],
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 10),
            Text('Ingredients:'),
            for (var ingredient in recipe['ingredients']) 
              Text(ingredient),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _shareRecipe();
              },
              child: const Text('Share Recipe'),
            ),
            ElevatedButton(
              onPressed: () {
                _shareRecipeViaEmail();
              },
              child: const Text('Share via Email'),
            ),
          ],
        ),
      ),
    );
  }

  // Share the recipe via social media (using the Share package)
  void _shareRecipe() {
    String recipeDetails = _getRecipeDetails();
    Share.share(recipeDetails, subject: 'Check out this recipe!');
  }

  // Share the recipe via email
  void _shareRecipeViaEmail() async {
    String recipeDetails = _getRecipeDetails();
    final Email email = Email(
      body: recipeDetails,
      subject: 'Recipe: ${recipe['name']}',
      recipients: ['example@example.com'], // Add recipient's email
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  // Format the recipe details for sharing
  String _getRecipeDetails() {
    String recipeDetails = '${recipe['name']}\n\nIngredients:\n';
    for (var ingredient in recipe['ingredients']) {
      recipeDetails += '- $ingredient\n';
    }
    return recipeDetails;
  }
}
