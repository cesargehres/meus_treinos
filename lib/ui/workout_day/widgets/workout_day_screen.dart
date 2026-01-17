import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/workout_day/view_model/workout_day_view_model.dart';

class WorkoutDayScreen extends StatefulWidget {
  final WorkoutDayViewModel viewModel;

  const WorkoutDayScreen({
    required this.viewModel,
    super.key
  });

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
            return const Center(
                child: CircularProgressIndicator()
            );
          }

          if (widget.viewModel.workoutDay == null) {
            return const Center(
              child: Text('Sem Treino'),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Meus Treinos')
            ),
            body: SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 8,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 8,
                    children: [
                      for (Exercise exercise in widget.viewModel.workoutDay!.exercises)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Theme.of(context).colorScheme.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.exerciseName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: textColor
                                    ),
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      Row(
                                        spacing: 2,
                                        children: [
                                          Text(
                                            'Series: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: textColor
                                            ),
                                          ),
                                          Text(
                                            exercise.series.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: textColor
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        spacing: 2,
                                        children: [
                                          Text(
                                            'Repetições: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: textColor
                                            ),
                                          ),
                                          Text(
                                            exercise.repeats.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: textColor
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        spacing: 2,
                                        children: [
                                          Text(
                                            'Peso: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: textColor
                                            ),
                                          ),
                                          Text(
                                            exercise.weight.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: textColor
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
