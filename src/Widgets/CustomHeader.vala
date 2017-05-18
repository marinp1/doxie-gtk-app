public class CustomHeader : Gtk.HeaderBar  {
    public CustomHeader () {
        
        this.set_title ("Doxie Go WiFi Sync");
        this.set_show_close_button (true);
        this.spacing = 0;

        // Add refresh button to header bar
        // TODO: Link button action for fetching scans
        Gtk.Image refresh_icon = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.MENU);
        Gtk.ToolButton fetch_scans_btn = new Gtk.ToolButton (refresh_icon, null);
        this.pack_start (fetch_scans_btn);

        // Create menu content for preferences menu
        Gtk.Menu app_menu_content = new Gtk.Menu ();

        // Add menu items
        Gtk.MenuItem ocr_settings = new Gtk.MenuItem.with_label ("OCR settings");
        app_menu_content.add (ocr_settings);

        // Generate new Granite application menu with content
        Granite.Widgets.AppMenu app_menu = new Granite.Widgets.AppMenu(app_menu_content);
        this.pack_end(app_menu);

    }
}