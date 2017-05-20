public class Variables {

    public const string TMP_FOLDER_NAME = ".com.github.marinp1.gtk-doxie-app";

    public bool ocr_activated = true;
    public Gee.HashMap<string, DoxieScanner> scanner_list = new Gee.HashMap<string, DoxieScanner>  ();
    public DoxieScanner selected_scanner;
    public Gee.ArrayList<string> selected_items = new Gee.ArrayList<string>();

    public static weak Variables instance;

    public void reset_selected_items (GLib.List<weak Gtk.FlowBoxChild> new_selection) {

        selected_items.clear ();

        foreach (Gtk.FlowBoxChild selected_item in new_selection) {
            weak Thumbnail element = (Thumbnail?) selected_item.get_child ();
            selected_items.add (element.file_name);
        }

    }

    public Variables () {
        instance = this;
    }

}