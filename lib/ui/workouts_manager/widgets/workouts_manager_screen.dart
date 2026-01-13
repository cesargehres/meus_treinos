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
    Color textColor = Theme.of(context).colorScheme.onPrimary;

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.getAllWorkouts.value.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.workouts.isEmpty) {
          return const Center(child: Text('Nenhum treino disponível'));
        }

        return Scaffold(
          body: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 72),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (Workout workout in widget.viewModel.workouts) ...[
                      GestureDetector(
                        onTap: () => {
                          context.go(
                            '/workoutsManager/details/${workout.workoutId}',
                            extra: workout
                          )
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
                                    1 => 'Dom',
                                    2 => 'Seg',
                                    3 => 'Ter',
                                    4 => 'Qua',
                                    5 => 'Qui',
                                    6 => 'Sex',
                                    _ => 'Sáb'
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 8),
            child: FloatingActionButton.extended(
              onPressed: () {},
              tooltip: "Adicionar exercício",
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Row(
                spacing: 8,
                children: [
                  Text(
                    'Adicionar exercício',
                    style: TextStyle(color: textColor),
                  ),
                  Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
