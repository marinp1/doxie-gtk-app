using Gtk;
using Gdk;

public class Thumbnail : Gtk.Box {

    Image thumbnail_image;
    public string file_name;
    Label thumbnail_label;

    public Thumbnail (string img_path) {

        this.set_orientation (Orientation.VERTICAL);
        this.set_border_width (10);
        this.set_spacing (8);

        Pixbuf pixel_buffer;

        try {
          pixel_buffer = new Pixbuf.from_file_at_scale (img_path, 140, 140, true);
          thumbnail_image = new Image.from_pixbuf (pixel_buffer);
          thumbnail_label = new Label (GLib.Path.get_basename (img_path));
          thumbnail_label.ellipsize = Pango.EllipsizeMode.MIDDLE;
          thumbnail_label.max_width_chars = 20;
        } catch (GLib.Error ex) {
          print (_("Image " + img_path + " not found!\n"));
        }

        this.pack_start (thumbnail_image, true, true, 0);
        this.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);
        this.pack_start (thumbnail_label, false, false, 0);
        
    }
}
