import 'package:flutter/foundation.dart';
import 'package:hygi_health/common/globally.dart';

import '../data/model/slob_model.dart';


class SlobViewModel extends ChangeNotifier {

  List<Slob> _slobs = [];
  bool _isLoading = false;

  List<Slob> get slobs => _slobs;
  bool get isLoading => _isLoading;

  Future<void> fetchSlobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _slobs = await authService.fetchSlobs();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching Slobs: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
