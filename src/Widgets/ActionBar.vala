using Gtk;

class ActionBar : Gtk.Box {

    public static weak ActionBar instance;

    Gtk.Button button_export;
    Gtk.Switch switch_ocr;

    public ActionBar () {

        this.set_orientation (Orientation.HORIZONTAL);
        this.set_spacing (10);

        this.margin_bottom = 12;
        this.margin_end = 12;
        this.margin_start = 12;

        Gtk.Label ocr_label = new Gtk.Label ("OCR");
        switch_ocr = new Gtk.Switch ();
        // By default, OCR is the same as given in application variables
        switch_ocr.set_active (Variables.instance.ocr_activated);
        
        // Add OCR switch to left side of action bar
        this.pack_start (ocr_label, false, false, 0);
        this.pack_start (switch_ocr, false, false, 0);

        // Button for exporting scans
        button_export = new Gtk.Button.with_label (_("No scans selected"));
        button_export.set_sensitive (false);

        // Add export command to the right side
        this.pack_end (button_export, false, false, 0);

        instance = this;

    }

    private void connect_signals () {

        button_export.clicked.connect (() => {
            // TODO: Start export
            print (Variables.instance.selected_scanner.name + "\n");
        });

        // Connect switch activation to application shared variable
        switch_ocr.notify["active"].connect (() => {
            Variables.instance.ocr_activated = switch_ocr.active;
        });

    }

    public void update_export_content (uint selection_count) {
        if (selection_count == 0) {
            button_export.label = _("No scans selected");
            button_export.set_sensitive (false);
        } else if (selection_count == 1) {
            button_export.label = _("Export 1 scan");
            button_export.set_sensitive (true);
        } else {
            button_export.label = _("Export " + selection_count.to_string() + " scans");
            button_export.set_sensitive (true);
        }
    }

}