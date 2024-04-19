import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipes_ui/core/enums/screen_size.dart';
import 'package:recipes_ui/features/recipes/recipes_data.dart';
import 'package:recipes_ui/features/recipes/recipes_layout.dart';
import 'package:recipes_ui/features/recipes/views/widgets/recipe_list_item.dart';
import 'package:recipes_ui/features/recipes/views/widgets/recipe_list_item_wrapper.dart';
import 'package:recipes_ui/features/recipes/views/pages/videoplayer.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ValueNotifier<ScrollDirection> scrollDirectionNotifier =
      ValueNotifier<ScrollDirection>(ScrollDirection.forward);

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // ignore: unused_field
  double _scrollPosition = 0.0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dessert Recipes'),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            // Screen 1: RecipesPage
            NotificationListener<UserScrollNotification>(
              onNotification: (UserScrollNotification notification) {
                if (notification.direction == ScrollDirection.forward ||
                    notification.direction == ScrollDirection.reverse) {
                  scrollDirectionNotifier.value = notification.direction;
                  setState(() {
                    _scrollPosition = notification.metrics.pixels;
                  });
                }
                return true;
              },
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: ScreenSize.of(context).isLarge ? 5 : 3.5,
                  right: ScreenSize.of(context).isLarge ? 5 : 3.5,
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      RecipesLayout.of(context).gridCrossAxisCount,
                  childAspectRatio:
                      RecipesLayout.of(context).gridChildAspectRatio,
                ),
                itemCount: RecipesData.dessertMenu.length,
                cacheExtent: 0,
                itemBuilder: (context, i) {
                  return ValueListenableBuilder(
                    valueListenable: scrollDirectionNotifier,
                    child: RecipeListItem(RecipesData.dessertMenu[i]),
                    builder:
                        (context, ScrollDirection scrollDirection, child) {
                      return RecipeListItemWrapper(
                        scrollDirection: scrollDirection,
                        child: child!,
                      );
                    },
                  );
                },
              ),
            ),
            // Screen 2: VideoPlayerScreen
              VideoPlayerScreen(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavyBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
          items: [
            BottomNavyBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  Icons.menu_book_outlined,
                  color: _selectedIndex == 0 ? Colors.lightGreen : Colors.grey,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Recipes',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.lightGreen : Colors.grey,
                  ),
                ),
              ),
              activeColor: Colors.lightGreen,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  Icons.video_library,
                  color: _selectedIndex == 1 ? Colors.purple[300] : Colors.grey,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Videos',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.purple[300] : Colors.grey,
                  ),
                ),
              ),
              activeColor: Colors.purple,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}