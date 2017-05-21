class CustomInfoBar : Gtk.InfoBar {

	private static weak CustomInfoBar instance;

    public CustomInfoBar () {

		instance = this;
		change_to_invalid_password ();

    }

	public static void change_to_invalid_password () {

		instance.add_button ("Retry", 1);
		instance.message_type = Gtk.MessageType.ERROR;

		// Content:
		Gtk.Container content = instance.get_content_area ();
		content.add (new Gtk.Label ("Invalid password"));

	}

	public static void show_bar () {
		instance.show_all ();
	}

	public static void hide_bar () {
		instance.hide ();
	}
}