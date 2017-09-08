// Source - https://github.com/sethladd/dhttpd

// Copyright (c) 2014, Seth Ladd
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// * Neither the name of the {organization} nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library dhttpd;

import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_cors/shelf_cors.dart' as shelf_cors;
import 'package:path/path.dart' as p;

const int DEFAULT_PORT = 8080;
const String DEFAULT_HOST = 'localhost';

class Dhttpd {
  static Future<Dhttpd> start(
    {String path,
      int port: DEFAULT_PORT,
      String allowOrigin,
      address: DEFAULT_HOST}) async {
    if (path == null) path = Directory.current.path;

    path = p.normalize(path);

    final handler = createStaticHandler(path, defaultDocument: 'index.dart', serveFilesOutsidePath: true, listDirectories: true);

    final pipeline = const Pipeline().addMiddleware(logRequests());

    if (allowOrigin != null) {
      final corsHeaders = {'Access-Control-Allow-Origin': allowOrigin,};
      pipeline.addMiddleware(
        shelf_cors.createCorsHeadersMiddleware(corsHeaders: corsHeaders));
    }

    HttpServer server =
    await io.serve(pipeline.addHandler(handler), address, port);
    return new Dhttpd._(server, path);
  }

  final HttpServer _server;
  final String _path;

  Dhttpd._(this._server, this._path);

  String get host => _server.address.host;

  String get path => _path;

  int get port => _server.port;

  String get urlBase => 'http://${host}:${port}/';

  Future destroy() => _server.close();
}