public class CustomHeader : Gtk.HeaderBar  {

    App app;

    public static weak CustomHeader instance;

    // ListStore to hold combobox values
    Gtk.ComboBoxText scanner_selector;

    public CustomHeader (App main_app) {
        app = main_app;
        
        this.set_title (_("Doxie Go WiFi Sync"));
        this.set_show_close_button (true);
        this.spacing = 4;

        // Create menu content for preferences menu
        Gtk.Menu app_menu_content = new Gtk.Menu ();

        // Add menu items
        Gtk.MenuItem ocr_settings = new Gtk.MenuItem.with_label (_("OCR settings"));
        app_menu_content.add (ocr_settings);

        // Generate new Granite application menu with content
        Granite.Widgets.AppMenu app_menu = new Granite.Widgets.AppMenu(app_menu_content);
        this.pack_end(app_menu);

        // Add refresh button to header bar
        Gtk.Image refresh_icon = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.MENU);
        Gtk.ToolButton fetch_scans_btn = new Gtk.ToolButton (refresh_icon, null);
        
        fetch_scans_btn.clicked.connect (() => {
            ScanHolder.instance.refresh_content ();
        });

        this.pack_end (fetch_scans_btn);

        // Set the combo box
		scanner_selector = new Gtk.ComboBoxText();
        this.pack_start (scanner_selector);
        update_combobox ();

		scanner_selector.changed.connect (() => {

            print ("change");

		});

        instance = this;

    }

    public void update_combobox () {

        int n = 0;

        scanner_selector.set_sensitive (true);
        scanner_selector.remove_all ();

        foreach (DoxieScanner scanner in app.variables.scanner_list.values) {

            scanner_selector.append_text (scanner.name);

            if (app.variables.selected_scanner.mac_address == scanner.mac_address) {
                scanner_selector.active = n;
            }

            n += 1;
        }

        if (n == 0) {
            scanner_selector.set_sensitive (false);
            scanner_selector.append_text ("No scanners found");
            scanner_selector.active = 0;
        }

    }
}