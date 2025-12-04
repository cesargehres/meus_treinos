import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meus_treinos/ui/app/app_scaffold.dart';
import 'package:meus_treinos/ui/workout_day/workout_day_screen.dart';
import 'package:meus_treinos/ui/workouts_manager/workouts_manager.dart';

class AppScreen extends StatelessWidget {
  AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meus Treinos',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: false,
        ),
      routerConfig: _router
    );
  }

  final _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(
            key: ValueKey(state.uri.path),
            state: state,
            child: child
          );
        },
        routes: [
          GoRoute(
            name: 'workoutDay',
            path: '/',
            builder: (context, state) => const WorkoutDayScreen(),
          ),
          GoRoute(
            name: 'workoutsManager',
            path: '/workoutsManager',
            builder: (context, state) => const WorkoutsManager(),
          ),
        ],
      ),
    ],
  );
}
