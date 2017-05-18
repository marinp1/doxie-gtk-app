# Doxie WiFi Sync
Unofficial GTK application for fetching scans from Doxie WiFi scanners with an easy-to-use UI. Basically acts as a wrapper for [Doxie's API](http://help.getdoxie.com/content/doxiego/05-advanced/03-wifi/04-api/Doxie-API-Developer-Guide.pdf), but will also similar features as in Doxie's official application such as OCR and scan pre-processing.

## Installation

PPA is available for Ubuntu 16.04

1. sudo add-apt-repository ppa:patrik-marin/ppa
2. sudo apt-get update
3. sudo apt-get install gtk-doxie-app

## Manual installation

For manual installation some dependencies are required.

#### Required dependencies
- cmake
- valac
- libgtk-3-dev
- libgranite-dev
- libgssdp-1.0-dev
- libsoup2.4-dev
- libjson-glib-dev

#### Installation steps

1. git clone https://github.com/marinp1/doxie-gtk-app.git
2. cd doxie-gtk-app
3. mkdir build && cd build
5. cmake -DCMAKE_INSTALL_PREFIX=/usr ../
6. make && make install
