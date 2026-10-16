import 'package:flutter/material.dart';
import 'package:meus_treinos/ui/shared/app_dialogs.dart';

/// Botão "!" exibido no card do exercício que abre as observações.
class ExerciseNotesButton extends StatelessWidget {
  final String exerciseName;
  final String notes;
  final Color color;

  const ExerciseNotesButton({
    super.key,
    required this.exerciseName,
    required this.notes,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Ver observações',
      onPressed: () =>
          showInfoDialog(context, title: exerciseName, message: notes),
      icon: Icon(Icons.error_outline, color: color),
    );
  }
}
