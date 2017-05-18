public class Variables {
    
    public bool ocr_activated = true;
    public Gee.HashMap<string, DoxieScanner> scanner_list = new Gee.HashMap<string, DoxieScanner>  ();
    public weak DoxieScanner selected_scanner;
    public Gee.ArrayList<string> selected_items = new Gee.ArrayList<string>();	


    public void reset_selected_items (GLib.List<weak Gtk.FlowBoxChild> new_selection) {

        selected_items.clear ();

        new_selection.foreach ((child) => {
            weak Thumbnail element = (Thumbnail?) child.get_child ();
            selected_items.add (element.file_name);
        });

    }

}