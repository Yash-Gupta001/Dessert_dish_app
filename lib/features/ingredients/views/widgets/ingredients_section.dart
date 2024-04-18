import 'package:flutter/material.dart';
import 'package:recipes_ui/core/widgets/animate_in_effect.dart';
import 'package:recipes_ui/features/ingredients/views/widgets/ingredient_item.dart';
import 'package:recipes_ui/features/recipes/models/recipe.dart';

class IngredientsSection extends StatelessWidget {
  const IngredientsSection(
    this.recipe, {
    Key? key,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipe.ingredients.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return AnimateInEffect(
          keepAlive: true,
          intervalStart: i / recipe.ingredients.length,
          child: IngredientItem(
            recipe,
            ingredient: recipe.ingredients[i],
          ),
        );
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> dec7ee7448b6cc1504e9315e173de6643dac71f3
