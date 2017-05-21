class PasswordPrompt : Gtk.Dialog {

    private Gtk.Label label_action_title;
    private Gtk.Entry entry_password;

    private Gtk.Box layout;
    private Gtk.Switch switch_display_password;
    private Gtk.Label label_display_password;

    private Gtk.Widget button_ok;
    private Gtk.Widget button_cancel;

    public PasswordPrompt () {

        this.resizable = false;
        this.modal = true;
        this.set_border_width (12);
        this.set_size_request (500, 350);
        this.deletable = false;

        label_action_title = new Gtk.Label (_("Password required"));
        label_action_title.margin_bottom = 16;
        Granite.Widgets.Utils.apply_text_style_to_label(Granite.TextStyle.H2, label_action_title);

        entry_password = new Gtk.Entry ();
        entry_password.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "dialog-password");
        entry_password.set_visibility (false);
        entry_password.set_invisible_char ('*');

        switch_display_password = new Gtk.Switch ();
        label_display_password = new Gtk.Label (_("Display password"));

        layout = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        layout.pack_start (label_display_password, false, true, 0);
        layout.pack_start (switch_display_password, false, true, 0);
        layout.margin_bottom = 12;

        Gtk.Box content = this.get_content_area () as Gtk.Box;
        content.pack_start (label_action_title, false, true, 0);
        content.pack_start (entry_password, false, true, 0);
        content.pack_start (layout, false, true, 0);
        content.spacing = 10;

        button_cancel = add_button ("Cancel", Gtk.ResponseType.CLOSE);
		button_ok = add_button ("Apply", Gtk.ResponseType.APPLY);

        this.connect_signals ();

        this.show_all ();

    }

    private void connect_signals () {

        switch_display_password.notify["active"].connect (() => {
            entry_password.set_visibility (switch_display_password.active);
        });

        this.response.connect (on_response);

    }

	private void on_response (Gtk.Dialog source, int response_id) {
		switch (response_id) {
		case Gtk.ResponseType.APPLY:
			// set password
            destroy ();
			break;
		case Gtk.ResponseType.CLOSE:
            // show notification
			destroy ();
			break;
		}
	}

}