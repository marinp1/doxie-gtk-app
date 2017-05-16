public class Variables {
    bool ocr_activated = true;
    Gee.HashMap<string, DoxieScanner> scanner_list = new Gee.HashMap<string, DoxieScanner>  ();
    weak DoxieScanner selected_scanner;
    GLib.List<string> selected_items = new GLib.List<string> ();	
}