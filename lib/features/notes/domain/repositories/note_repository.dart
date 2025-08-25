import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Note>> createNote(String title, String content);
  Future<Either<Failure, Note>> updateNote(
    String id,
    String title,
    String content,
  );
  Future<Either<Failure, void>> deleteNote(String id);
}
