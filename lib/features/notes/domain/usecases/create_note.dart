import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class CreateNote implements UseCase<Note, CreateNoteParams> {
  final NoteRepository repository;

  CreateNote(this.repository);

  @override
  Future<Either<Failure, Note>> call(CreateNoteParams params) async {
    return await repository.createNote(params.title, params.content);
  }
}

class CreateNoteParams extends Equatable {
  final String title;
  final String content;

  const CreateNoteParams({required this.title, required this.content});

  @override
  List<Object?> get props => [title, content];
}
