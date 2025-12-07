import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meus_treinos/ui/app/scaffold_with_nav_bar.dart';
import 'package:meus_treinos/ui/workout_day/view_model/workout_day_view_model.dart';
import 'package:meus_treinos/ui/workout_day/widgets/workout_day_screen.dart';
import 'package:meus_treinos/ui/workouts_manager/view_model/workouts_manager_view_model.dart';
import 'package:meus_treinos/ui/workouts_manager/widgets/workouts_manager_screen.dart';
import 'package:provider/provider.dart';

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
          return ScaffoldWithNavBar(
            key: ValueKey(state.uri.path),
            state: state,
            child: child
          );
        },
        routes: [
          GoRoute(
            name: 'workoutDay',
            path: '/',
            builder: (context, state) => WorkoutDayScreen(
              viewModel: context.read<WorkoutDayViewModel>(),
            )
          ),
          GoRoute(
            name: 'workoutsManager',
            path: '/workoutsManager',
            builder: (context, state) => WorkoutsManagerScreen(
              viewModel: context.read<WorkoutsManagerViewModel>()
            )
          ),
        ],
      ),
    ],
  );
}
