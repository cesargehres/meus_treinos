import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/shared/app_bottom_sheet.dart';
import 'package:meus_treinos/utils/string_extensions.dart';
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
  static const int _maxNotesLength = 150;

  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseSeriesController =
      TextEditingController();
  final TextEditingController _exerciseRepeatsController =
      TextEditingController();
  final TextEditingController _exerciseWeightController =
      TextEditingController();
  final TextEditingController _exerciseRestMinController =
      TextEditingController();
  final TextEditingController _exerciseRestMaxController =
      TextEditingController();
  final TextEditingController _exerciseNotesController =
      TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _exerciseNameController.text = widget.exercise.exerciseName;
    _exerciseSeriesController.text = widget.exercise.series.toString();
    _exerciseRepeatsController.text = widget.exercise.repeats.toString();
    _exerciseWeightController.text = widget.exercise.weight.toString();
    _exerciseRestMinController.text =
        widget.exercise.restMinSeconds?.toString() ?? '';
    _exerciseRestMaxController.text =
        widget.exercise.restMaxSeconds?.toString() ?? '';
    _exerciseNotesController.text = widget.exercise.notes ?? '';
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _exerciseSeriesController.dispose();
    _exerciseRepeatsController.dispose();
    _exerciseWeightController.dispose();
    _exerciseRestMinController.dispose();
    _exerciseRestMaxController.dispose();
    _exerciseNotesController.dispose();
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  controller: _exerciseWeightController,
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Descanso mín. (s)',
                        ),
                        keyboardType: TextInputType.number,
                        controller: _exerciseRestMinController,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Descanso máx. (s)',
                        ),
                        keyboardType: TextInputType.number,
                        controller: _exerciseRestMaxController,
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Observações'),
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 3,
                  maxLength: _maxNotesLength,
                  controller: _exerciseNotesController,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                BottomSheetActions(
                  isLoading: widget.onSave.value.isRunning,
                  onSave: _save,
                  onCancel: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final name = _exerciseNameController.text.trim();
    final series = _exerciseSeriesController.text.toIntOrNull();
    final repeats = _exerciseRepeatsController.text.toIntOrNull();
    final weight = _exerciseWeightController.text.toDoubleOrNull();
    final restMin = _exerciseRestMinController.text.toIntOrNull();
    final restMax = _exerciseRestMaxController.text.toIntOrNull();
    final notes = _exerciseNotesController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Informe o nome do exercício');
      return;
    }

    if (series == null || series <= 0 || repeats == null || repeats <= 0) {
      setState(
        () => _errorMessage = 'Séries e repetições devem ser números inteiros',
      );
      return;
    }

    if (weight == null || weight < 0) {
      setState(() => _errorMessage = 'Informe um peso válido (ex: 20 ou 20,5)');
      return;
    }

    if (restMin == null || restMin < 0 || restMax == null || restMax < 0) {
      setState(
        () => _errorMessage =
            'Informe o descanso mínimo e máximo em segundos (ex: 45 e 60)',
      );
      return;
    }

    if (restMax < restMin) {
      setState(
        () =>
            _errorMessage = 'O descanso máximo não pode ser menor que o mínimo',
      );
      return;
    }

    if (notes.characters.length > _maxNotesLength) {
      setState(
        () => _errorMessage =
            'As observações podem ter no máximo $_maxNotesLength caracteres',
      );
      return;
    }

    setState(() => _errorMessage = null);

    await widget.onSave.execute(
      Exercise(
        exerciseId: widget.exercise.exerciseId,
        workoutId: widget.exercise.workoutId,
        exerciseName: name,
        series: series,
        repeats: repeats,
        weight: weight,
        restMinSeconds: restMin,
        restMaxSeconds: restMax,
        notes: notes.isEmpty ? null : notes,
      ),
    );

    if (!mounted) return;
    if (widget.onSave.value.isSuccess) {
      Navigator.of(context).pop();
    }
  }
}
