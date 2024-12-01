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

    public PowerManager() {
        systemd = new Systemd();
        load_capabilities (systemd);

        upower = new UPower();
        load_capabilities (upower);

        consolekit = new ConsoleKit();
        load_capabilities (consolekit);

        fallback = new Fallback();
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

    private void get_capability (IProvider provider, Action action)
    {
        switch (action) {
            case Action.SUSPEND:
                if (!this.has_suspend && provider.query(action) == true) {
                    message("Adding %s for suspend action", provider.get_name());
                    suspend_provider = provider;
                }
                break;

            case Action.HIBERNATE:
                if (!has_hibernate && provider.query(action) == true) {
                    message("Adding %s for hibernation action", provider.get_name());
                    hibernate_provider = provider;
                }
                break;

            case Action.HYBRID_SLEEP:
                if (!has_hybrid_sleep && provider.query(action) == true) {
                    message("Adding %s for hybrid sleep action", provider.get_name());
                    hybrid_sleep_provider = provider;
                }
                break;

            case Action.REBOOT:
                if (!has_reboot && provider.query(action) == true) {
                    message("Adding %s for reboot action", provider.get_name());
                    reboot_provider = provider;
                }
                break;

            case Action.POWEROFF:
                if (!has_poweroff && provider.query(action) == true) {
                    message("Adding %s for poweroff action", provider.get_name());
                    poweroff_provider = provider;
                }
                break;
        }
    }

    private void load_capabilities(IProvider provider) {
        get_capability(provider, Action.SUSPEND);
        get_capability(provider, Action.HIBERNATE);
        get_capability(provider, Action.HYBRID_SLEEP);
        get_capability(provider, Action.REBOOT);
        get_capability(provider, Action.POWEROFF);
    }

    public void execute(Action action) {
        switch (action) {
            case Action.SUSPEND:
                if (suspend_provider != null)
                    suspend_provider.execute(Action.SUSPEND);
                break;

            case Action.HIBERNATE:
                if (hibernate_provider != null)
                    hibernate_provider.execute(Action.HIBERNATE);
                break;

            case Action.HYBRID_SLEEP:
                if (hybrid_sleep_provider != null)
                    hybrid_sleep_provider.execute(Action.HYBRID_SLEEP);
                break;

            case Action.REBOOT:
                if (reboot_provider != null)
                    reboot_provider.execute(Action.REBOOT);
                break;

            case Action.POWEROFF:
                if (poweroff_provider != null)
                    poweroff_provider.execute(Action.POWEROFF);
                break;
        }
    }

    public void suspend() {
        execute(Action.SUSPEND);
    }

    public void hibernate() {
        execute(Action.HIBERNATE);
    }

    public void hybrid_sleep() {
        execute(Action.HYBRID_SLEEP);
    }

    public void reboot() {
        execute(Action.REBOOT);
    }

    public void poweroff() {
        execute(Action.POWEROFF);
    }

    public void display_providers()
    {
        if (suspend_provider != null)
            stdout.printf("\nSuspend: %s\n", suspend_provider.get_name());

        if (hibernate_provider != null)
            stdout.printf("Hibernate: %s\n", hibernate_provider.get_name());

        if (hybrid_sleep_provider != null)
            stdout.printf("Hybrid sleep: %s\n", hybrid_sleep_provider.get_name());

        if (reboot_provider != null)
            stdout.printf("Reboot: %s\n", reboot_provider.get_name());

        if (poweroff_provider != null)
            stdout.printf("Power off: %s\n", poweroff_provider.get_name());
    }
}
