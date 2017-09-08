# solarium_tools

A command-line application with support tools for SolariumVR.

## Install

Use the `pub global` command to install this into your system.

    $ pub global activate solarium_tools

## Commands

`solarium serve`

Runs a simple http server. The default document is `index.dart`

* `--port` - Set the port. Defaults to 8080.
* `--path` - Set the path to serve. Defaults to cwd.
* `--host` - Hostname to listen on. Defaults to localhost.
* `--allow-origin` - Value for the 'Access-Control-Allow-Origin' header.

