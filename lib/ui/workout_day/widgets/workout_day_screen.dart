import 'package:flutter/material.dart';

class WorkoutDayScreen extends StatelessWidget {
  const WorkoutDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Day'),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Container(),
            Container()
          ],
        ),
      ),
    );
  }
}
