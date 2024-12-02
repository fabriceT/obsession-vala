[DBus (name = "org.freedesktop.login1.Manager")]
interface ILogin1 : Object {
    public abstract string can_hibernate () throws GLib.Error;
    public abstract string can_power_off () throws GLib.Error;
    public abstract string can_reboot () throws GLib.Error;
    public abstract string can_suspend () throws GLib.Error;
    public abstract string can_hybrid_sleep () throws GLib.Error;
    public abstract void hibernate (bool arg) throws GLib.Error;
    public abstract void power_off (bool arg) throws GLib.Error;
    public abstract void reboot (bool arg) throws GLib.Error;
    public abstract void suspend (bool arg) throws GLib.Error;
    public abstract void hybrid_sleep (bool arg) throws GLib.Error;
}

class Systemd: IProvider, Object {
    ILogin1 proxy;

    public Systemd () {
        try {
            proxy = Bus.get_proxy_sync (BusType.SYSTEM,
                "org.freedesktop.login1",
                "/org/freedesktop/login1");
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
                case Action.HIBERNATE:
                    return (proxy.can_hibernate () == "yes");

                case Action.HYBRID_SLEEP:
                    return (proxy.can_hybrid_sleep () == "yes");

                case Action.POWEROFF:
                    return (proxy.can_power_off () == "yes");

                case Action.REBOOT:
                    return (proxy.can_reboot () == "yes");

                case Action.SUSPEND:
                    return (proxy.can_suspend () == "yes");

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
                    proxy.hybrid_sleep (true);
                    break;

                case Action.POWEROFF:
                    proxy.power_off (true);
                    break;

                case Action.REBOOT:
                    proxy.reboot (true);
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
        return "Systemd";
    }
}
