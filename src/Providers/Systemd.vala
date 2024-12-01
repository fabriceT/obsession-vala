[DBus (name = "org.freedesktop.login1.Manager")]
interface iLogin1 : Object {
    public abstract string can_hibernate () throws IOError;
    public abstract string can_power_off () throws IOError;
    public abstract string can_reboot () throws IOError;
    public abstract string can_suspend () throws IOError;
    public abstract string can_hybrid_sleep () throws IOError;
    public abstract void hibernate (bool arg) throws IOError;
    public abstract void power_off (bool arg) throws IOError;
    public abstract void reboot (bool arg) throws IOError;
    public abstract void suspend (bool arg) throws IOError;
    public abstract void hybrid_sleep (bool arg) throws IOError;
}

class Systemd: IProvider, Object
{
    iLogin1 proxy;

    public Systemd ()
    {
        try {
            proxy = Bus.get_proxy_sync (BusType.SYSTEM,
                "org.freedesktop.login1",
                "/org/freedesktop/login1");
        }
        catch (IOError e) {
            proxy = null;
            stdout.printf("--------- %s", e.message);
        }
    }

    public bool query(Action action) {
        if (proxy == null)
            return false;

        try {
            switch (action) {
                case Action.HIBERNATE:
                    return (proxy.can_hibernate() == "yes");

                case Action.HYBRID_SLEEP:
                    return (proxy.can_hybrid_sleep() == "yes");

                case Action.POWEROFF:
                    return (proxy.can_power_off() == "yes");

                case Action.REBOOT:
                    return (proxy.can_reboot() == "yes");

                case Action.SUSPEND:
                    return (proxy.can_suspend() == "yes");

                default:
                    return false;
            }
        }
        catch (IOError e) {
            return false;
        }
    }

    public void execute (Action action) {
        if (proxy == null)
            return;

        try {
            switch (action) {
                case Action.HIBERNATE:
                    proxy.hibernate(true);
                    break;

                case Action.HYBRID_SLEEP:
                    proxy.hybrid_sleep(true);
                    break;

                case Action.POWEROFF:
                    proxy.power_off(true);
                    break;

                case Action.REBOOT:
                    proxy.reboot(true);
                    break;

                case Action.SUSPEND:
                    proxy.suspend(true);
                    break;
            }
        }
        catch (IOError e) {
            message("%s", e.message);
        }
    }

    public string get_name() {
        return "Systemd";
    }
}
