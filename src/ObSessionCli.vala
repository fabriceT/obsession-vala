class ObSessionCli : GLib.Application {

    private PowerManager pm;


    public ObSessionCli () {
        Object (application_id: "id.obsession", flags: ApplicationFlags.HANDLES_COMMAND_LINE);
    }


    public void print_help (ApplicationCommandLine command_line) {
        command_line.print ("Veuillez spécifier une commande : 'commande1' ou 'display'.\n");
    }


    public override int command_line (ApplicationCommandLine command_line) {
        string[] args = command_line.get_arguments ();

        if (args.length < 1) {
            this.print_help (command_line);
            return 0;
        }

        pm = new PowerManager ();
        switch (args[1]) {
            case "status":
                pm.display_providers ();
                break;
            case "hibernate":
                pm.execute_action (PowerAction.HIBERNATE);
                break;

            case "sleep":
                pm.execute_action (PowerAction.HYBRID_SLEEP);
                break;

            case "poweroff":
                pm.execute_action (PowerAction.POWEROFF);
                break;

            case "reboot":
                pm.execute_action (PowerAction.REBOOT);
                break;

            case "suspend":
                pm.execute_action (PowerAction.SUSPEND);
                break;

            default:
                this.print_help (command_line);
                break;
        }

        return 0;
    }


    public static int main (string[] args) {
        return new ObSessionCli ().run (args);
    }
}
