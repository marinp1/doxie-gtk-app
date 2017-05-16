using Gtk;

public class ActionBar  : Gtk.Box {

    public ActionBar () {
        this.set_orientation (Orientation.HORIZONTAL);
        this.set_border_width (4);
        this.set_spacing (4);

        Image img = new Image.from_icon_name ("window-close", Gtk.IconSize.MENU);
    		Gtk.ToolButton button2 = new Gtk.ToolButton (img, null);

        this.pack_start (button2, false, false, 0);

    }
}
