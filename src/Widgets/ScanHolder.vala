using Gtk;

class ScanHolder : FlowBox {

    private static weak ScanHolder instance;

    Gee.ArrayList<string> scan_list;

    public ScanHolder () {

        this.set_valign (Align.START);
        this.set_halign (Align.START);
        this.activate_on_single_click = false;
        this.column_spacing = 12;
        this.row_spacing = 12;
        this.set_selection_mode (SelectionMode.MULTIPLE);
        this.homogeneous = true;

        this.margin_top = 12;
        this.margin_end = 12;
        this.margin_start = 12;

        scan_list = new Gee.ArrayList<string> ();

        instance = this;

        this.selected_children_changed.connect (() => {
            Variables.instance.reset_selected_items (this.get_selected_children ());
            ActionBar.update_export_content (this.get_selected_children ().length ());
        });

    }

    // Generate test content
    // TODO: replace with content fetching from scanner with
    // HTTP get request
    public static bool refresh_thumbnails () {

        instance.scan_list.clear ();

        try {

            Dir thumbnail_directory = Dir.open (Variables.THUMBNAIL_LOCATION, 0);
            string? thumbnail_name = null;

            while ((thumbnail_name = thumbnail_directory.read_name ()) != null) {

                string thumbnail_path = Path.build_filename (Variables.THUMBNAIL_LOCATION, thumbnail_name);
                instance.scan_list.add (thumbnail_path);

            }

        } catch (FileError e) {
            print (e.message + "\n");
        }

        // Remove old elements
        foreach (Gtk.Widget child in instance.get_children ()) {
            child.destroy ();
        };

        // Create new element from thumbnail file path
        foreach (string scan_path in instance.scan_list) {
            var thumbnail = new Thumbnail (scan_path);
            instance.insert (thumbnail, -1);
            // Apply custom styling to FlowBoxChild
            thumbnail.parent.get_style_context ().add_class ("scan");
            Granite.Widgets.Utils.set_theming (thumbnail.parent, Styles.main_style, "scan", Gtk.STYLE_PROVIDER_PRIORITY_USER);
        };

        // If no scans were found, display placeholder
        if (instance.scan_list.size == 0) {
            ContentStack.switch_content (ContentStack.CONTENT_TYPE.NO_SCANS);
        } else {
            ContentStack.switch_content (ContentStack.CONTENT_TYPE.SCAN_LIST);
        }

        // Unselect all children
        instance.unselect_all ();
        instance.show_all ();

        return true;

    }

}