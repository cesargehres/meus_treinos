import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final path = state.uri.path;

    int currentIndex;
    if (path == '/') {
      currentIndex = 1;
    } else if (path == '/workoutsManager') {
      currentIndex = 0;
    } else if (path.startsWith('/workoutsManager/detail')) {
      currentIndex = 0;
    } else {
      currentIndex = 0;
    }

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.goNamed('workoutsManager');
              break;
            case 1:
              context.goNamed('workoutDay');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meus Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Treino do Dia',
          ),
        ],
      ),
    );
  }
}
