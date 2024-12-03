class Fallback: IProvider, Object {


    public static void execute_command (string cmd) {
        try {
            Process.spawn_command_line_async (cmd);
        }
        catch (GLib.SpawnError e) {
            stdout.printf ("Can't spawn process: %s", e.message);
        }
    }


    public bool query (PowerAction action) {
        switch (action) {

            case PowerAction.HIBERNATE:
                return true;

            case PowerAction.HYBRID_SLEEP:
                return true;

            case PowerAction.POWEROFF:
                return true;

            case PowerAction.REBOOT:
                return true;

            case PowerAction.SUSPEND:
                return true;

            default:
                return false;
        }
    }


    public void execute (PowerAction action) {
        switch (action) {
            case PowerAction.HIBERNATE:
                break;

            case PowerAction.HYBRID_SLEEP:
                break;

            case PowerAction.POWEROFF:
                execute_command ("halt");
                break;

            case PowerAction.REBOOT:
                execute_command ("halt -r");
                break;

            case PowerAction.SUSPEND:
                break;
        }
    }


    public string get_name () {
        return "Fallback";
    }
}
