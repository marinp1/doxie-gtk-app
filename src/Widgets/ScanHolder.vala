using Gtk;

public class ScanHolder : FlowBox {

    private const string scanholder_style = """

        .scan {
            border-radius: 0;
            border: 1px solid #e1e1e1;
            background-color: alpha(#e1e1e1, 0.25);
        }

        .scan:focus {
            background-color: transparent;
        }

        .scan:selected {
            background-color: alpha(#00d050, 0.25);
        }

    """;

    App app;
    public static weak ScanHolder instance;

    private Gee.ArrayList<string> scan_list;

    public int get_scan_count () {
        return scan_list.size;
    }

    public ScanHolder (App main_app) {
        app = main_app;

        this.set_valign (Align.START);
        this.set_halign (Align.START);
        this.activate_on_single_click = false;
        this.column_spacing = 12;
        this.row_spacing = 12;
        this.set_selection_mode (SelectionMode.MULTIPLE);
        this.homogeneous = true;

        this.margin_top = 12;
        this.margin_right = 12;
        this.margin_left = 12;

        scan_list = new Gee.ArrayList<string> ();

        instance = this;

        this.selected_children_changed.connect (() => {
            app.variables.reset_selected_items (this.get_selected_children ());
            ActionBar.instance.update_export_content (this.get_selected_children ().length ());
        });

    }

    // Generate test content
    // TODO: replace with content fetching from scanner with
    // HTTP get request
    public bool refresh_content () {

        scan_list.clear ();

        string thumbnail_location = GLib.Environment.get_tmp_dir () + "/.com.github.marinp1/gtk-doxie-app/thumbnails";

        try {

            Dir thumbnail_directory = Dir.open (thumbnail_location, 0);
            string? thumbnail_name = null;

            while ((thumbnail_name = thumbnail_directory.read_name ()) != null) {

                string thumbnail_path = Path.build_filename (thumbnail_location, thumbnail_name);
                scan_list.add (thumbnail_path);

            }

        } catch (FileError e) {
            
            print (e.message);
        
        }

        this.foreach((child) => {
            child.destroy ();
        });

        foreach (string scan_path in scan_list) {
            var thumbnail = new Thumbnail (scan_path);
            this.insert (thumbnail, -1);
            // Apply custom styling to FlowBoxChild
            thumbnail.parent.get_style_context ().add_class ("scan");
            Granite.Widgets.Utils.set_theming (thumbnail.parent, scanholder_style, "scan", Gtk.STYLE_PROVIDER_PRIORITY_USER);
        };

        if (scan_list.size == 0) {
            app.switch_content (App.CONTENT_TYPE.NO_SCANS);
        } else {
            app.switch_content (App.CONTENT_TYPE.SCAN_LIST);
        }

        // Unselect all children
        this.unselect_all ();

        this.show_all ();

        return true;

    }

}