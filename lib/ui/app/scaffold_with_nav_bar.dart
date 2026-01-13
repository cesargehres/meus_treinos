import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const ScaffoldWithNavBar({super.key, required this.child, required this.state});

  @override
  Widget build(BuildContext context) {
    final path = state.uri.path;

    String title;
    int currentIndex;
    if (path == '/') {
      title = 'Treino do Dia';
      currentIndex = 1;

    } else if (path == '/workoutsManager') {
      title = 'Meus Treinos';
      currentIndex = 0;
    } else if (path.startsWith('/workoutsManager/detail') && state.extra != null) {
      final workout = state.extra as Workout;
      title = workout.workoutName;
      currentIndex = 0;
    } else {
      title = 'Meu App';
      currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: child
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Meus Treinos'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treino do Dia'),
        ],
      ),
    );
  }
}
