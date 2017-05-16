using Gtk;

public class ActionBar  : Gtk.Box {

    Gtk.Button export_button;

    public ActionBar () {
        this.set_orientation (Orientation.HORIZONTAL);
        this.set_border_width (4);
        this.set_spacing (10);

        Gtk.Label ocr_label = new Gtk.Label ("<b>OCR</b>");
        ocr_label.set_use_markup (true);

		Gtk.Switch ocr_switch = new Gtk.Switch ();

		ocr_switch.notify["active"].connect (() => {
			if (ocr_switch.active) {
				// Do something
			} else {
				// Do something else
			}
		});

		ocr_switch.set_active (true);

        this.pack_start (ocr_label, false, false, 0);
        this.pack_start (ocr_switch, false, false, 0);

        export_button = new Gtk.Button.with_label ("No scans selected");
        export_button.clicked.connect (() => {
			// Start export process
		});

        this.pack_end (export_button, false, false, 0);

    }
}
