public class CustomHeaderBar : Gtk.HeaderBar  {
    public CustomHeaderBar () {
        
        this.set_title ("Doxie Go WiFi Sync");
        this.set_show_close_button (true);
        this.spacing = 0;

        // Add refresh button to header bar
      	Gtk.Image img = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.MENU);
      	Gtk.ToolButton button2 = new Gtk.ToolButton (img, null);
      	this.pack_start (button2);

        // Create menu content for preferences menu
		//Gtk.Menu app_menu_content = new Gtk.Menu ();

        // Add menu items
		//Gtk.MenuItem ocr_settings = new Gtk.MenuItem.with_label ("OCR settings");
		//app_menu_content.add (ocr_settings);

        // Generate new Granite application menu with content
        //Granite.Widgets.AppMenu app_menu = new Granite.Widgets.AppMenu(app_menu_content);
        //this.pack_end(app_menu);

    }
}
