import 'package:flutter/material.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/data/services/local/db_local_interface.dart';
import 'package:meus_treinos/data/services/local/db_local_sqlite.dart';
import 'package:meus_treinos/ui/app/app_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<DataBaseLocalInterface>(
          create: (_) => DataBaseLocalSqlite(),
        ),
        Provider(create: (context) => WorkoutRepository(
          dataBaseLocal: context.read<DataBaseLocalSqlite>()
        ))
      ],
      child: AppScreen(),
    )
  );
}

