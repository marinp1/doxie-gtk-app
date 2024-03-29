class CustomHeader : Gtk.HeaderBar  {

    private static weak CustomHeader instance;

    Gee.ArrayList<weak DoxieScanner> combobox_content = new Gee.ArrayList<weak DoxieScanner>();

    Gtk.ToolButton button_fetch_scans;
    Gtk.ComboBoxText scanner_selector;

    Gtk.MenuItem item_ocr_settings;
    Gtk.MenuItem item_about;

    public CustomHeader () {
        
        this.set_title (_("Doxie Go WiFi Sync"));
        this.set_show_close_button (true);
        this.spacing = 4;

        // Create menu content for preferences menu
        Gtk.MenuButton menu_button = generate_menu ();
        this.pack_end (menu_button);

        // Add refresh button to header bar
        Gtk.Image refresh_icon = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.MENU);
        button_fetch_scans = new Gtk.ToolButton (refresh_icon, null);
        this.pack_end (button_fetch_scans);

        // Set the combo box
		scanner_selector = new Gtk.ComboBoxText();
        this.pack_start (scanner_selector);

        connect_signals ();

        instance = this;

    }

    private Gtk.MenuButton generate_menu () {

        Gtk.Menu menu = new Gtk.Menu ();

        // Add menu items
        // TODO: link to preference windows
        item_ocr_settings = new Gtk.MenuItem.with_label (_("OCR settings"));
        item_about = new Gtk.MenuItem.with_label (_("About"));

        menu.add (item_ocr_settings);
        menu.add (item_about);

        // Generate new Menu button with content
        Gtk.MenuButton menu_button = new Gtk.MenuButton ();
        menu_button.valign = Gtk.Align.CENTER;
        menu_button.set_image (new Gtk.Image.from_icon_name("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
        menu_button.set_popup (menu);

        menu.show_all ();

        return menu_button;

    }

    private void connect_signals () {

        button_fetch_scans.clicked.connect (() => {
            HttpUtils.get_scan_thumbnails ();
            ScanHolder.refresh_thumbnails ();
        });

		scanner_selector.changed.connect (() => {

            string active = scanner_selector.get_active_text ();

            // Set active scanner
            if (active != null) {
                string selected_ip = DoxieUtils.get_ip_from_selection (active);
                DoxieScanner selected_scanner = Variables.instance.scanner_list.get (selected_ip);
                DoxieUtils.select_doxie (selected_scanner);
            }

            // TODO: this should also fetch latest scans

		});

        item_about.activate.connect (() => {
            App.instance.show_about (App.instance.main_window);
        });

    }

    // Add scanner to combobox
    public static void add_scanner (DoxieScanner? scanner) {
        instance.combobox_content.add (scanner);
        instance.scanner_selector.append_text (scanner.name + " (" + scanner.ip_address + ")");
        check_sensitivity ();
    }

    // Remove scanner from combobox
    public static void remove_scanner (DoxieScanner? scanner) {
        int index = instance.combobox_content.index_of (scanner);
        instance.combobox_content.remove_at (index);
        instance.scanner_selector.remove (index);
        check_sensitivity ();
    }

    // Check combobox selection and check if it should be clickable
    public static void check_sensitivity () {

        if (Variables.instance.selected_scanner != null) {
            int index = instance.combobox_content.index_of(Variables.instance.selected_scanner);
            instance.scanner_selector.active = index;
        }

        // If no devices were found, add a placeholder
        if (Variables.instance.scanner_list.size == 0) {
            instance.button_fetch_scans.set_sensitive (false);
            ContentStack.switch_content (ContentStack.CONTENT_TYPE.NO_CONNECTION);
            instance.scanner_selector.hide ();
        } else if (Variables.instance.scanner_list.size == 1) {
            instance.button_fetch_scans.set_sensitive (true);
            instance.scanner_selector.set_sensitive (false);
            instance.scanner_selector.show ();
        } else {
            instance.button_fetch_scans.set_sensitive (true);
            instance.scanner_selector.show ();
        }
       
    }

}