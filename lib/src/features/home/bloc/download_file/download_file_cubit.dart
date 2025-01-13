import 'package:base_starter/src/features/home/domain/drive_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'download_file_state.dart';

class DownloadFileCubit extends Cubit<DownloadFileState> {
  DownloadFileCubit({
    required IDriveRepository repository,
  })  : _driveRepository = repository,
        super(const DownloadFileInitial());

  final IDriveRepository _driveRepository;

  Future<void> downloadFile({
    required String path,
  }) async {
    emit(const DownloadFileLoading());
    try {
      await _driveRepository.downloadFont(path);
      emit(const DownloadFileSuccess());
    } catch (e) {
      emit(DownloadFileError(error: e.toString()));
    }
  }
}
