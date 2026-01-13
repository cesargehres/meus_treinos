import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ExerciseEditWidget extends StatefulWidget {
  final Exercise exercise;
  final Command1<Unit, Exercise> onSave;

  const ExerciseEditWidget({
    super.key,
    required this.onSave,
    required this.exercise
  });

  @override
  State<ExerciseEditWidget> createState() => _ExerciseEditWidgetState();
}

class _ExerciseEditWidgetState extends State<ExerciseEditWidget> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseSeriesController = TextEditingController();
  final TextEditingController _exerciseRepeatsController = TextEditingController();
  final TextEditingController _exerciseWeightController = TextEditingController();

  @override
  void initState() {
    _exerciseWeightController.text = widget.exercise.exerciseName;
    _exerciseSeriesController.text = widget.exercise.series.toString();
    _exerciseRepeatsController.text = widget.exercise.repeats.toString();
    _exerciseWeightController.text = widget.exercise.weight.toString();

    super.initState();
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField (
              decoration: InputDecoration(labelText: 'Nome do exercício'),
              controller: _exerciseNameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Séries'),
              keyboardType: TextInputType.number,
              controller: _exerciseSeriesController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Repetições'),
              keyboardType: TextInputType.number,
              controller: _exerciseRepeatsController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Peso'),
              keyboardType: TextInputType.number,
              controller: _exerciseWeightController,
            ),
            SizedBox(height: 16),
            Wrap(
              direction: Axis.horizontal,
              spacing: 16,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSave.execute(
                        Exercise(
                          exerciseId: widget.exercise.exerciseId,
                          workoutId: widget.exercise.workoutId,
                          exerciseName: _exerciseNameController.text,
                          series: int.parse(_exerciseSeriesController.text),
                          repeats: int.parse(_exerciseRepeatsController.text),
                          weight: double.parse(_exerciseWeightController.text))
                      );
                    },
                    child: Text('Salvar')
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Cancelar')
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
