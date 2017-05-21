public class Variables {

    private const string TMP_FOLDER_NAME = ".com.github.marinp1.gtk-doxie-app";
    public static string THUMBNAIL_LOCATION;
    public static string SCAN_LOCATION;

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
        THUMBNAIL_LOCATION = GLib.Environment.get_tmp_dir () + "/" + TMP_FOLDER_NAME + "/thumbnails";
        SCAN_LOCATION = GLib.Environment.get_tmp_dir () + "/" + TMP_FOLDER_NAME + "/scans";
        create_temp_folders ();
        instance = this;
    }

    public static void create_temp_folders () {
        DirUtils.create_with_parents (THUMBNAIL_LOCATION, 0777);
        DirUtils.create_with_parents (SCAN_LOCATION, 0777);
    }

}