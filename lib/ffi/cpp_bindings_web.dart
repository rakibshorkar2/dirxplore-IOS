import 'dart:typed_data';
import 'cpp_native_io_interface.dart';

class CppNativeIO implements CppNativeIOInterface {
  static final CppNativeIO _instance = CppNativeIO._internal();
  factory CppNativeIO() => _instance;

  CppNativeIO._internal();

  @override
  bool writeChunk(String targetPath, Uint8List data, int offset) {
    // On Web, native chunk writing is not supported.
    // DownloadProvider should use standard Dio.download or other methods.
    return false;
  }
}
