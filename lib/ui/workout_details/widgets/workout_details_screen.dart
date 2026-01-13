import 'package:flutter/material.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/ui/workout_details/view_model/workout_details_view_model.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final WorkoutDetailsViewModel viewModel;

  const WorkoutDetailsScreen({
    required this.viewModel,
    super.key
  });

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Scaffold(
          body: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 72),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children: [
                    for (Exercise exercise in widget.viewModel.workout!.exercises)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.exerciseName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor
                                  ),
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Row(
                                      spacing: 2,
                                      children: [
                                        Text(
                                          'Series: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor
                                          ),
                                        ),
                                        Text(
                                          exercise.series.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      spacing: 2,
                                      children: [
                                        Text(
                                          'Repetições: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor
                                          ),
                                        ),
                                        Text(
                                          exercise.repeats.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      spacing: 2,
                                      children: [
                                        Text(
                                          'Peso: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor
                                          ),
                                        ),
                                        Text(
                                          exercise.weight.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
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
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                IconButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 8),
            child: FloatingActionButton.extended(
              onPressed: () {
                Scaffold.of(context).showBottomSheet(
                  (context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const TextField (
                              decoration: InputDecoration(labelText: 'Nome do exercício'),
                            ),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Séries'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Repetições'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Peso'),
                              keyboardType: TextInputType.number,
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
                                    onPressed: () {},
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
                );
              },
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
      }
    );
  }
}
