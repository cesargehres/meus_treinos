import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      title = 'Gerenciador de Treinos';
      currentIndex = 0;
    } else {
      title = 'Meu App';
      currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
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
