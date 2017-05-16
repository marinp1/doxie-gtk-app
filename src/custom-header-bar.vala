public class CustomHeaderBar : Gtk.HeaderBar  {
    public CustomHeaderBar () {
        this.set_title ("Doxie Go WiFi Sync");
        this.set_show_close_button (true);
        this.spacing = 0;
      	//Get image from icon theme
      	Gtk.Image img = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.MENU);
      	Gtk.ToolButton button2 = new Gtk.ToolButton (img, null);
      	this.pack_start (button2);
    }
}
