using Gtk;

public class App : Granite.Application {

    // Initiate application variables
    public Variables variables = new Variables ();

    // Initiate SSDP variables
    GSSDP.ResourceBrowser resource_browser;
    GSSDP.Client client;

    public enum CONTENT_TYPE {
        SCAN_LIST,
        NO_SCANS,
        NO_CONNECTION
    }

    private Gtk.Stack content_stack;

    public void switch_content (CONTENT_TYPE content_request) {

        if (content_stack.get_visible_child () == null) {
            return;
        }

        if (content_request == CONTENT_TYPE.SCAN_LIST) {

            content_stack.visible_child_name = "content";

        } else if (content_request == CONTENT_TYPE.NO_SCANS) {

            ContentPlaceholder.change_to_no_scans_template ();
            content_stack.visible_child_name = "placeholder";

        } else if (content_request == CONTENT_TYPE.NO_CONNECTION) {

            ContentPlaceholder.change_to_no_connection_template ();
            content_stack.visible_child_name = "placeholder";

        }

    }

    private const string stylesheet = """

        .content_stack {
            background: #fff;
        }

    """;

    public App () {
        Object (application_id: "com.github.marinp1.doxie-gtk-app",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {

        // Main window for application
        Gtk.ApplicationWindow main_window = new Gtk.ApplicationWindow (this);
        main_window.set_border_width (0);
        main_window.set_position (Gtk.WindowPosition.CENTER);
        main_window.set_default_size (800, 800);
        main_window.set_size_request(800, 500);

        // Application main layout (scan listing and action bar)
        // TODO: better variable name
        Box pane = new Box (Orientation.VERTICAL, 0);

        // Try to create a new SSDP client for device discovery
        try {
            GLib.MainContext ctx = GLib.MainContext.get_thread_default ();
            client = new GSSDP.Client (ctx, null);
        } catch (GLib.Error e) {
            print (_("Couldn't create SSDP client. \n"));
            print (e.message);
        }

        // Start listening to SSDP resources
        resource_browser = new GSSDP.ResourceBrowser (client, GSSDP.ALL_RESOURCES);
        resource_browser.resource_available.connect (device_found);
        resource_browser.set_active (true);

        // Content stack
        content_stack = new Gtk.Stack ();
        content_stack.get_style_context ().add_class ("content_stack");
        Granite.Widgets.Utils.set_theming (content_stack, stylesheet, "content_stack", Gtk.STYLE_PROVIDER_PRIORITY_USER);

        // Initiate content placeholder
        ContentPlaceholder content_placeholder = new ContentPlaceholder ();
        ContentPlaceholder.change_to_no_connection_template ();

        // Layout containing all scan previews
        ScanHolder scan_holder = new ScanHolder (this);

        // Add scan list to a vertically scrolling window
        ScrolledWindow scrolled = new ScrolledWindow (null, null);
        scrolled.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        scrolled.add (scan_holder);

        // Add elements to content stack
        content_stack.add_named (content_placeholder, "placeholder");
        content_stack.add_named (scrolled, "content");

        Gtk.Separator separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        separator.margin_bottom = 12;

        // Add all content to main layout
        pane.pack_start (content_stack, true, true, 0);
        pane.pack_start (separator, false, false, 0);
        pane.pack_start (new ActionBar (this), false, false, 0);

        main_window.set_titlebar (new CustomHeader (this));

        // Add main layout to window and display it
        main_window.add (pane);
        main_window.show_all ();

    }

    // On new SSDP device discovery
    public void device_found (string usn, GLib.List<string> locations) {

        // Check if device mathes Doxie's URN scheme
        if (usn.index_of ("urn:schemas-getdoxie-com:device:Scanner") != -1) {

            // Parse host from full URL
            string full_uri = locations.nth (0).data;
            Soup.URI parsed_uri = new Soup.URI (full_uri);
            string ip_address = parsed_uri.get_host ();

            DoxieScannerUtils.add_scanner (ip_address);

        }

    }

    public static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }

}