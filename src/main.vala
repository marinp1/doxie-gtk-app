using Gtk;

// Loop through location, valid location is http://192.168.1.100:8080/doxie/document
// Or look for USN type uuid:16FAB4C8-1DD2-11B2-B86C-796C3CACE9D9::urn:schemas-getdoxie-com:device:Scanner:1
void device_found (string usn, GLib.List<string> locations) {
  print (usn + "\n");
}

void device_lost (string usn) {
  print (usn + "\n");
}

int main (string[] args) {
    init (ref args);

    Window window = new Gtk.Window ();
    window.title = "Doxie Go WiFi Sync";
    window.set_border_width (12);
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (1280, 720);
    window.destroy.connect (Gtk.main_quit);

    window.set_titlebar (new CustomHeaderBar ());

    Box pane = new Box (Orientation.VERTICAL, 12);

    GSSDP.Client client = null;

    try {
      GLib.MainContext ctx = GLib.MainContext.get_thread_default ();
      client = new GSSDP.Client (ctx, null);
    } catch (GLib.Error e) {
      print (e.message);
    }

    GSSDP.ResourceBrowser resource_browser = new GSSDP.ResourceBrowser (client, GSSDP.ALL_RESOURCES);
    resource_browser.resource_available.connect (device_found);
    resource_browser.resource_unavailable.connect (device_lost);

    resource_browser.set_active (true);


    ScrolledWindow scrolled = new ScrolledWindow (null, null);
    scrolled.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);

    FlowBox layout = new FlowBox ();
    layout.set_valign (Align.START);
    layout.column_spacing = 20;
    layout.row_spacing = 20;
    layout.set_selection_mode (SelectionMode.NONE);
    layout.homogeneous = false;

    var item_count = 6;

    for (int i = 0; i < item_count; i++) {
        var thumbnail = new Thumbnail ("/home/marinp1/Repositories/gtk-doxie-app/src/demo1.jpg");
        layout.insert (thumbnail, 0);
    }

    pane.pack_start (scrolled, true, true, 0);
    pane.pack_start (new ActionBar (), false, false, 0);

    scrolled.add (layout);
    window.add (pane);
    window.show_all ();
    Gtk.main ();
    return 0;

 }
