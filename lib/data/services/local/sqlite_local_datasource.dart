import 'package:flutter/foundation.dart';
import 'package:meus_treinos/data/services/local/db_local.dart';
import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/services/models/workout_db_model/workout_db_model.dart';
import 'package:meus_treinos/utils/exceptions.dart';
import 'package:result_dart/result_dart.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class SQLiteDatabaseLocal implements DataBaseLocal {
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
  Future<Result<ExerciseDbModel>> createExercise({
    required int workoutId,
    required String exerciseName,
    required int series,
    required int repeats,
    required double weight,
  }) async {
    try {
      final db = await database;

      final int exerciseId = await db.insert(
        _tblExercises,
        {
          'workout_id': workoutId,
          'exercise_name': exerciseName,
          'series': series,
          'repeats': repeats,
          'weight': weight,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      final ExerciseDbModel exercise = ExerciseDbModel(
        exerciseId: exerciseId,
        workoutId: workoutId,
        exerciseName: exerciseName,
        series: series,
        repeats: repeats,
        weight: weight,
      );

      return Success(exercise);
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao criar o exercício',
          technicalMessage: technical,
          code: 'SQLITE_INSERT_EXERCISE',
        ),
      );
    }
  }


  @override
  Future<Result<WorkoutDbModel>> createWorkout({
    required String workoutName,
    required int weekday
  }) async {
    try {
      final db = await database;

      final int workoutId = await db.insert(
          _tblWorkouts,
          {
            'workout_name': workoutName,
            'weekday': weekday
          }
      );

      final WorkoutDbModel workout = WorkoutDbModel(
          workoutId: workoutId,
          workoutName: workoutName,
          weekday: weekday
      );

      return Success(workout);
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao criar o treino',
          technicalMessage: technical,
          code: 'SQLITE_INSERT_WORKOUT',
        ),
      );
    }
  }

  @override
  Future<Result<ExerciseDbModel>> readExercise({
    required int exerciseId,
  }) async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.query(
        _tblExercises,
        where: 'exercise_id = ?',
        whereArgs: [exerciseId],
        limit: 1,
      );

      if (result.isEmpty) {
        return Failure(
          LocalStorageException(
            message: 'Exercício não encontrado',
            technicalMessage: 'No exercise found with id=$exerciseId',
            code: 'SQLITE_EXERCISE_NOT_FOUND',
          ),
        );
      }

      final Map<String, Object?> map = result.first;

      final ExerciseDbModel exercise = ExerciseDbModel(
        exerciseId: map['exercise_id'] as int,
        workoutId: map['workout_id'] as int,
        exerciseName: map['exercise_name'] as String,
        series: map['series'] as int,
        repeats: map['repeats'] as int,
        weight: (map['weight'] as num).toDouble(),
      );

      return Success(exercise);
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao buscar o exercício',
          technicalMessage: technical,
          code: 'SQLITE_READ_EXERCISE',
        ),
      );
    }
  }


  @override
  Future<Result<WorkoutDbModel>> readWorkout({
    required int workoutId
  }) async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.query(
        _tblWorkouts,
        where: 'workout_id = ?',
        whereArgs: [workoutId],
        limit: 1
      );

      if (result.isEmpty) {
        return Failure(
          LocalStorageException(
            message: 'Treino não encontrado',
            technicalMessage: 'No workout found with id=$workoutId',
            code: 'SQLITE_WORKOUT_NOT_FOUND'
          )
        );
      }

      final Map<String, Object?> map = result.first;

      final WorkoutDbModel workout = WorkoutDbModel(
        workoutId: workoutId,
        workoutName: map['workout_name'] as String,
        weekday: map['weekday'] as int
      );

      return Success(workout);
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao buscar treino',
          technicalMessage: technical,
          code: 'SQLITE_READ_WORKOUT'
        )
      );
    }
  }

  @override
  Future<Result<WorkoutDbModel>> readWorkoutByWeekday({
    required int weekday
  }) async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.query(
        _tblWorkouts,
        where: 'weekday = ?',
        whereArgs: [weekday],
      );

      if (result.isEmpty) {
        return Failure(
            LocalStorageException(
                message: 'Treino não encontrado',
                technicalMessage: 'No workout found with weekday=$weekday',
                code: 'SQLITE_WORKOUT_NOT_FOUND'
            )
        );
      }

      final Map<String, Object?> map = result.first;

      final WorkoutDbModel workout = WorkoutDbModel(
          workoutId: map['workout_id'] as int,
          workoutName: map['workout_name'] as String,
          weekday: weekday
      );

      return Success(workout);
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao buscar treino',
          technicalMessage: technical,
          code: 'SQLITE_READ_WORKOUT'
        )
      );
    }
  }

  @override
  Future<Result<List<WorkoutDbModel>>> readWorkouts() async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.query(
        _tblWorkouts,
        orderBy: 'weekday ASC',
      );

      List<WorkoutDbModel> workouts = result.map((workout) {
        return WorkoutDbModel(
          workoutId: workout['workout_id'] as int,
          workoutName: workout['workout_name'] as String,
          weekday: workout['weekday'] as int
        );
      }).toList();

      return Success(workouts);
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao buscar treinos',
          technicalMessage: technical,
          code: 'SQLITE_READ_WORKOUT'
        )
      );
    }
  }

  @override
  Future<Result<ExerciseDbModel>> updateExercise({
    required int exerciseId,
    required String exerciseName,
    required int series,
    required int repeats,
    required double weight,
  }) async {
    try {
      final db = await database;

      final int rowsAffected = await db.update(
        _tblExercises,
        {
          'exercise_name': exerciseName,
          'series': series,
          'repeats': repeats,
          'weight': weight,
        },
        where: 'exercise_id = ?',
        whereArgs: [exerciseId],
      );

      if (rowsAffected == 0) {
        return Failure(
          LocalStorageException(
            message: 'Exercício não encontrado',
            technicalMessage: 'No exercise updated with id=$exerciseId',
            code: 'SQLITE_UPDATE_EXERCISE_NOT_FOUND',
          ),
        );
      }

      final Result<ExerciseDbModel> updatedExercise = await readExercise(exerciseId: exerciseId);

      return updatedExercise;
    } catch (e, s) {
      final technical = '$e\n$s';
      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao atualizar o exercício',
          technicalMessage: technical,
          code: 'SQLITE_UPDATE_EXERCISE',
        ),
      );
    }
  }

  @override
  Future<Result<WorkoutDbModel>> updateWorkout({
    required int workoutId,
    required String workoutName,
    required int weekday
  }) async {
    try {
      final db = await database;

      final int rowsAffected = await db.update(
        _tblWorkouts,
        {
          'workout_name': workoutName,
          'weekday': weekday
        },
        where: 'workout_id = ?',
        whereArgs: [workoutId]
      );

      if (rowsAffected == 0) {
        return Failure(
          LocalStorageException(
            message: 'Treino não encontrado',
            technicalMessage: 'No worjout updated with id=$workoutId',
            code: 'SQLITE_UPDATE_WORKOUT_NOT_FOUND',
          ),
        );
      }

      final Result<WorkoutDbModel> updatedWorkout = await readWorkout(workoutId: workoutId);

      return updatedWorkout;
    } catch (e, s) {
      final String technical = '$e\n$s';

      debugPrint(technical);

      return Failure(
        LocalStorageException(
          message: 'Erro ao atualizar o treino',
          technicalMessage: technical,
          code: 'SQLITE_UPDATE_WORKOUT',
        ),
      );
    }
  }
}