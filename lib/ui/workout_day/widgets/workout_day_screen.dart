import 'package:flutter/material.dart';
import 'package:meus_treinos/ui/workout_day/view_model/workout_day_view_model.dart';

class WorkoutDayScreen extends StatelessWidget {
  final WorkoutDayViewModel viewModel;

  const WorkoutDayScreen({
    required this.viewModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = 24;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Treino do Dia'),
          ),
          body: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.purpleAccent,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Treino 1',
                                      style: TextStyle(
                                          fontSize: fontSize
                                      ),
                                    ),
                                  ]
                                )
                              ],
                            ),
                            Checkbox(value: false, onChanged: (value) => {})
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
