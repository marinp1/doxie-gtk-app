using Gtk;

public class ScanHolder : FlowBox {

    App app;
    public static weak ScanHolder instance;

    public ScanHolder (App main_app) {
        app = main_app;

        this.set_valign (Align.START);
        this.set_halign (Align.START);
        this.activate_on_single_click = false;
        this.column_spacing = 0;
        this.row_spacing = 0;
        this.set_selection_mode (SelectionMode.MULTIPLE);
        this.homogeneous = true;

        this.selected_children_changed.connect (() => {
            app.variables.reset_selected_items (this.get_selected_children ());
            ActionBar.instance.update_export_content (this.get_selected_children ().length ());
        });

        instance = this;

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

        this.show_all ();

        return true;

    }

}