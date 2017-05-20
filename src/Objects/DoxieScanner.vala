public class DoxieScanner : GLib.Object {

  public string name;
  public bool password_protected;
  public string ip_address;
  public string mac_address;
  public string device_password;

  public DoxieScanner (string ip) {

      ip_address = ip;
      bool fetch_success = HttpUtils.fill_scanner_information (this);

      if (fetch_success) {
          // TODO: display notification
      } else {
          // TODO: display notification
      }
      
  }
}