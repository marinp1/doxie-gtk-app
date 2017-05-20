namespace HttpUtils {

    // Populates scanner information for given scanner
    public static bool fill_scanner_information (DoxieScanner scanner) {

        string hello_uri = "http://" + scanner.ip_address + ":8080/hello.json";

        Soup.Session session = new Soup.Session ();
        Soup.Message message = new Soup.Message ("GET", hello_uri);
        session.send_message (message);
        
        try {

            // Parse response
            Json.Parser parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            Json.Object scanner_information = parser.get_root ().get_object ();

            scanner.name = scanner_information.get_string_member ("name");
            scanner.mac_address = scanner_information.get_string_member ("MAC");
            scanner.password_protected = scanner_information.get_boolean_member ("hasPassword");

        } catch (Error e) {
            print (_("Error with fetching scanner information at " + scanner.ip_address));
            return false;
        }

        return true;
    }

    public static bool get_scan_thumbnails () {
        // make get request for scan thumbnails
        // save thumbnails to a tmp folder
        // call Scanholder.refresh_scans
        return true;
    }

    public static bool get_scans () {
        // make get request for actual scans
        // save jpegs to a tmp folder
        // pre-process images
        // start conversion process
        return true;
    }

}