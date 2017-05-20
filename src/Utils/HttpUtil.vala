namespace HttpUtil {

    
    private enum REQUEST_TYPE {
        GET,
        POST;

        public string to_string () {

            switch (this) {

                case GET:
                    return "GET";

                case POST:
                    return "POST";

                default:
                    assert_not_reached();
            }

        }

    }

    private Soup.Message get_http_message (REQUEST_TYPE request, string uri_string) {

        Soup.Session session = new Soup.Session ();
        Soup.Message message = new Soup.Message (request.to_string (), uri_string);
        session.send_message (message);

        validate_message_status (message.status_code);

        return message;

    }

    private void validate_message_status (uint status) {

        switch (status) {

            case Soup.Status.OK:
                break;

            case Soup.Status.NO_CONTENT:
                break;

            case Soup.Status.UNAUTHORIZED:
                // TODO: Display toast about invalid password
                // Prompt for password
                break;

            case Soup.Status.FORBIDDEN:
                break;

            case Soup.Status.NOT_FOUND:
                break;

            default:
                break;

        }

    }

    private Json.Object? get_request_root (Soup.Message message) {

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

        Soup.Message http_request = get_http_message (REQUEST_TYPE.GET, hello_uri);

        if (http_request.status_code != Soup.Status.OK) {
            return false;
        }

        Json.Object scanner_information = get_request_root (http_request);
        
        if (scanner_information == null) {
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

        //string scans_uri = "http://" + scanner.ip_address + ":8080/scans.json";

        ScanHolder.instance.refresh_thumbnails ();

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