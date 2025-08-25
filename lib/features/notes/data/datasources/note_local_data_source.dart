import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getCachedNotes();
  Future<void> cacheNotes(List<NoteModel> notes);
  Future<void> cacheNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  late Box<NoteModel> _notesBox;

  NoteLocalDataSourceImpl() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteModelAdapter());
    }
    _notesBox = await Hive.openBox<NoteModel>(Constants.notesBoxName);
  }

  @override
  Future<List<NoteModel>> getCachedNotes() async {
    try {
      await _initHive();
      return _notesBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get cached notes: $e');
    }
  }

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    try {
      await _initHive();
      await _notesBox.clear();
      for (var note in notes) {
        await _notesBox.put(note.id, note);
      }
    } catch (e) {
      throw CacheException('Failed to cache notes: $e');
    }
  }

  @override
  Future<void> cacheNote(NoteModel note) async {
    try {
      await _initHive();
      await _notesBox.put(note.id, note);
    } catch (e) {
      throw CacheException('Failed to cache note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _initHive();
      await _notesBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete note: $e');
    }
  }
}
