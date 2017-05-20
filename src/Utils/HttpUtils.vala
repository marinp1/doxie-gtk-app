namespace HttpUtils {

    private enum REQUEST_TYPE {
        GET,
        POST
    }

    private Json.Object? get_request_root (REQUEST_TYPE request, string uri_string) {

        Soup.Session session = new Soup.Session ();
        Soup.Message message = new Soup.Message (request.to_string(), uri_string);
        session.send_message (message);
        
        try {

            // Parse response
            Json.Parser parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            Json.Object root_data = parser.get_root ().get_object ();

            return root_data;

        } catch (Error e) {

            return null;

        }

    }

    // Populates scanner information for given scanner
    public static bool fill_scanner_information (DoxieScanner scanner) {

        string hello_uri = "http://" + scanner.ip_address + ":8080/hello.json";

        Json.Object? scanner_information = get_request_root (REQUEST_TYPE.GET, hello_uri);

        if (scanner_information == null) {
            print (_("Error with fetching scanner information at " + scanner.ip_address));
            return false;
        }

        scanner.name = scanner_information.get_string_member ("name");
        scanner.mac_address = scanner_information.get_string_member ("MAC");
        scanner.password_protected = scanner_information.get_boolean_member ("hasPassword");

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