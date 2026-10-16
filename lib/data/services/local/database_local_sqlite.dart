import 'package:meus_treinos/data/services/exceptions/exceptions.dart';
import 'package:meus_treinos/data/services/local/database_local_interface.dart';
import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/services/models/workout_db_model/workout_db_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DataBaseLocalSqlite implements DataBaseLocalInterface {
  static Database? _database;
  static const String _dbName = 'meus_treinos_db.db';
  static const int _dbVersion = 2;
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
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        rest_min_seconds INTEGER,
        rest_max_seconds INTEGER,
        notes TEXT,
        position INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (workout_id) REFERENCES $_tblWorkouts (workout_id) ON DELETE CASCADE
      )
      """
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // v2: faixa de descanso (mínimo e máximo), observações e ordem dos exercícios
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $_tblExercises ADD COLUMN rest_min_seconds INTEGER');
      await db.execute('ALTER TABLE $_tblExercises ADD COLUMN rest_max_seconds INTEGER');
      await db.execute('ALTER TABLE $_tblExercises ADD COLUMN notes TEXT');
      await db.execute('ALTER TABLE $_tblExercises ADD COLUMN position INTEGER NOT NULL DEFAULT 0');

      // Exercícios existentes ficam na ordem em que foram cadastrados.
      await db.execute(
          """
        UPDATE $_tblExercises SET position = (
          SELECT COUNT(*) FROM $_tblExercises AS previous
          WHERE previous.workout_id = $_tblExercises.workout_id
            AND previous.exercise_id < $_tblExercises.exercise_id
        )
        """
      );
    }
  }

  @override
  Future<ExerciseDbModel> createExercise({
    required ExerciseDbModel exerciseDbModel
  }) async {
    try {
      final db = await database;

      // Exercício novo entra no fim da lista do treino.
      final List<Map<String, Object?>> nextPosition = await db.rawQuery(
        'SELECT COALESCE(MAX(position), -1) + 1 AS position FROM $_tblExercises WHERE workout_id = ?',
        [exerciseDbModel.workoutId],
      );

      final int exerciseId = await db.insert(
        _tblExercises,
        {
          'workout_id': exerciseDbModel.workoutId,
          'exercise_name': exerciseDbModel.exerciseName,
          'series': exerciseDbModel.series,
          'repeats': exerciseDbModel.repeats,
          'weight': exerciseDbModel.weight,
          'rest_min_seconds': exerciseDbModel.restMinSeconds,
          'rest_max_seconds': exerciseDbModel.restMaxSeconds,
          'notes': exerciseDbModel.notes,
          'position': nextPosition.first['position'] as int,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      final ExerciseDbModel exercise = ExerciseDbModel(
        exerciseId: exerciseId,
        workoutId: exerciseDbModel.workoutId,
        exerciseName: exerciseDbModel.exerciseName,
        series: exerciseDbModel.series,
        repeats: exerciseDbModel.repeats,
        weight: exerciseDbModel.weight,
        restMinSeconds: exerciseDbModel.restMinSeconds,
        restMaxSeconds: exerciseDbModel.restMaxSeconds,
        notes: exerciseDbModel.notes,
      );

      return exercise;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao criar o exercício',
        technicalMessage: technical,
        code: 'SQLITE_INSERT_EXERCISE',
      );
    }
  }


  @override
  Future<WorkoutDbModel> createWorkout({
    required WorkoutDbModel workoutDbModel
  }) async {
    try {
      final db = await database;

      final int workoutId = await db.insert(
          _tblWorkouts,
          {
            'workout_name': workoutDbModel.workoutName,
            'weekday': workoutDbModel.weekday
          }
      );

      final WorkoutDbModel workout = WorkoutDbModel(
          workoutId: workoutId,
          workoutName: workoutDbModel.workoutName,
          weekday: workoutDbModel.weekday
      );

      return workout;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao criar o treino',
        technicalMessage: technical,
        code: 'SQLITE_INSERT_WORKOUT',
      );
    }
  }

  @override
  Future<ExerciseDbModel> readExercise({
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
        throw DataBaseLocalException(
          message: 'Exercício não encontrado',
          technicalMessage: 'No exercise found with id=$exerciseId',
          code: 'SQLITE_EXERCISE_NOT_FOUND',
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
        restMinSeconds: map['rest_min_seconds'] as int?,
        restMaxSeconds: map['rest_max_seconds'] as int?,
        notes: map['notes'] as String?,
      );

      return exercise;
    } on DataBaseLocalException {
      rethrow;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao buscar o exercício',
        technicalMessage: technical,
        code: 'SQLITE_READ_EXERCISE',
      );
    }
  }

  @override
  Future<List<ExerciseDbModel>> readExercisesByWorkout({
    required int workoutId
  }) async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.query(
          _tblExercises,
          where: 'workout_id = ?',
          whereArgs: [workoutId],
          orderBy: 'position ASC, exercise_id ASC'
      );

      final List<ExerciseDbModel> exercises = result.map((exercise) {
        return ExerciseDbModel(
            exerciseId: exercise['exercise_id'] as int,
            workoutId: workoutId,
            exerciseName: exercise['exercise_name'] as String,
            series: exercise['series'] as int,
            repeats: exercise['repeats'] as int,
            weight: (exercise['weight'] as num).toDouble(),
            restMinSeconds: exercise['rest_min_seconds'] as int?,
            restMaxSeconds: exercise['rest_max_seconds'] as int?,
            notes: exercise['notes'] as String?,
        );
      }).toList();

      return exercises;
    } catch (e, s){
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao buscar exercícios do treino',
        technicalMessage: technical,
        code: 'SQLITE_READ_EXERCISES_BY_WORKOUT',
      );
    }
  }

  @override
  Future<WorkoutDbModel> readWorkout({
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
        throw DataBaseLocalException(
          message: 'Treino não encontrado',
          technicalMessage: 'No workout found with id=$workoutId',
          code: 'SQLITE_WORKOUT_NOT_FOUND',
        );
      }

      final Map<String, Object?> map = result.first;

      final WorkoutDbModel workout = WorkoutDbModel(
        workoutId: workoutId,
        workoutName: map['workout_name'] as String,
        weekday: map['weekday'] as int
      );

      return workout;
    } on DataBaseLocalException {
      rethrow;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao buscar treino',
        technicalMessage: technical,
        code: 'SQLITE_READ_WORKOUT',
      );
    }
  }

  @override
  Future<WorkoutDbModel?> readWorkoutByWeekday({
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
        return null;
      }

      final Map<String, Object?> map = result.first;

      final WorkoutDbModel workout = WorkoutDbModel(
          workoutId: map['workout_id'] as int,
          workoutName: map['workout_name'] as String,
          weekday: weekday
      );

      return workout;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao buscar treino',
        technicalMessage: technical,
        code: 'SQLITE_READ_WORKOUT',
      );
    }
  }

  @override
  Future<List<WorkoutDbModel>> readWorkouts() async {
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

      return workouts;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao buscar treinos',
        technicalMessage: technical,
        code: 'SQLITE_READ_WORKOUT',
      );
    }
  }

  @override
  Future<ExerciseDbModel> updateExercise({
    required ExerciseDbModel exerciseDbModel
  }) async {
    try {
      if (exerciseDbModel.exerciseId == null) {
        throw DataBaseLocalException(
          message: 'Não é possível atualizar um exercício sem id',
          technicalMessage: 'exerciseId was null when calling updateExercise',
          code: 'SQLITE_UPDATE_EXERCISE_NO_ID',
        );
      }

      final db = await database;

      final int rowsAffected = await db.update(
        _tblExercises,
        {
          'exercise_name': exerciseDbModel.exerciseName,
          'series': exerciseDbModel.series,
          'repeats': exerciseDbModel.repeats,
          'weight': exerciseDbModel.weight,
          'rest_min_seconds': exerciseDbModel.restMinSeconds,
          'rest_max_seconds': exerciseDbModel.restMaxSeconds,
          'notes': exerciseDbModel.notes,
        },
        where: 'exercise_id = ?',
        whereArgs: [exerciseDbModel.exerciseId],
      );

      if (rowsAffected == 0) {
        throw DataBaseLocalException(
          message: 'Exercício não encontrado',
          technicalMessage: 'No exercise updated with id=${exerciseDbModel.exerciseId}',
          code: 'SQLITE_UPDATE_EXERCISE_NOT_FOUND',
        );
      }

      final ExerciseDbModel updatedExercise = await readExercise(exerciseId: exerciseDbModel.exerciseId!);

      return updatedExercise;
    } on DataBaseLocalException {
      rethrow;
    } catch (e, s) {
      final technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao atualizar o exercício',
        technicalMessage: technical,
        code: 'SQLITE_UPDATE_EXERCISE',
      );
    }
  }

  @override
  Future<void> updateExercisesOrder({
    required int workoutId,
    required List<int> exerciseIds
  }) async {
    try {
      final db = await database;

      await db.transaction((txn) async {
        for (int index = 0; index < exerciseIds.length; index++) {
          await txn.update(
            _tblExercises,
            {'position': index},
            where: 'exercise_id = ? AND workout_id = ?',
            whereArgs: [exerciseIds[index], workoutId],
          );
        }
      });
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao reordenar os exercícios',
        technicalMessage: technical,
        code: 'SQLITE_UPDATE_EXERCISES_ORDER',
      );
    }
  }

  @override
  Future<WorkoutDbModel> updateWorkout({
    required WorkoutDbModel workoutDbModel
  }) async {
    try {
      if (workoutDbModel.workoutId == null) {
        throw DataBaseLocalException(
          message: 'Não é possível atualizar um treino sem id',
          technicalMessage: 'exerciseId was null when calling updateWorkout',
          code: 'SQLITE_UPDATE_WORKOUT_NO_ID',
        );
      }

      final db = await database;

      final int rowsAffected = await db.update(
        _tblWorkouts,
        {
          'workout_name': workoutDbModel.workoutName,
          'weekday': workoutDbModel.weekday
        },
        where: 'workout_id = ?',
        whereArgs: [workoutDbModel.workoutId]
      );

      if (rowsAffected == 0) {
        throw DataBaseLocalException(
          message: 'Treino não encontrado',
          technicalMessage: 'No workout updated with id=${workoutDbModel.workoutId}',
          code: 'SQLITE_UPDATE_WORKOUT_NOT_FOUND',
        );
      }

      final WorkoutDbModel updatedWorkout = await readWorkout(workoutId: workoutDbModel.workoutId!);

      return updatedWorkout;
    } on DataBaseLocalException {
      rethrow;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao atualizar o treino',
        technicalMessage: technical,
        code: 'SQLITE_UPDATE_WORKOUT',
      );
    }
  }

  @override
  Future<void> deleteExercise({required int exerciseId}) async {
    try {
      final db = await database;

      final int rowsAffected = await db.delete(
        _tblExercises,
        where: 'exercise_id = ?',
        whereArgs: [exerciseId],
      );

      if (rowsAffected == 0) {
        throw DataBaseLocalException(
          message: 'Exercício não encontrado',
          technicalMessage: 'No exercise deleted with id=$exerciseId',
          code: 'SQLITE_DELETE_EXERCISE_NOT_FOUND',
        );
      }
    } on DataBaseLocalException {
      rethrow;
    } catch (e, s) {
      final technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao deletar o exercício',
        technicalMessage: technical,
        code: 'SQLITE_DELETE_EXERCISE',
      );
    }
  }


  @override
  Future<void> deleteWorkout({
    required int workoutId
  }) async {
    try {
      final db = await database;

      final int rowsAffected = await db.delete(
        _tblWorkouts,
        where: 'workout_id = ?',
        whereArgs: [workoutId]
      );

      if (rowsAffected == 0) {
        throw DataBaseLocalException(
          message: 'Treino não encontrado',
          technicalMessage: 'No workout deleted with id=$workoutId',
          code: 'SQLITE_DELETE_WORKOUT_NOT_FOUND',
        );
      }
    } on DataBaseLocalException {
      rethrow;
    } catch (e, s) {
      final String technical = '$e\n$s';

      throw DataBaseLocalException(
        message: 'Erro ao deletar o treino',
        technicalMessage: technical,
        code: 'SQLITE_DELETE_WORKOUT',
      );
    }
  }
}