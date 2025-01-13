import 'package:base_starter/src/features/home/data/models/pagination_files.dart';
import 'package:base_starter/src/features/home/domain/drive_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drive_files_event.dart';
part 'drive_files_state.dart';

class DriveFilesBloc extends Bloc<DriveFilesEvent, DriveFilesState> {
  DriveFilesBloc({
    required IDriveRepository driveRepository,
  })  : _driveRepository = driveRepository,
        super(const DriveFilesInitial()) {
    on<DriveFilesEvent>(
      (event, emit) => switch (event) {
        final LoadDriveFiles e => _getFiles(e, emit),
      },
    );
  }

  final IDriveRepository _driveRepository;

  Future<void> _getFiles(
    LoadDriveFiles event,
    Emitter<DriveFilesState> emit,
  ) async {
    emit(const DriveFilesLoading());

    try {
      final pagination = await _driveRepository.getFiles(
        path: event.path,
        pageToken: event.pageToken,
      );

      emit(DriveFilesLoaded(pagination: pagination));
    } catch (e) {
      emit(DriveFilesError(message: e.toString()));
      rethrow;
    }
  }
}
