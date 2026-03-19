import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/workout_day/view_model/workout_day_view_model.dart';
import 'package:meus_treinos/utils/string_extensions.dart';

class WorkoutDayScreen extends StatefulWidget {
  final WorkoutDayViewModel viewModel;

  const WorkoutDayScreen({required this.viewModel, super.key});

  @override
  State<WorkoutDayScreen> createState() => _WorkoutDayScreenState();
}

class _WorkoutDayScreenState extends State<WorkoutDayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.getWorkoutDay.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, state) {
        if (widget.viewModel.getWorkoutDay.value.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.workoutDay == null) {
          return const Center(child: Text('Sem Treino'));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.viewModel.workoutDay!.workoutName.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    switch (widget.viewModel.workoutDay!.weekday) {
                      1 => 'Segunda',
                      2 => 'Terça',
                      3 => 'Quarta',
                      4 => 'Quinta',
                      5 => 'Sexta',
                      6 => 'Sábado',
                      _ => 'Domingo',
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children: [
                    for (Exercise exercise
                        in widget.viewModel.workoutDay!.exercises)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.exerciseName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Series: ${exercise.series}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'Repetições: ${exercise.repeats}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'Peso: ${exercise.weight}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
