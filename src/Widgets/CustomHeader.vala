public class CustomHeader : Gtk.HeaderBar  {

    App app;

    public static weak CustomHeader instance;

    Gtk.ComboBoxText scanner_selector;
    Gee.ArrayList<weak DoxieScanner> combobox_content = new Gee.ArrayList<weak DoxieScanner>();
    Gtk.ToolButton fetch_scans_btn;

    public CustomHeader (App main_app) {
        app = main_app;
        
        this.set_title (_("Doxie Go WiFi Sync"));
        this.set_show_close_button (true);
        this.spacing = 4;

        // Create menu content for preferences menu
        Gtk.Menu app_menu = new Gtk.Menu ();

        // Add menu items
        // TODO: link to preference windows
        Gtk.MenuItem ocr_settings_item = new Gtk.MenuItem.with_label (_("OCR settings"));
        Gtk.MenuItem about_item = new Gtk.MenuItem.with_label (_("About"));

        app_menu.add (ocr_settings_item);
        app_menu.add (about_item);

        // Generate new Menu button with content
        Gtk.MenuButton app_menu_btn = new Gtk.MenuButton ();
        app_menu_btn.valign = Gtk.Align.CENTER;
        app_menu_btn.set_image (new Gtk.Image.from_icon_name("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
        app_menu_btn.set_popup (app_menu);
        
        app_menu.show_all ();

        this.pack_end (app_menu_btn);

        // Add refresh button to header bar
        Gtk.Image refresh_icon = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.MENU);
        fetch_scans_btn = new Gtk.ToolButton (refresh_icon, null);
        
        fetch_scans_btn.clicked.connect (() => {
            ScanHolder.instance.refresh_content ();
        });

        this.pack_end (fetch_scans_btn);

        // Set the combo box
		scanner_selector = new Gtk.ComboBoxText();
        this.pack_start (scanner_selector);
        check_sensitivity ();

		scanner_selector.changed.connect (() => {

            string active = scanner_selector.get_active_text ();

            // Set active scanner
            if (active != null && active != "No scanners found!") {
                string selected_ip = DoxieScannerUtils.get_ip_from_selection (active);
                app.variables.selected_scanner = app.variables.scanner_list.get (selected_ip);
            }

            // TODO: this should also fetch latest scans

		});

        instance = this;

    }

    // Add scanner to combobox
    public void add_scanner (DoxieScanner? scanner) {
        combobox_content.add (scanner);
        scanner_selector.append_text (scanner.name + " (" + scanner.ip_address + ")");
        check_sensitivity ();
    }

    // Remove scanner from combobox
    public void remove_scanner (DoxieScanner? scanner) {
        int index = combobox_content.index_of (scanner);
        combobox_content.remove_at (index);
        scanner_selector.remove (index);
        check_sensitivity ();
    }

    // Check combobox selection and check if it should be clicable
    private void check_sensitivity () {

        if (app.variables.selected_scanner != null) {
            int index = combobox_content.index_of(app.variables.selected_scanner);
            scanner_selector.active = index;
        }

        if (app.variables.scanner_list.size < 2) {
            scanner_selector.set_sensitive (false);
            fetch_scans_btn.set_sensitive (false);
        } else {
            scanner_selector.set_sensitive (true);
            fetch_scans_btn.set_sensitive (true);
        }

        // If no devices were found, add a placeholder
        if (app.variables.scanner_list.size == 0) {
            app.switch_content (App.CONTENT_TYPE.NO_CONNECTION);
        }
       
    }

}