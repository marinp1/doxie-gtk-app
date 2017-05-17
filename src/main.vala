using Gtk;

public class App : Gtk.Application {

    // Initiate application variables
    public Variables variables = new Variables ();

    // Initiate SSDP variables
    GSSDP.ResourceBrowser resource_browser;
    GSSDP.Client client;

    public App () {
        Object (application_id: "com.github.marinp1.doxie-gtk-app",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        
        // Main window for application
        ApplicationWindow window = new Gtk.ApplicationWindow (this);
        window.set_border_width (12);
        window.set_position (Gtk.WindowPosition.CENTER);
        window.set_default_size (800, 800);
        window.set_titlebar (new CustomHeaderBar ());

        // Application main layout (scan listing and action bar)
        // TODO: better variable name
        Box pane = new Box (Orientation.VERTICAL, 6);

        // Try to create a new SSDP client for device discovery
        try {
            GLib.MainContext ctx = GLib.MainContext.get_thread_default ();
            client = new GSSDP.Client (ctx, null);
        } catch (GLib.Error e) {
            print ("Couldn't create SSDP client. \n");
            print (e.message);
        }

        // Start listening to SSDP resources
        resource_browser = new GSSDP.ResourceBrowser (client, GSSDP.ALL_RESOURCES);
        resource_browser.resource_available.connect (device_found);
        resource_browser.set_active (true);

        // Layout containing all scan previews
        // TODO: change variable name
        // TODO: selection handles weirdly
        FlowBox layout = new FlowBox ();
        layout.set_valign (Align.START);
        layout.set_halign (Align.START);
        layout.activate_on_single_click = false;
        layout.column_spacing = 0;
        layout.row_spacing = 0;
        layout.set_selection_mode (SelectionMode.MULTIPLE);
        layout.homogeneous = true;

        // Generate test content
        // TODO: replace with content fetching from scanner with
        // HTTP get request
        var item_count = 6;
        for (int i = 0; i < item_count; i++) {
            var thumbnail = new Thumbnail ("/home/marinp1/Repositories/gtk-doxie-app/src/demo1.jpg");
            layout.insert (thumbnail, 0);
        }

        // Add scan list to a vertically scrolling window
        ScrolledWindow scrolled = new ScrolledWindow (null, null);
        scrolled.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        scrolled.add (layout);

        // Add all content to main layout
        pane.pack_start (scrolled, true, true, 0);
        pane.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);
        pane.pack_start (new ActionBar (this), false, false, 0);

        // Add main layout to window and display it
        window.add (pane);
        window.show_all ();

    }

    // On new SSDP device discovery
    public void device_found (string usn, GLib.List<string> locations) {

        // Check if device mathes Doxie's URN scheme
        if (usn.index_of ("urn:schemas-getdoxie-com:device:Scanner") != -1) {

            // Parse host from full URL
            string full_uri = locations.nth (0).data;
            Soup.URI parsed_uri = new Soup.URI (full_uri);
            string ip_address = parsed_uri.get_host ();

            // Generate new Doxie instance and add it to list
            DoxieScanner scanner = new DoxieScanner (ip_address);
            variables.scanner_list.set (ip_address, scanner);

            if (variables.selected_scanner == null) {
                select_doxie (scanner);
            }

        }

    }

    // Sets doxie selection and saves password for the future
    public bool select_doxie (DoxieScanner scanner) {

        if (scanner.password_protected) {
            // TODO: check password validity
            // TODO: prompt for password if invalid
        }

        variables.selected_scanner = scanner;

        return true;
    }

    public static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }

}