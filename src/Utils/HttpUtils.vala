namespace HttpUtils {

    
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

    private static Soup.Message get_http_message (Soup.Session session, REQUEST_TYPE request, string uri_string) {
        
        session.authenticate.connect ((msg, auth, retrying) => {
            if (retrying == false) {
                auth.authenticate ("doxie", Variables.instance.selected_scanner.device_password);
            }
        });

        Soup.Message message = new Soup.Message (request.to_string (), uri_string);
        session.send_message (message);

        return message;

    }

    private static void fetch_file (Soup.Session session, string remote_file_path, string target_location) {

        try {

            Soup.Message message = get_http_message (session, REQUEST_TYPE.GET, remote_file_path);
            uint8[] data = message.response_body.data;

            string filename = GLib.Path.get_basename (remote_file_path);
            File target_file = File.new_for_path (target_location + "/" + filename);
            FileOutputStream target_stream = target_file.create (FileCreateFlags.REPLACE_DESTINATION);

            DataOutputStream data_stream = new DataOutputStream (target_stream);
            data_stream.write (data);

        } catch (Error e) {
            print (e.message);
        }

    }

    private Json.Node? get_request_root_node (Soup.Message message) {

        try {

            // Parse response
            Json.Parser parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            Json.Node root_data = parser.get_root ();

            return root_data;

        } catch (Error e) {

            return null;

        }

    }

    // Populates scanner information for given scanner
    public static bool fill_scanner_information (DoxieScanner scanner) {

        Soup.Session session = new Soup.Session ();

        string hello_uri = "http://" + scanner.ip_address + ":8080/hello.json";

        Soup.Message http_request = get_http_message (session, REQUEST_TYPE.GET, hello_uri);

        if (http_request.status_code != Soup.Status.OK) {
            return false;
        }

        Json.Object scanner_information = get_request_root_node (http_request).get_object ();
        
        if (scanner_information == null) {
            return false;
        }

        scanner.name = scanner_information.get_string_member ("name");
        scanner.mac_address = scanner_information.get_string_member ("MAC");
        scanner.password_protected = scanner_information.get_boolean_member ("hasPassword");

        return true;
    }

    public static bool get_scan_thumbnails () {

        // TODO: empty tmp folder

        Soup.Session session = new Soup.Session ();

        string scans_uri = "http://" + Variables.instance.selected_scanner.ip_address + ":8080/scans.json";

        Soup.Message http_request = get_http_message (session, REQUEST_TYPE.GET, scans_uri);

        if (http_request.status_code == Soup.Status.UNAUTHORIZED) {
            CustomInfoBar.show_bar ();
            return false;
        }

        Json.Array scan_content = get_request_root_node (http_request).get_array ();
        
        if (scan_content == null) {
            return false;
        }

        scan_content.foreach_element ((arr, index, node) => {
            Json.Object scan_information = node.get_object ();
            string scan_name = scan_information.get_string_member ("name");
            string thumbnail_uri = "http://" + Variables.instance.selected_scanner.ip_address + ":8080/thumbnails" + scan_name;
            fetch_file (session, thumbnail_uri, Variables.THUMBNAIL_LOCATION);
        });

        return true;
    }

    public static bool get_scans () {

        // TODO: empty tmp folder

        Soup.Session session = new Soup.Session ();

        // TODO: Display progress bar

        foreach (string selected_item in Variables.instance.selected_items) {
            string scan_uri = "http://" + Variables.instance.selected_scanner.ip_address + ":8080/scans/DOXIE/JPEG/" + selected_item;
            fetch_file (session, scan_uri, Variables.SCAN_LOCATION);
        }

        print ("Done!");

        return true;
    }

}