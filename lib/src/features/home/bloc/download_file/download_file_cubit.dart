import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'download_file_state.dart';

class DownloadFileCubit extends Cubit<DownloadFileState> {
  DownloadFileCubit() : super(const DownloadFileInitial());

  Future<void> downloadFile({
    required String id,
  }) async {
    emit(const DownloadFileLoading());
    try {
      // final url = Supabase.instance.client.storage
      //     .from('fonts')
      //     .getPublicUrl('$category/$path');
      // await launchUrl(Uri.parse(url));
      emit(const DownloadFileSuccess());
    } catch (e) {
      emit(DownloadFileError(error: e.toString()));
    }
  }
}