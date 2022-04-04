import 'dart:developer' as developer;
import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;

import 'package:benchmarking/benchmarking.dart';
import 'package:path/path.dart' as path;

import 'lib/http-server/http_server.dart';
import 'lib/nbody/nbody.dart';
import 'lib/spectral-norm/spectral_norm.dart';

typedef run_func = ffi.Void Function();
typedef Run = void Function();

main(List<String> arguments) async {
  final hello_lib =
      ffi.DynamicLibrary.open(path.join(Directory.current.path, "nbody.dll"));
  final Run hello =
      hello_lib.lookup<ffi.NativeFunction<run_func>>('run').asFunction();

  final http_lib = ffi.DynamicLibrary.open(
      path.join(Directory.current.path, "libhttp-server.dll"));
  final Run http =
      http_lib.lookup<ffi.NativeFunction<run_func>>('run').asFunction();

  final spectral_lib = ffi.DynamicLibrary.open(
      path.join(Directory.current.path, "spectral-norm.dll"));

  final Run spectral =
      spectral_lib.lookup<ffi.NativeFunction<run_func>>('run').asFunction();

  devToolsPostEvent("Dart nbody", {'start': true});
  syncBenchmark('Dart nbody', () => nbodyRun()).report();
  devToolsPostEvent("Dart nbody", {'start': false});

  devToolsPostEvent("C nbody", {'start': true});
  syncBenchmark('C nbody', () => hello()).report();
  devToolsPostEvent("C nbody", {'start': true});
  (await asyncBenchmark('Dart HTTP Server', () async => await httpServerRun(),
          settings: BenchmarkSettings(
            minimumRunTime: Duration(milliseconds: 500),
          )))
      .report();
  syncBenchmark('C http-server', () => http()).report();

  syncBenchmark('Dart spectral-norm', () => spectralRun()).report();
  syncBenchmark('C spectral-norm', () => spectral()).report();
}

void devToolsPostEvent(String eventName, Map<String, Object> eventData) {
  developer.postEvent('DevTools.Event_$eventName', eventData);
}
