import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:meus_treinos/ui/shared/app_bottom_sheet.dart';
import 'package:meus_treinos/ui/workout_details/view_model/workout_details_view_model.dart';

class WorkoutNameEditWidget extends StatefulWidget {
  final WorkoutDetailsViewModel viewModel;

  const WorkoutNameEditWidget({super.key, required this.viewModel});

  @override
  State<WorkoutNameEditWidget> createState() => _WorkoutNameEditWidgetState();
}

class _WorkoutNameEditWidgetState extends State<WorkoutNameEditWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.viewModel.workout!.workoutName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        widget.viewModel.updateWorkout.value.isRunning ||
        widget.viewModel.loadCurrentWorkout.value.isRunning;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Nome do treino'),
          controller: _controller,
        ),
        const SizedBox(height: 16),
        BottomSheetActions(
          isLoading: isLoading,
          onSave: () async {
            if (_controller.text.trim().isEmpty) {
              return;
            }

            Workout newWorkout = widget.viewModel.workout!.copyWith(
              workoutName: _controller.text,
            );
            await widget.viewModel.updateWorkout.execute(newWorkout);
            if (widget.viewModel.updateWorkout.value.isSuccess) {
              await widget.viewModel.loadCurrentWorkout.execute(newWorkout);
            }
            if (!context.mounted) return;
            if (widget.viewModel.updateWorkout.value.isSuccess) {
              Navigator.of(context).pop();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
