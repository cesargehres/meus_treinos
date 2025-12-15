
import 'package:meus_treinos/data/sources/local/db_local.dart';
import 'package:meus_treinos/data/sources/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/sources/models/workout_db_model/workout_db_model.dart';
import 'package:result_dart/result_dart.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DataBaseLocalSqlite implements DataBaseLocal {
  static Database? _database;
  static const String _dbName = 'meus_treinos_db.db';
  static const int _dbVersion = 1;
  static const String _tblWorkouts = 'workouts';
  static const String _tblExercises = 'exercises';

  // Getter para o banco de dados (Singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        """
      CREATE TABLE $_tblWorkouts(
        workout_id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_name TEXT NOT NULL,
        weekday INTEGER NOT NULL
      )
      """
    );

    await db.execute(
        """
      CREATE TABLE $_tblExercises(
        exercise_id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        series INTEGER NOT NULL,
        repeats INTEGER NOT NULL,
        weight REAL NOT NULL,
        FOREIGN KEY (workout_id) REFERENCES $_tblWorkouts (workout_id) ON DELETE CASCADE
      )
      """
    );
  }

  @override
  Future<Result<ExerciseDbModel>> createExercise({required int workoutId, required String exerciseName, required int series, required int repeats, required double weight}) {
    // TODO: implement createExercise
    throw UnimplementedError();
  }

  @override
  Future<Result<WorkoutDbModel>> createWorkout({required String workoutName, required int weekday}) {
    // TODO: implement createWorkout
    throw UnimplementedError();
  }

  @override
  Future<Result<ExerciseDbModel>> readExercise({required int exerciseId}) {
    // TODO: implement readExercise
    throw UnimplementedError();
  }

  @override
  Future<Result<WorkoutDbModel>> readWorkout({required int workoutId}) {
    // TODO: implement readWorkout
    throw UnimplementedError();
  }

  @override
  Future<Result<WorkoutDbModel>> readWorkoutByWeekday({required int weekday}) {
    // TODO: implement readWorkoutByWeekday
    throw UnimplementedError();
  }

  @override
  Future<Result<List<WorkoutDbModel>>> readWorkouts() {
    // TODO: implement readWorkouts
    throw UnimplementedError();
  }

  @override
  Future<Result<ExerciseDbModel>> updateExercise({required int exerciseId, required String exerciseName, required int series, required int repeats, required double weight}) {
    // TODO: implement updateExercise
    throw UnimplementedError();
  }

  @override
  Future<Result<WorkoutDbModel>> updateWorkout({required int workoutId, required String workoutName, required int weekday}) {
    // TODO: implement updateWorkout
    throw UnimplementedError();
  }
}