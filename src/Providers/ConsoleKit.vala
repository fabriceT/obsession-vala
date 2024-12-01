[DBus (name = "org.freedesktop.ConsoleKit.Manager")]
interface iConsoleKit : Object {
    public abstract string can_stop () throws IOError;
    public abstract string can_restart () throws IOError;
    public abstract void stop (bool arg) throws IOError;
    public abstract void restart (bool arg) throws IOError;
}

class ConsoleKit: IProvider, Object
{
    iConsoleKit proxy;

    public ConsoleKit()
    {
        try {
            proxy = Bus.get_proxy_sync (BusType.SYSTEM,
                "org.freedesktop.ConsoleKit",
                "org/freedesktop/ConsoleKit/Manager");
        }
        catch (IOError e) {
            proxy = null;
            stdout.printf("--------- %s", e.message);
        }
    }

    public bool query(Action action) {
        if (proxy == null)
        {
            return false;
        }

        try {
            switch (action) {
                case Action.POWEROFF:
                    return (proxy.can_stop() == "yes");

                case Action.REBOOT:
                    return (proxy.can_restart() == "yes");

                default:
                    return false;
            }
        }
        catch (IOError e) {
            stdout.printf("---------- %s\n", e.message);
            return false;
        }
    }

    public void execute (Action action) {
        if (proxy == null)
            return;

        try {
            switch (action) {
                case Action.POWEROFF:
                    proxy.stop(true);
                    break;

                case Action.REBOOT:
                    proxy.restart(true);
                    break;
            }
        }
        catch (IOError e) {
            message("%s", e.message);
        }
    }

    public string get_name() {
        return "ConsoleKit";
    }

}
