class NativeHashService {
  static final NativeHashService _instance = NativeHashService._internal();
  factory NativeHashService() => _instance;

  NativeHashService._internal();

  String? getFileHash(String filePath, {int algorithm = 0}) {
    return null;
  }

  bool preAllocateDisk(String filePath, int size) {
    return true;
  }
}
