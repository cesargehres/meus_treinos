import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:meus_treinos/ui/workouts_manager/view_model/workouts_manager_view_model.dart';

class WorkoutsManagerScreen extends StatefulWidget {
  final WorkoutsManagerViewModel viewModel;

  const WorkoutsManagerScreen({
    required this.viewModel,
    super.key
  });

  @override
  State<WorkoutsManagerScreen> createState() => _WorkoutsManagerScreenState();
}

class _WorkoutsManagerScreenState extends State<WorkoutsManagerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.viewModel.getAllWorkouts.value.isRunning) {
        widget.viewModel.getAllWorkouts.execute();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, state) {
        if (widget.viewModel.getAllWorkouts.value.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.workouts.isEmpty) {
          return const Center(child: Text('Nenhum para hoje'));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Meus Treinos'),
          ),
          body: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (Workout workout in widget.viewModel.workouts) ...[
                      GestureDetector(
                        onTap: () async {
                          widget.viewModel.loadCurrentWorkout.execute(workout);

                          final Workout? updated = await context.push(
                            '/workoutsManager/details/${workout.workoutId}',
                          );

                          if (updated is Workout) {
                            widget.viewModel.replaceWorkout.execute(updated);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.primary,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                Text(
                                  workout.workoutName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  switch (workout.weekday) {
                                    1 => 'Seg',
                                    2 => 'Ter',
                                    3 => 'Qua',
                                    4 => 'Qui',
                                    5 => 'Sex',
                                    6 => 'Sab',
                                    _ => 'Dom'
                                  },
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primaryContainer
                                  ),
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
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
