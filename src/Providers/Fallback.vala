class Fallback: IProvider, Object
{
    public bool query(Action action)
    {
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
            case Action.HYBRID_SLEEP:
                break;

            case Action.POWEROFF:
                Process.spawn_command_line_async ("halt");
                break;

            case Action.REBOOT:
                Process.spawn_command_line_async("halt -r");
                break;

            case Action.SUSPEND:
                break;
        }
    }

    public string get_name() {
        return "Fallback";
    }
}
