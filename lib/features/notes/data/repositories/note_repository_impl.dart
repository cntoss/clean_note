import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';
import '../datasources/note_remote_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;
  final NoteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NoteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNotes = await remoteDataSource.getNotes();
        await localDataSource.cacheNotes(remoteNotes);
        return Right(remoteNotes.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localNotes = await localDataSource.getCachedNotes();
        return Right(localNotes.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(String title, String content) async {
    if (await networkInfo.isConnected) {
      try {
        final noteModel = await remoteDataSource.createNote(title, content);
        await localDataSource.cacheNote(noteModel);
        return Right(noteModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      // Create offline note
      final now = DateTime.now();
      final noteModel = NoteModel(
        id: now.millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await localDataSource.cacheNote(noteModel);
        return Right(noteModel.toEntity());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(
    String id,
    String title,
    String content,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final noteModel = await remoteDataSource.updateNote(id, title, content);
        await localDataSource.cacheNote(noteModel);
        return Right(noteModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      // Update offline note
      try {
        final cachedNotes = await localDataSource.getCachedNotes();
        final existingNote = cachedNotes.firstWhere((note) => note.id == id);

        final updatedNote = NoteModel(
          id: existingNote.id,
          title: title,
          content: content,
          createdAt: existingNote.createdAt,
          updatedAt: DateTime.now(),
        );

        await localDataSource.cacheNote(updatedNote);
        return Right(updatedNote.toEntity());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteNote(id);
        await localDataSource.deleteNote(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        await localDataSource.deleteNote(id);
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
