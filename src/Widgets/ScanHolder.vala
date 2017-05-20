using Gtk;

public class ScanHolder : FlowBox {

    private const string scanholder_style = """

        .scan:focus {
            background-color: transparent;
        }

        .scan:selected {
            background-color: alpha(#3399ff, 0.4);
        }

    """;

    App app;
    public static weak ScanHolder instance;

    public ScanHolder (App main_app) {
        app = main_app;

        this.set_valign (Align.START);
        this.set_halign (Align.START);
        this.activate_on_single_click = false;
        this.column_spacing = 6;
        this.row_spacing = 6;
        this.set_selection_mode (SelectionMode.MULTIPLE);
        this.homogeneous = true;

        this.margin_top = 12;
        this.margin_right = 12;
        this.margin_left = 12;

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

        // First remove all content from flowbox
        // Also remember to propagate changes to variables
        // Then repopulate it

        var item_count = 2;
        for (int i = 0; i < item_count; i++) {
            var thumbnail = new Thumbnail ("/home/marinp1/Repositories/gtk-doxie-app/src/demo1.jpg");
            this.insert (thumbnail, -1);
        }

        int child_count = 0;

        this.foreach((child) => {
            child.get_style_context ().add_class ("scan");
            Granite.Widgets.Utils.set_theming (child, scanholder_style, "scan", Gtk.STYLE_PROVIDER_PRIORITY_USER);
            child_count += 1;
        });

        if (child_count == 0) {
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