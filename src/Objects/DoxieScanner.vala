public class DoxieScanner : GLib.Object {

  public string name;
  public bool password_protected;
  public string ip_address;
  public string mac_address;
  public string device_password;

  public DoxieScanner (string ip_address) {
      
      // Create HTTP hello request to scanner
      // DEMO
      try {
        // Create a session:
        var session = new Soup.Session ();

        // Request a file:
        Soup.Request request = session.request ("http://" + ip_address + ":8080/hello.json");
        InputStream stream = request.send ();

        // Print the content:
        DataInputStream data_stream = new DataInputStream (stream);

        string? line;
        while ((line = data_stream.read_line ()) != null) {
          stdout.puts (line);
          stdout.putc ('\n');
        }
      } catch (Error e) {
        stderr.printf ("Error: %s\n", e.message);
      }

  }
}