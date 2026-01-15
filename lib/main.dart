import 'package:flutter/material.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/data/services/local/database_local_interface.dart';
import 'package:meus_treinos/data/services/local/database_local_sqlite.dart';
import 'package:meus_treinos/ui/app/app_screen.dart';
import 'package:meus_treinos/ui/workouts_manager/view_model/workouts_manager_view_model.dart';
import 'package:meus_treinos/ui/workout_day/view_model/workout_day_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Database provider
        Provider<DataBaseLocalInterface>(
          create: (_) => DataBaseLocalSqlite(),
        ),
        // Repository provider
        Provider<WorkoutRepository>(
          create: (context) => WorkoutRepository(
            dataBaseLocal: context.read<DataBaseLocalInterface>(),
          ),
        ),
        // ViewModels
        ChangeNotifierProvider<WorkoutDayViewModel>(
          create: (context) => WorkoutDayViewModel(
            workoutRepository: context.read<WorkoutRepository>(),
          ),
        ),
        ChangeNotifierProvider<WorkoutsManagerViewModel>(
          create: (context) => WorkoutsManagerViewModel(
            workoutRepository: context.read<WorkoutRepository>(),
          ),
        ),
      ],
      child: AppScreen(),
    ),
  );
}
