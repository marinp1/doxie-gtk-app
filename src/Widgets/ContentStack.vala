class ContentStack : Gtk.Stack {

    public static weak ContentStack instance;

    public ContentStack () {
        instance = this;
    }

    public enum CONTENT_TYPE {
        SCAN_LIST,
        NO_SCANS,
        NO_CONNECTION
    }

    public static void switch_content (CONTENT_TYPE content_request) {

        if (instance.get_visible_child () == null) {
            return;
        }

        if (content_request == CONTENT_TYPE.SCAN_LIST) {

            instance.visible_child_name = "content";

        } else if (content_request == CONTENT_TYPE.NO_SCANS) {

            ContentPlaceholder.change_to_no_scans_template ();
            instance.visible_child_name = "placeholder";

        } else if (content_request == CONTENT_TYPE.NO_CONNECTION) {

            ContentPlaceholder.change_to_no_connection_template ();
            instance.visible_child_name = "placeholder";

        }

    }
}