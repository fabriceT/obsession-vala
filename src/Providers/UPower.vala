[DBus (name = "org.freedesktop.UPower")]
interface iUPower : Object {
    public abstract string suspend_allowed () throws IOError;
    public abstract string hibernate_allowed () throws IOError;
    public abstract void suspend (bool arg) throws IOError;
    public abstract void hibernate (bool arg) throws IOError;
}

class UPower: IProvider, Object
{
    iUPower proxy;

    public UPower() {
        try {
            proxy = Bus.get_proxy_sync (BusType.SYSTEM,
                    "org.freedesktop.UPower",
                    "/org/freedesktop/UPower");
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
                    return (proxy.hibernate_allowed() == "yes");

                case Action.SUSPEND:
                    return (proxy.suspend_allowed() == "yes");

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
        return "UPower";
    }
}
