public class DoxieScanner : GLib.Object {

  public string name;
  public bool password_protected;
  public string ip_address;
  public string mac_address;
  public string device_password;

  public DoxieScanner (string ip) {

      // Fetch scanner information
      var hello_uri = "http://" + ip + ":8080/hello.json";
      var session = new Soup.Session ();
      var message = new Soup.Message ("GET", hello_uri);
      session.send_message (message);
      
      try {

          // Parse response
          Json.Parser parser = new Json.Parser ();
          parser.load_from_data ((string) message.response_body.flatten ().data, -1);
          var scanner_information = parser.get_root ().get_object ();

          ip_address = ip;
          name = scanner_information.get_string_member ("name");
          mac_address = scanner_information.get_string_member ("MAC");
          password_protected = scanner_information.get_boolean_member ("hasPassword");

      } catch (Error e) {
          print (_("Error with fetching scanner information at " + ip));
      }

  }
}