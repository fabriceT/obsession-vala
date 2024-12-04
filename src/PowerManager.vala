class PowerManager {

    private IProvider systemd;
    private IProvider consolekit;
    private IProvider upower;
    private IProvider fallback;

    private IProvider? suspend_provider = null;
    private IProvider? hibernate_provider = null;
    private IProvider? hybrid_sleep_provider = null;
    private IProvider? reboot_provider = null;
    private IProvider? poweroff_provider = null;


    public PowerManager () {
        systemd = new Systemd ();
        load_capabilities (systemd);

        consolekit = new ConsoleKit ();
        load_capabilities (consolekit);

        upower = new UPower ();
        load_capabilities (upower);

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
                    //  message ("Adding %s for suspend action", provider.get_name ());
                    suspend_provider = provider;
                }
                break;

            case PowerAction.HIBERNATE:
                if (!has_hibernate && provider.query (action) == true) {
                    //  message ("Adding %s for hibernation action", provider.get_name ());
                    hibernate_provider = provider;
                }
                break;

            case PowerAction.HYBRID_SLEEP:
                if (!has_hybrid_sleep && provider.query (action) == true) {
                    //  message ("Adding %s for hybrid sleep action", provider.get_name ());
                    hybrid_sleep_provider = provider;
                }
                break;

            case PowerAction.REBOOT:
                if (!has_reboot && provider.query (action) == true) {
                    //  message ("Adding %s for reboot action", provider.get_name ());
                    reboot_provider = provider;
                }
                break;

            case PowerAction.POWEROFF:
                if (!has_poweroff && provider.query (action) == true) {
                    //  message ("Adding %s for poweroff action", provider.get_name ());
                    poweroff_provider = provider;
                }
                break;
        }
    }


    private void load_capabilities (IProvider provider) {
        get_capability (provider, PowerAction.HIBERNATE);
        get_capability (provider, PowerAction.HYBRID_SLEEP);
        get_capability (provider, PowerAction.POWEROFF);
        get_capability (provider, PowerAction.REBOOT);
        get_capability (provider, PowerAction.SUSPEND);
    }


    public void execute_action (PowerAction action) {
        switch (action) {
            case PowerAction.SUSPEND:
                stdout.puts ("suspend");
                suspend_provider.execute (PowerAction.SUSPEND);
                break;

            case PowerAction.HIBERNATE:
                stdout.puts ("hibernate");
                hibernate_provider.execute (PowerAction.HIBERNATE);
                break;

            case PowerAction.HYBRID_SLEEP:
                stdout.puts ("hybrid_sleep");
                hybrid_sleep_provider.execute (PowerAction.HYBRID_SLEEP);
                break;

            case PowerAction.REBOOT:
                stdout.puts ("reboot");
                reboot_provider.execute (PowerAction.REBOOT);
                break;

            case PowerAction.POWEROFF:
                stdout.puts ("poweroff");
                poweroff_provider.execute (PowerAction.POWEROFF);
                break;
        }
    }


    public void display_providers () {
        stdout.printf ("Suspend: %s\n", suspend_provider.get_name ());
        stdout.printf ("Hibernate: %s\n", hibernate_provider.get_name ());
        stdout.printf ("Hybrid sleep: %s\n", hybrid_sleep_provider.get_name ());
        stdout.printf ("Reboot: %s\n", reboot_provider.get_name ());
        stdout.printf ("Power off: %s\n", poweroff_provider.get_name ());
    }
}
