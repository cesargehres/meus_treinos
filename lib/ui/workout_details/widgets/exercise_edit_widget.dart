import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/shared/app_bottom_sheet.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ExerciseEditWidget extends StatefulWidget {
  final Exercise exercise;
  final Command1<Unit, Exercise> onSave;

  const ExerciseEditWidget({
    super.key,
    required this.onSave,
    required this.exercise,
  });

  @override
  State<ExerciseEditWidget> createState() => _ExerciseEditWidgetState();
}

class _ExerciseEditWidgetState extends State<ExerciseEditWidget> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseSeriesController =
      TextEditingController();
  final TextEditingController _exerciseRepeatsController =
      TextEditingController();
  final TextEditingController _exerciseWeightController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _exerciseNameController.text = widget.exercise.exerciseName;
    _exerciseSeriesController.text = widget.exercise.series.toString();
    _exerciseRepeatsController.text = widget.exercise.repeats.toString();
    _exerciseWeightController.text = widget.exercise.weight.toString();
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _exerciseSeriesController.dispose();
    _exerciseRepeatsController.dispose();
    _exerciseWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.onSave,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nome do exercício',
                  ),
                  controller: _exerciseNameController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Séries'),
                  keyboardType: TextInputType.number,
                  controller: _exerciseSeriesController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Repetições'),
                  keyboardType: TextInputType.number,
                  controller: _exerciseRepeatsController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Peso'),
                  keyboardType: TextInputType.number,
                  controller: _exerciseWeightController,
                ),
                const SizedBox(height: 16),
                BottomSheetActions(
                  isLoading: widget.onSave.value.isRunning,
                  onSave: () async {
                    if (_exerciseNameController.text.trim().isEmpty ||
                        _exerciseSeriesController.text.trim().isEmpty ||
                        _exerciseRepeatsController.text.trim().isEmpty ||
                        _exerciseWeightController.text.trim().isEmpty) {
                      return;
                    }

                    await widget.onSave.execute(
                      Exercise(
                        exerciseId: widget.exercise.exerciseId,
                        workoutId: widget.exercise.workoutId,
                        exerciseName: _exerciseNameController.text,
                        series: int.parse(_exerciseSeriesController.text),
                        repeats: int.parse(_exerciseRepeatsController.text),
                        weight: double.parse(_exerciseWeightController.text),
                      ),
                    );

                    if (!context.mounted) return;
                    if (widget.onSave.value.isSuccess) {
                      Navigator.of(context).pop();
                    }
                  },
                  onCancel: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
