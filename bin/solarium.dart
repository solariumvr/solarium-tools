// Copyright (c) 2017, Michael. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:solarium_tools/solarium_tools.dart';
import 'package:args/args.dart';
import '_serve.dart';

main(List<String> arguments) {
  var parser = new ArgParser();
  var serve_parser = parser.addCommand("serve");
  serve_parser
    ..addOption('port',
        abbr: 'p',
        defaultsTo: DEFAULT_PORT.toString(),
        valueHelp: 'port',
        help: 'The port to listen on.')
    ..addOption('path',
        valueHelp: 'path', help: 'The path to serve (defaults to the cwd).')
    ..addOption('host',
        defaultsTo: DEFAULT_HOST.toString(),
        valueHelp: 'host',
        help: 'The hostname to listen on (defaults to "localhost").')
    ..addOption('allow-origin',
        valueHelp: 'allow-origin',
        help: "The value for the 'Access-Control-Allow-Origin' header.")
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Displays the help.');

  var results = parser.parse(arguments);
  if (results.command.name == "serve") {
    bootServer(results.command);
  }
}
