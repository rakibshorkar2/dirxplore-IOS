import 'dart:typed_data';

abstract class CppNativeIOInterface {
  bool writeChunk(String targetPath, Uint8List data, int offset);
}
