import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import '../services/platform_utils.dart';

typedef GetFileHashC = ffi.Int32 Function(ffi.Pointer<Utf8> filePath,
    ffi.Pointer<Utf8> hashResult, ffi.Int32 algorithm);
typedef GetFileHashDart = int Function(
    ffi.Pointer<Utf8> filePath, ffi.Pointer<Utf8> hashResult, int algorithm);

typedef PreAllocateDiskC = ffi.Int32 Function(
    ffi.Pointer<Utf8> filePath, ffi.Int64 size);
typedef PreAllocateDiskDart = int Function(
    ffi.Pointer<Utf8> filePath, int size);

class NativeHashService {
  static final NativeHashService _instance = NativeHashService._internal();
  factory NativeHashService() => _instance;

  late ffi.DynamicLibrary _lib;
  late GetFileHashDart _getHashFunc;
  late PreAllocateDiskDart _preAllocateFunc;
  bool _hasNativeLib = false;

  NativeHashService._internal() {
    _loadLibrary();
  }

  void _loadLibrary() {
    if (PlatformUtils.isWeb) return;

    if (PlatformUtils.isAndroid) {
      try {
        _lib = ffi.DynamicLibrary.open('libnative_io.so');
        _getHashFunc =
            _lib.lookupFunction<GetFileHashC, GetFileHashDart>('GetFileHash');
        _preAllocateFunc =
            _lib.lookupFunction<PreAllocateDiskC, PreAllocateDiskDart>(
                'PreAllocateDisk');
        _hasNativeLib = true;
      } catch (e) {
        _hasNativeLib = false;
      }
    }
  }

  String? getFileHash(String filePath, {int algorithm = 0}) {
    if (!_hasNativeLib) return null;

    final filePathPtr = filePath.toNativeUtf8();
    final hashResultPtr = malloc.allocate<Utf8>(256);

    try {
      final result = _getHashFunc(filePathPtr, hashResultPtr, algorithm);
      if (result == 1) {
        return hashResultPtr.toDartString();
      }
      return null;
    } finally {
      malloc.free(filePathPtr);
      malloc.free(hashResultPtr);
    }
  }

  bool preAllocateDisk(String filePath, int size) {
    if (!_hasNativeLib) return true; // Pretend it worked for dev

    final filePathPtr = filePath.toNativeUtf8();
    try {
      return _preAllocateFunc(filePathPtr, size) == 1;
    } finally {
      malloc.free(filePathPtr);
    }
  }
}
