import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel> createNote(String title, String content);
  Future<NoteModel> updateNote(String id, String title, String content);
  Future<void> deleteNote(String id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final Dio dio;

  NoteRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final response = await dio.get(
        '${Constants.baseUrl}${Constants.notesEndpoint}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NoteModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch notes');
      }
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<NoteModel> createNote(String title, String content) async {
    try {
      final response = await dio.post(
        '${Constants.baseUrl}${Constants.notesEndpoint}',
        data: {'title': title, 'content': content},
      );

      if (response.statusCode == 201) {
        return NoteModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create note');
      }
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<NoteModel> updateNote(String id, String title, String content) async {
    try {
      final response = await dio.put(
        '${Constants.baseUrl}${Constants.notesEndpoint}/$id',
        data: {'title': title, 'content': content},
      );

      if (response.statusCode == 200) {
        return NoteModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to update note');
      }
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final response = await dio.delete(
        '${Constants.baseUrl}${Constants.notesEndpoint}/$id',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete note');
      }
    } on DioException catch (e) {
      throw ServerException(_handleDioError(e));
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      default:
        return 'Network error';
    }
  }
}
