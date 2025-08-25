# clean_note

A new Flutter project.

## Setup Instructions:

1. **Create the folder structure** as shown in the file tree below
2. **Generate Hive adapters** by running:
   ```bash
   flutter packages pub run build_runner build
   ```
3. **Get dependencies**:
   ```bash
   flutter pub get
   ```

## Key Features:

✅ **Clean Architecture** with proper layer separation
✅ **Cubit State Management** with BLoC pattern
✅ **Dio HTTP Client** with proper error handling
✅ **Either/Left/Right** pattern for error handling
✅ **Hive Local Storage** for offline functionality
✅ **CRUD Operations** (Create, Read, Update, Delete)
✅ **Dependency Injection** with GetIt
✅ **Network-aware** caching strategy
✅ **Material Design UI** with proper loading states

The app will work offline and sync when network is available. All error states are properly handled with user-friendly messages.

## Folder Structure

    clean_note/
    ├── lib/
    │   ├── main.dart
    │   ├── injection_container.dart
    │   ├── core/
    │   │   ├── error/
    │   │   │   ├── failures.dart
    │   │   │   └── exceptions.dart
    │   │   ├── network/
    │   │   │   └── network_info.dart
    │   │   ├── usecases/
    │   │   │   └── usecase.dart
    │   │   └── utils/
    │   │       └── constants.dart
    │   └── features/
    │       └── notes/
    │           ├── data/
    │           │   ├── datasources/
    │           │   │   ├── note_local_data_source.dart
    │           │   │   └── note_remote_data_source.dart
    │           │   ├── models/
    │           │   │   └── note_model.dart
    │           │   └── repositories/
    │           │       └── note_repository_impl.dart
    │           ├── domain/
    │           │   ├── entities/
    │           │   │   └── note.dart
    │           │   ├── repositories/
    │           │   │   └── note_repository.dart
    │           │   └── usecases/
    │           │       ├── get_notes.dart
    │           │       ├── create_note.dart
    │           │       ├── update_note.dart
    │           │       └── delete_note.dart
    │           └── presentation/
    │               ├── cubit/
    │               │   ├── notes_cubit.dart
    │               │   └── notes_state.dart
    │               ├── pages/
    │               │   ├── notes_page.dart
    │               │   └── note_detail_page.dart
    │               └── widgets/
    │                   ├── note_card.dart
    │                   └── note_form.dart
    └── pubspec.yaml