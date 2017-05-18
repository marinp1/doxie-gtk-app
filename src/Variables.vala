public class Variables {
    public bool ocr_activated = true;
    public Gee.HashMap<string, DoxieScanner> scanner_list = new Gee.HashMap<string, DoxieScanner>  ();
    public DoxieScanner selected_scanner;
    public GLib.List<string> selected_items = new GLib.List<string> ();	
}