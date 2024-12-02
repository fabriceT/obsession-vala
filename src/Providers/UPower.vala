[DBus (name = "org.freedesktop.UPower")]
interface IUPower : Object {
    // public abstract string suspend_allowed () throws GLib.Error;
    // public abstract string hibernate_allowed () throws GLib.Error;
    public abstract void suspend (bool arg) throws GLib.Error;
    public abstract void hibernate (bool arg) throws GLib.Error;
}

class UPower: IProvider, Object {
    IUPower proxy;

    public UPower () {
        try {
            proxy = Bus.get_proxy_sync (BusType.SYSTEM,
                    "org.freedesktop.UPower",
                    "/org/freedesktop/UPower");
        }
        catch (GLib.Error e) {
            proxy = null;
            stdout.printf ("--------- %s", e.message);
        }
    }

    public bool query (Action action) {
        if (proxy == null)
            return false;

        try {
            switch (action) {
                /*
                case Action.HIBERNATE:
                    return (proxy.hibernate_allowed () == "yes");

                case Action.SUSPEND:
                    return (proxy.suspend_allowed () == "yes");
                */
                default:
                    return false;
            }
        }
        catch (GLib.Error e) {
            return false;
        }
    }

    public void execute (Action action) {
        if (proxy == null)
            return;

        try {
            switch (action) {
                case Action.HIBERNATE:
                    proxy.hibernate (true);
                    break;

                case Action.HYBRID_SLEEP:
                    break;

                case Action.POWEROFF:
                     break;

                case Action.REBOOT:
                    break;

                case Action.SUSPEND:
                    proxy.suspend (true);
                    break;
            }
        }
        catch (GLib.Error e) {
            message ("%s", e.message);
        }
    }

    public string get_name () {
        return "UPower";
    }
}
