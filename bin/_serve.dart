import 'dart:io';
import 'package:args/args.dart';
import 'package:solarium_tools/dhttpd.dart';

bootServer(ArgResults results) async {

  var port = int.parse(results['port'], onError: (source) {
    stderr.writeln('port must be a number');
    exit(1);
  });

  var hostname = results['host'];

  String path =
  results['path'] != null ? results['path'] : Directory.current.path;

  await Dhttpd.start(
    path: path,
    port: port,
    allowOrigin: results['allow-origin'],
    address: hostname);

  print('Server started on port $port');
}