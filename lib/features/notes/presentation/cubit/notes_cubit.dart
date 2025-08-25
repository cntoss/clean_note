import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/update_note.dart';

import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final GetNotes getNotes;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NotesCubit({
    required this.getNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NotesInitial());

  Future<void> loadNotes() async {
    emit(NotesLoading());

    final result = await getNotes(NoParams());

    result.fold(
      (failure) => emit(NotesError(message: _mapFailureToMessage(failure))),
      (notes) => emit(NotesLoaded(notes: notes)),
    );
  }

  Future<void> addNote(String title, String content) async {
    emit(NotesLoading());

    final result = await createNote(
      CreateNoteParams(title: title, content: content),
    );

    result.fold(
      (failure) => emit(NotesError(message: _mapFailureToMessage(failure))),
      (note) async {
        await loadNotes();
        emit(
          NoteOperationSuccess(
            message: 'Note created successfully',
            notes: (state is NotesLoaded) ? (state as NotesLoaded).notes : [],
          ),
        );
      },
    );
  }

  Future<void> editNote(String id, String title, String content) async {
    emit(NotesLoading());

    final result = await updateNote(
      UpdateNoteParams(id: id, title: title, content: content),
    );

    result.fold(
      (failure) => emit(NotesError(message: _mapFailureToMessage(failure))),
      (note) async {
        await loadNotes();
        emit(
          NoteOperationSuccess(
            message: 'Note updated successfully',
            notes: (state is NotesLoaded) ? (state as NotesLoaded).notes : [],
          ),
        );
      },
    );
  }

  Future<void> removeNote(String id) async {
    emit(NotesLoading());

    final result = await deleteNote(DeleteNoteParams(id: id));

    result.fold(
      (failure) => emit(NotesError(message: _mapFailureToMessage(failure))),
      (_) async {
        await loadNotes();
        emit(
          NoteOperationSuccess(
            message: 'Note deleted successfully',
            notes: (state is NotesLoaded) ? (state as NotesLoaded).notes : [],
          ),
        );
      },
    );
  }

  String _mapFailureToMessage(failure) {
    return failure.message ?? 'An unexpected error occurred';
  }
}
