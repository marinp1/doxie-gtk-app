 int main(string[] args) {
    Gtk.init(ref args);

    var window = new Gtk.Window();
    window.title = "Doxie Go WiFi Sync";
    window.set_border_width(30);
    window.set_position(Gtk.WindowPosition.CENTER);
    window.set_default_size(1280, 720);
    window.destroy.connect(Gtk.main_quit);

    var layout = new Gtk.FlowBox();
    layout.column_spacing = 20;
    layout.row_spacing = 20;

    var item_count = 12;

    for (int i = 0; i < item_count; i++) {
        string n = (i + 1).to_string();
        var thumbnail = new Gtk.Button.with_label("Thumbnail " + n);
        layout.insert(thumbnail, i);
    }

    window.add(layout);
    window.show_all();

    Gtk.main();
    return 0;

 }
