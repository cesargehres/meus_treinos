import 'package:flutter/material.dart';
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
    return ValueListenableBuilder(
      valueListenable: widget.viewModel.getAllWorkouts,
      builder: (context, value, child) {
        if (value.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.workouts.isEmpty) {
          return const Center(child: Text('Nenhum treino disponível'));
        }

        return SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var workout in widget.viewModel.workouts) ...[
                    Container(
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
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
