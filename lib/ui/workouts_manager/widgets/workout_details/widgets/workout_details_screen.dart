import 'package:flutter/material.dart';
import 'package:meus_treinos/ui/workouts_manager/widgets/workout_details/view_model/workout_details_view_model.dart';

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
    return Container(
      child: Column(
        children: [
          Text(widget.viewModel.workout!.weekday.toString())
        ],
      ),
    );
  }

}
