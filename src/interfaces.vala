enum PowerAction {
    HIBERNATE,
    SUSPEND,
    REBOOT,
    POWEROFF,
    HYBRID_SLEEP
}

interface IProvider : Object {
    public abstract bool query (PowerAction action);
    public abstract void execute (PowerAction action);
    public abstract string get_name ();
}
