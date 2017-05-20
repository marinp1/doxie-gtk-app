namespace GssdpUtils { 

    GSSDP.ResourceBrowser resource_browser;
    GSSDP.Client client;

    public static void initialise () {
        // Try to create a new SSDP client for device discovery
        try {
            GLib.MainContext ctx = GLib.MainContext.get_thread_default ();
            client = new GSSDP.Client (ctx, null);
        } catch (GLib.Error e) {
            print (_("Couldn't create SSDP client. \n"));
            print (e.message);
        }

        // Start listening to SSDP resources
        resource_browser = new GSSDP.ResourceBrowser (client, GSSDP.ALL_RESOURCES);
        resource_browser.resource_available.connect (device_found);
        resource_browser.set_active (true);
    }

    // On new SSDP device discovery
    private static void device_found (string usn, GLib.List<string> locations) {

        // Check if device mathes Doxie's URN scheme
        if (usn.index_of ("urn:schemas-getdoxie-com:device:Scanner") != -1) {

            // Parse host from full URL
            string full_uri = locations.nth (0).data;
            Soup.URI parsed_uri = new Soup.URI (full_uri);
            string ip_address = parsed_uri.get_host ();

            DoxieUtils.add_scanner (ip_address);

        }

    }

}