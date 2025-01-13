import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:flutter/foundation.dart';

final class FilesController extends ChangeNotifier {
  List<StorageFile> _files = [];
  List<StorageFile> get files => _files;
  set files(List<StorageFile> value) {
    _files = value;
    notifyListeners();
  }

  void addFile(StorageFile file) {
    _files.add(file);
    notifyListeners();
  }

  void addAllFiles(List<StorageFile> files) {
    _files.addAll(files);
    notifyListeners();
  }

  void removeFile(StorageFile file) {
    _files.remove(file);
    notifyListeners();
  }

  void clearFiles() {
    _files.clear();
    notifyListeners();
  }

  StorageFile? _selectedCategory;
  StorageFile? get selectedCategory => _selectedCategory;
  set selectedCategory(StorageFile? value) {
    _selectedCategory = value;
    notifyListeners();
  }
}
