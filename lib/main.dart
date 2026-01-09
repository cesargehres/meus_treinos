import 'package:flutter/material.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/ui/app/app_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => WorkoutRepository())
      ],
      child: AppScreen(),
    )
  );
}

