class ContentPlaceholder : Granite.Widgets.AlertView {

    private static weak ContentPlaceholder instance;

    public ContentPlaceholder () {

        // initiate base with random content
        base ("Title", "Description", "image-x-generic");

        instance = this;
    }

    public static void change_to_no_scans_template () {

        instance.title = "No scans found";
        instance.description = "Click refresh button to check again.";
        instance.icon_name = "image-x-generic";
        instance.show_all ();

    }

    public static void change_to_no_connection_template () {

        instance.title = "Scanner not found";
        instance.description = "Please make sure Doxie is connected to same network.";
        instance.icon_name = "printer-error";
        instance.show_all ();

    }

}