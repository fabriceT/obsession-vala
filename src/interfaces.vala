enum Action {
    HIBERNATE,
    SUSPEND,
    REBOOT,
    POWEROFF,
    HYBRID_SLEEP
}

interface IProvider : Object {
    public abstract bool query (Action action);
    public abstract void execute (Action action);
    public abstract string get_name ();
}
