import 'package:base_starter/src/features/home/data/models/storage_file.dart';
import 'package:flutter/foundation.dart';

final class FilesController extends ChangeNotifier {
  StorageFile? _selectedCategory;
  StorageFile? get selectedCategory => _selectedCategory;
  set selectedCategory(StorageFile? value) {
    _selectedCategory = value;
    notifyListeners();
  }
}
