class Fallback: IProvider, Object {
    public static void execute_command (string cmd) {
        try {
            Process.spawn_command_line_async (cmd);
        }
        catch (GLib.SpawnError e) {
            stdout.printf ("Can't spawn process: %s", e.message);
        }
    }

    public bool query (Action action) {
        switch (action) {

            case Action.HIBERNATE:
                return false;

            case Action.HYBRID_SLEEP:
                return false;

            case Action.POWEROFF:
                return true;

            case Action.REBOOT:
                return true;

            case Action.SUSPEND:
                return false;

            default:
                return false;
        }
    }

    public void execute (Action action) {
        switch (action) {
            case Action.HIBERNATE:
                break;

            case Action.HYBRID_SLEEP:
                break;

            case Action.POWEROFF:
                execute_command ("halt");
                break;

            case Action.REBOOT:
                execute_command ("halt -r");
                break;

            case Action.SUSPEND:
                break;
        }
    }

    public string get_name () {
        return "Fallback";
    }
}
