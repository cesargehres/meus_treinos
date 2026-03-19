import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/shared/app_bottom_sheet.dart';
import 'package:meus_treinos/ui/shared/app_dialogs.dart';
import 'package:meus_treinos/ui/workout_details/view_model/workout_details_view_model.dart';
import 'package:meus_treinos/ui/workout_details/widgets/exercise_edit_widget.dart';
import 'package:meus_treinos/ui/workout_details/widgets/workout_name_edit_widget.dart';
import 'package:meus_treinos/utils/string_extensions.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final WorkoutDetailsViewModel viewModel;

  const WorkoutDetailsScreen({required this.viewModel, super.key});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _modalOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, state) {
        if (widget.viewModel.workout == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop(widget.viewModel.workout);
              },
            ),
            title: GestureDetector(
              onTap: () {
                _showEditWorkoutNameSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.viewModel.workout!.workoutName.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.edit, color: Colors.blue),
                ],
              ),
            ),
          ),
          body: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                top: 8,
                right: 8,
                bottom:
                    MediaQuery.of(context).size.height *
                    (!_modalOpen ? 0.1 : 0.42),
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children: [
                    for (Exercise exercise
                        in widget.viewModel.workout!.exercises)
                      _buildExerciseCard(context, exercise, textColor),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 8),
            child: FloatingActionButton.extended(
              onPressed: () {
                _showCreateExerciseSheet(context);
              },
              tooltip: "Adicionar exercício",
              backgroundColor: Colors.green,
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    Exercise exercise,
    Color textColor,
  ) {
    return Container(
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
                  style: TextStyle(fontSize: 20, color: textColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  spacing: 8,
                  children: [
                    Flexible(
                      child: _infoLabel(
                        'Series: ',
                        exercise.series.toString(),
                        textColor,
                      ),
                    ),
                    Flexible(
                      child: _infoLabel(
                        'Repetições: ',
                        exercise.repeats.toString(),
                        textColor,
                      ),
                    ),
                    Flexible(
                      child: _infoLabel(
                        'Peso: ',
                        exercise.weight.toString(),
                        textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onPressed: () => _showEditExerciseSheet(context, exercise),
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () => _confirmDeleteExercise(context, exercise),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoLabel(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 12, color: color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  void _showEditWorkoutNameSheet(BuildContext context) {
    showAppBottomSheet(
      context,
      content: WorkoutNameEditWidget(viewModel: widget.viewModel),
    );
  }

  void _showEditExerciseSheet(BuildContext context, Exercise exercise) {
    setState(() => _modalOpen = true);

    showAppBottomSheet(
      context,
      enableDrag: !widget.viewModel.updateExercise.value.isRunning,
      content: ExerciseEditWidget(
        exercise: exercise,
        onSave: widget.viewModel.updateExercise,
      ),
    ).closed.then((_) {
      setState(() => _modalOpen = false);
    });
  }

  void _showCreateExerciseSheet(BuildContext context) {
    setState(() => _modalOpen = true);

    showAppBottomSheet(
      context,
      enableDrag: !widget.viewModel.createExercise.value.isRunning,
      content: ExerciseEditWidget(
        exercise: Exercise(
          workoutId: widget.viewModel.workout!.workoutId!,
          exerciseName: '',
          series: 3,
          repeats: 12,
          weight: 20,
        ),
        onSave: widget.viewModel.createExercise,
      ),
    ).closed.then((_) {
      setState(() => _modalOpen = false);
    });
  }

  Future<void> _confirmDeleteExercise(
    BuildContext context,
    Exercise exercise,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir exercício',
      message: 'Tem certeza que deseja excluir este exercício?',
      confirmLabel: 'Excluir',
      confirmColor: Colors.red,
    );
    if (!confirmed) return;

    await widget.viewModel.deleteExercise.execute(exercise);
    if (!context.mounted) return;
  }
}
