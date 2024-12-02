[DBus (name = "org.freedesktop.ConsoleKit.Manager")]
interface IConsoleKit : Object {
    public abstract string can_stop () throws GLib.Error;
    public abstract string can_restart () throws GLib.Error;
    public abstract void stop (bool arg) throws GLib.Error;
    public abstract void restart (bool arg) throws GLib.Error;
}

class ConsoleKit: IProvider, Object {
    IConsoleKit proxy;

    public ConsoleKit () {
        try {
            proxy = Bus.get_proxy_sync (BusType.SYSTEM,
                "org.freedesktop.ConsoleKit",
                "org/freedesktop/ConsoleKit/Manager");
        }
        catch (GLib.Error e) {
            proxy = null;
            stdout.printf ("--------- %s", e.message);
        }
    }

    public bool query (PowerAction action) {
        if (proxy == null) {
            return false;
        }

        try {
            switch (action) {
                case PowerAction.POWEROFF:
                    return (proxy.can_stop () == "yes");

                case PowerAction.REBOOT:
                    return (proxy.can_restart () == "yes");

                default:
                    return false;
            }
        }
        catch (GLib.Error e) {
            stdout.printf ("---------- %s\n", e.message);
            return false;
        }
    }

    public void execute (PowerAction action) {
        if (proxy == null)
            return;

        try {
            switch (action) {
                case PowerAction.HIBERNATE:
                break;

                case PowerAction.HYBRID_SLEEP:
                    break;

                case PowerAction.POWEROFF:
                    proxy.stop (true);
                    break;

                case PowerAction.REBOOT:
                    proxy.restart (true);
                    break;

                case PowerAction.SUSPEND:
                    break;
            }
        }
        catch (GLib.Error e) {
            message ("%s", e.message);
        }
    }

    public string get_name () {
        return "ConsoleKit";
    }

}
