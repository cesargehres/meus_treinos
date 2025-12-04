import 'package:flutter/material.dart';

class WorkoutDayScreen extends StatelessWidget {
  const WorkoutDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = 24;

    return SizedBox.expand(
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
                          Text(
                            'Treino 1',
                            style: TextStyle(
                                fontSize: fontSize
                            ),
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
    );
  }
}
