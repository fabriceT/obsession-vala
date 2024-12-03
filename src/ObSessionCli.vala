class ObSessionCli : GLib.Application {

    private PowerManager pm;

    public ObSessionCli () {
        Object (application_id: "org.example.myapp", flags: ApplicationFlags.HANDLES_COMMAND_LINE);
    }

    public void print_help (ApplicationCommandLine command_line) {
        command_line.print ("Veuillez spécifier une commande : 'commande1' ou 'display'.\n");
    }

    public override int command_line (ApplicationCommandLine command_line) {
        string[] args = command_line.get_arguments ();

        foreach (var a in args) {
            stdout.printf ("- %s\n", a);
        }

        if (args.length > 1) {
            pm = new PowerManager ();
            switch (args[1]) {
                case "display":
                    command_line.print ("Voici un autre texte\n");
                    pm.display_providers ();
                    break;
                default:
                    this.print_help (command_line);
                    break;
            }
        } else {
           this.print_help (command_line);
        }

        return 0;
    }

    public override void activate () {
        this.hold ();
        print ("Activated\n");
        this.release ();
    }

    public override void shutdown () {
        stdout.printf ("exiting…");
    }

    public static int main (string[] args) {
        return new ObSessionCli ().run (args);
    }
}
