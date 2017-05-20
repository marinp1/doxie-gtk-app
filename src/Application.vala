using Gtk;

public class App : Granite.Application {

    public static weak App instance;

    // Initiate application variables
    public Variables variables = new Variables ();

    public Gtk.ApplicationWindow main_window;

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
        main_window = new Gtk.ApplicationWindow (this);
        main_window.set_border_width (0);
        main_window.set_position (Gtk.WindowPosition.CENTER);
        main_window.set_default_size (800, 800);
        main_window.set_size_request(800, 500);

        // Application main layout (scan listing and action bar)
        // TODO: better variable name
        Box pane = new Box (Orientation.VERTICAL, 0);

        // Content stack
        ContentStack content_stack = new ContentStack ();
        content_stack.get_style_context ().add_class ("content_stack");
        Granite.Widgets.Utils.set_theming (content_stack, stylesheet, "content_stack", Gtk.STYLE_PROVIDER_PRIORITY_USER);

        // Initiate content placeholder
        ContentPlaceholder content_placeholder = new ContentPlaceholder ();
        ContentPlaceholder.change_to_no_connection_template ();

        // Layout containing all scan previews
        ScanHolder scan_holder = new ScanHolder ();

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
        pane.pack_start (new ActionBar (), false, false, 0);

        CustomHeader title_bar = new CustomHeader (); 
        main_window.set_titlebar (title_bar);

        // Add main layout to window and display it
        main_window.add (pane);
        main_window.show_all ();

        instance = this;

        init ();

    }

    private void init () {
        CustomHeader.check_sensitivity ();
        GssdpUtils.initialise ();
    }

    public static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }

}