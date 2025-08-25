import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../cubit/notes_cubit.dart';
import '../widgets/note_form.dart';

class NoteDetailPage extends StatelessWidget {
  final Note? note;

  const NoteDetailPage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'New Note' : 'Edit Note'),
        backgroundColor: Colors.blue,
      ),
      body: NoteForm(
        note: note,
        onSave: (title, content) {
          if (note == null) {
            context.read<NotesCubit>().addNote(title, content);
          } else {
            context.read<NotesCubit>().editNote(note!.id, title, content);
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
}