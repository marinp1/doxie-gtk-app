# Doxie WiFi Sync
Unofficial GTK application for fetching scans from Doxie WiFi scanners with an easy-to-use UI. Basically acts as a wrapper for [Doxie's API](http://help.getdoxie.com/content/doxiego/05-advanced/03-wifi/04-api/Doxie-API-Developer-Guide.pdf), but will also similar features as in Doxie's official application such as OCR and scan pre-processing.

## Manual installation

For manual installation some dependencies are required and [gssdp](https://wiki.gnome.org/Projects/GUPnP) must be built from the source.

#### Required dependencies
- granite
- gssdp
- gtk+-3.0
- json-glib-1.0
- libsoup-2.4

#### Installation steps

1. git clone https://github.com/marinp1/doxie-gtk-app.git
2. cd doxie-gtk-app
3. mkdir build && cd build
5. cmake -DCMAKE_INSTALL_PREFIX=/usr ../
6. make && make install
