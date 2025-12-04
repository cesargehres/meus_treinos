import 'package:flutter/material.dart';
import 'package:meus_treinos/data/repositories/workouts/workouts.dart';
import 'package:meus_treinos/ui/app/widgets/app_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => Workouts())
      ],
      child: AppScreen(),
    )
  );
}

