import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/shared/app_bottom_sheet.dart';
import 'package:meus_treinos/ui/shared/app_dialogs.dart';
import 'package:meus_treinos/ui/workout_details/view_model/workout_details_view_model.dart';
import 'package:meus_treinos/ui/workout_details/widgets/exercise_edit_widget.dart';
import 'package:meus_treinos/ui/workout_details/widgets/workout_name_edit_widget.dart';
import 'package:meus_treinos/utils/int_extensions.dart';
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
              child: _buildExerciseList(context, textColor),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          // Some enquanto o formulário de adicionar ou editar está aberto.
          floatingActionButton: _modalOpen
              ? null
              : Transform.translate(
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

  Widget _buildExerciseList(BuildContext context, Color textColor) {
    final List<Exercise> exercises = widget.viewModel.workout!.exercises;

    return ReorderableListView.builder(
      header: exercises.length > 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Segure e arraste um exercício para mudar a ordem',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : null,
      itemCount: exercises.length,
      // onReorder está obsoleto desde o Flutter 3.41, mas o substituto
      // (onReorderItem) não existe no Flutter 3.35, versão mínima do projeto.
      // ignore: deprecated_member_use
      onReorder: widget.viewModel.reorderExercise.execute,
      // Vibra ao pegar o card, para a pessoa sentir que ele pode ser movido.
      onReorderStart: (_) => HapticFeedback.mediumImpact(),
      // Ao ser pego, o card cresce e ganha uma sombra forte. Só o card é
      // elevado; o padrão elevaria junto o espaço abaixo dele.
      proxyDecorator: (_, index, animation) => AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final double lift = Curves.easeOut.transform(animation.value);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Transform.scale(
              scale: 1 + 0.05 * lift,
              child: Material(
                elevation: 16 * lift,
                child: _buildExerciseCard(context, exercises[index], textColor),
              ),
            ),
          );
        },
      ),
      // Usa o context da tela (e não o do item) para os formulários abrirem
      // no mesmo Scaffold do "Adicionar exercício".
      itemBuilder: (_, index) {
        final Exercise exercise = exercises[index];

        return Padding(
          key: ValueKey(exercise.exerciseId),
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildExerciseCard(context, exercise, textColor),
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
                    _infoLabel(
                      'Series: ',
                      exercise.series.toString(),
                      textColor,
                    ),
                    _infoLabel(
                      'Repetições: ',
                      exercise.repeats.toString(),
                      textColor,
                    ),
                    _infoLabel('Peso: ', exercise.weight.toString(), textColor),
                  ],
                ),
                Text(
                  'Descanso: ${formatRestRange(exercise.restMinSeconds, exercise.restMaxSeconds)}',
                  style: TextStyle(fontSize: 12, color: textColor),
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
        Text(label, style: TextStyle(fontSize: 12, color: color)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 35),
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
          restMinSeconds: 45,
          restMaxSeconds: 60,
          notes: null,
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
