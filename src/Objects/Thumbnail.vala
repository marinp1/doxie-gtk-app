using Gtk;
using Gdk;

public class Thumbnail : Gtk.Box {

    Image thumbnail_image;
    Label thumbnail_label;

    public Thumbnail (string img_path) {

        this.set_orientation (Orientation.VERTICAL);
        this.set_border_width (12);
        this.set_spacing (6);

        Pixbuf pixel_buffer;

        try {
          pixel_buffer = new Pixbuf.from_file_at_scale (img_path, 160, 160, true);
          thumbnail_image = new Image.from_pixbuf (pixel_buffer);
          // TODO: Set label to be file name
          thumbnail_label = new Label ("somepath");
        } catch (GLib.Error ex) {
          print ("Image " + img_path + " not found!\n");
        }

        this.pack_start (thumbnail_image, false, false, 0);
        this.pack_start (thumbnail_label, true, false, 0);

    }
}
