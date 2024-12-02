class PowerManager {

    private IProvider systemd;
    private IProvider upower;
    private IProvider consolekit;
    private IProvider fallback;

    private IProvider? suspend_provider = null;
    private IProvider? hibernate_provider = null;
    private IProvider? hybrid_sleep_provider = null;
    private IProvider? reboot_provider = null;
    private IProvider? poweroff_provider = null;

    public PowerManager () {
        systemd = new Systemd ();
        load_capabilities (systemd);

        upower = new UPower ();
        load_capabilities (upower);

        consolekit = new ConsoleKit ();
        load_capabilities (consolekit);

        fallback = new Fallback ();
        load_capabilities (fallback);
    }

    public bool has_suspend {
        get { return (suspend_provider != null); }
    }

    public bool has_hibernate {
        get { return (hibernate_provider != null); }
    }

    public bool has_hybrid_sleep {
        get { return (hybrid_sleep_provider != null); }
    }

    public bool has_reboot {
        get { return (reboot_provider != null); }
    }

    public bool has_poweroff {
        get { return (poweroff_provider != null); }
    }

    private void get_capability (IProvider provider, PowerAction action) {
        switch (action) {
            case PowerAction.SUSPEND:
                if (!this.has_suspend && provider.query (action) == true) {
                    message ("Adding %s for suspend Poweraction", provider.get_name ());
                    suspend_provider = provider;
                }
                break;

            case PowerAction.HIBERNATE:
                if (!has_hibernate && provider.query (action) == true) {
                    message ("Adding %s for hibernation Poweraction", provider.get_name ());
                    hibernate_provider = provider;
                }
                break;

            case PowerAction.HYBRID_SLEEP:
                if (!has_hybrid_sleep && provider.query (action) == true) {
                    message ("Adding %s for hybrid sleep Poweraction", provider.get_name ());
                    hybrid_sleep_provider = provider;
                }
                break;

            case PowerAction.REBOOT:
                if (!has_reboot && provider.query (action) == true) {
                    message ("Adding %s for reboot Poweraction", provider.get_name ());
                    reboot_provider = provider;
                }
                break;

            case PowerAction.POWEROFF:
                if (!has_poweroff && provider.query (action) == true) {
                    message ("Adding %s for poweroff Poweraction", provider.get_name ());
                    poweroff_provider = provider;
                }
                break;
        }
    }

    private void load_capabilities (IProvider provider) {
        get_capability (provider, PowerAction.SUSPEND);
        get_capability (provider, PowerAction.HIBERNATE);
        get_capability (provider, PowerAction.HYBRID_SLEEP);
        get_capability (provider, PowerAction.REBOOT);
        get_capability (provider, PowerAction.POWEROFF);
    }


    public void suspend () {
        if (suspend_provider != null)
            suspend_provider.execute (PowerAction.SUSPEND);
    }

    public void hibernate () {
        if (hibernate_provider != null)
            hibernate_provider.execute (PowerAction.HIBERNATE);
    }

    public void hybrid_sleep () {
        if (hybrid_sleep_provider != null)
            hybrid_sleep_provider.execute (PowerAction.HYBRID_SLEEP);
    }

    public void reboot () {
        if (reboot_provider != null)
            reboot_provider.execute (PowerAction.REBOOT);
    }

    public void poweroff () {
        if (poweroff_provider != null)
            poweroff_provider.execute (PowerAction.POWEROFF);
    }

    public void display_providers () {
        if (suspend_provider != null)
            stdout.printf ("\nSuspend: %s\n", suspend_provider.get_name ());

        if (hibernate_provider != null)
            stdout.printf ("Hibernate: %s\n", hibernate_provider.get_name ());

        if (hybrid_sleep_provider != null)
            stdout.printf ("Hybrid sleep: %s\n", hybrid_sleep_provider.get_name ());

        if (reboot_provider != null)
            stdout.printf ("Reboot: %s\n", reboot_provider.get_name ());

        if (poweroff_provider != null)
            stdout.printf ("Power off: %s\n", poweroff_provider.get_name ());
    }
}
