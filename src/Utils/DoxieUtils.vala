// Namespace containing static functions for doxie scanners
namespace DoxieUtils {
      
    // Adds a new scanner to application
    public static void add_scanner (string ip_address) {
        // Generate new Doxie instance and add it to list
        DoxieScanner scanner = new DoxieScanner (ip_address);

        Variables.instance.scanner_list.set (ip_address, scanner);

        if (Variables.instance.selected_scanner == null) {
            Variables.instance.selected_scanner = scanner;
        }

        // Add device for selection
        CustomHeader.add_scanner (scanner);

    }

    // Sets doxie selection and saves password for the future
    public static bool select_doxie (DoxieScanner scanner) {

        Variables.instance.selected_scanner = scanner;
        
        if (scanner.password_protected && scanner.device_password == "") {
            new PasswordPrompt ();
        }

        // Check if password is valid
        // CustomInfoBar.hide ();

        ContentStack.switch_content (ContentStack.CONTENT_TYPE.NO_SCANS);

        return true;
    }

    // Parses IP from string that is in format "<name> (<IP>)"
    public static string get_ip_from_selection (string combined) {
        int start_index = combined.last_index_of("(") + 1;
        int last_index = combined.last_index_of(")");
        return combined.substring(start_index, last_index - start_index);
    }
    
}