using Gtk;

public class ActionBar : Gtk.Box {

    public static weak ActionBar instance;

    Gtk.Button export_button;

    public ActionBar () {

        this.set_orientation (Orientation.HORIZONTAL);
        this.set_spacing (10);

        this.margin_bottom = 12;
        this.margin_end = 12;
        this.margin_start = 12;

        Gtk.Label ocr_label = new Gtk.Label ("OCR");

        Gtk.Switch ocr_switch = new Gtk.Switch ();

        // By default, OCR is the same as given in application variables
        ocr_switch.set_active (Variables.instance.ocr_activated);

        // Connect switch activation to application shared variable
        ocr_switch.notify["active"].connect (() => {
            Variables.instance.ocr_activated = ocr_switch.active;
        });
        
        // Add OCR switch to left side of action bar
        this.pack_start (ocr_label, false, false, 0);
        this.pack_start (ocr_switch, false, false, 0);

        // Button for exporting scans
        export_button = new Gtk.Button.with_label (_("No scans selected"));
        export_button.set_sensitive (false);
        export_button.clicked.connect (() => {

            // TODO: Start export
            print (Variables.instance.selected_scanner.name + "\n");
            
        });

        // Add export command to the right side
        this.pack_end (export_button, false, false, 0);

        instance = this;

    }

    public void update_export_content (uint selection_count) {
        if (selection_count == 0) {
            export_button.label = _("No scans selected");
            export_button.set_sensitive (false);
        } else if (selection_count == 1) {
            export_button.label = _("Export 1 scan");
            export_button.set_sensitive (true);
        } else {
            export_button.label = _("Export " + selection_count.to_string() + " scans");
            export_button.set_sensitive (true);
        }
    }

}