using Gtk;

public class App : Granite.Application {

    Variables variables = new Variables ();
    GSSDP.ResourceBrowser resource_browser;
    GSSDP.Client client;

    public App () {
        Object (application_id: "com.github.marinp1.doxie-gtk-app",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        
        Window window = new Gtk.ApplicationWindow (this);
        window.title = "Doxie Go WiFi Sync";
        window.set_border_width (12);
        window.set_position (Gtk.WindowPosition.CENTER);
        window.set_default_size (800, 800);
        window.set_titlebar (new CustomHeaderBar ());

        Box pane = new Box (Orientation.VERTICAL, 6);

        try {
          GLib.MainContext ctx = GLib.MainContext.get_thread_default ();
          client = new GSSDP.Client (ctx, null);
        } catch (GLib.Error e) {
          print (e.message);
        }

        resource_browser = new GSSDP.ResourceBrowser (client, GSSDP.ALL_RESOURCES);
        resource_browser.resource_available.connect (device_found);
        resource_browser.set_active (true);

        ScrolledWindow scrolled = new ScrolledWindow (null, null);
        scrolled.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);

        FlowBox layout = new FlowBox ();
        layout.set_valign (Align.START);
        layout.activate_on_single_click = false;
        layout.column_spacing = 0;
        layout.row_spacing = 0;
        layout.set_selection_mode (SelectionMode.MULTIPLE);
        layout.homogeneous = false;

        var item_count = 6;

        for (int i = 0; i < item_count; i++) {
            var thumbnail = new Thumbnail ("/home/marinp1/Repositories/gtk-doxie-app/src/demo1.jpg");
            layout.insert (thumbnail, 0);
        }

        pane.pack_start (scrolled, true, true, 0);
        pane.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);
        pane.pack_start (new ActionBar (), false, false, 0);

        scrolled.add (layout);
        window.add (pane);
        window.show_all ();

    }

    public void device_found (string usn, GLib.List<string> locations) {
      if (usn.index_of ("urn:schemas-getdoxie-com:device:Scanner") != -1) {

        string full_uri = locations.nth (0).data;
        Soup.URI parsed_uri = new Soup.URI (full_uri);
        string ip_address = parsed_uri.get_host ();

        DoxieScanner scanner = new DoxieScanner (ip_address);

        print ("Scanner found at " + ip_address + "\n");

      }

    }

    public static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }

}