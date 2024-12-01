using Gtk;

class ObSessionWindow : Gtk.Window {

    private static string CSS_DATA =
    """
        button {
            font-weight: bold;
        }

        .cancel:hover {
            color: green;
            border: 1px solid green;
        }

        .poweroff:hover {
            color: red;
            border: 1px solid red;
        }

        .suspend:hover {
            color: blue;
            border: 1px solid blue;
        }

        .hibernate:hover {
            color: navy;
            border: 1px solid navy;
        }

        .reboot:hover {
            color: black;
            border: 1px solid black;
        }
    """;

    PowerManager pw;
    int row_pos;

    public ObSessionWindow() {
        pw = new PowerManager();
        this.title = "Obsession";
        this.set_default_size(480, 200);
        this.destroy.connect (Gtk.main_quit);
        this.set_decorated (false);
        set_position (Gtk.WindowPosition.CENTER);

        var screen = Gdk.Screen.get_default();
        var css_provider = new Gtk.CssProvider();

        try {
            css_provider.load_from_data(CSS_DATA, -1);
        }
        catch (Error error) {
            warning ("Error loading CSS data %s", error.message);
        }

        Gtk.StyleContext.add_provider_for_screen(
            screen,
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        build_ui();
    }

    public void build_ui() {
        Gtk.Grid grid;
        Gtk.Button btn_quit = null;
        Gtk.Button btn_reboot = null;
        Gtk.Button btn_poweroff = null;
        Gtk.Button btn_hibernate = null;


        grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.HORIZONTAL;
        grid.column_homogeneous = true;
        grid.column_spacing = 0;
        grid.row_homogeneous = true;
        grid.row_spacing = 6;

        btn_quit = new Gtk.Button.with_label (_("Cancel"));
        btn_quit.get_style_context().add_class("cancel");
        btn_quit.clicked.connect (() => { Gtk.main_quit(); });
        add_row(grid, btn_quit);

        if (pw.has_hibernate)
        {
            btn_hibernate = new Gtk.Button.with_label(_("Hibernate"));
            btn_hibernate.get_style_context().add_class("hibernate");
            btn_hibernate.clicked.connect (() => {
                pw.hibernate();
                Gtk.main_quit();
            });
            add_row(grid, btn_hibernate);
        }

        if (pw.has_reboot)
        {
            btn_reboot = new Gtk.Button.with_label (_("Reboot"));
            btn_reboot.get_style_context().add_class("reboot");
            btn_reboot.clicked.connect (() => {
                pw.reboot();
                Gtk.main_quit();
            });
            add_row(grid, btn_reboot);
        }

        if (pw.has_poweroff)
        {
            btn_poweroff = new Gtk.Button.with_label (_("Turn off"));
            btn_poweroff.get_style_context().add_class("poweroff");
            btn_poweroff.clicked.connect (() => {
                pw.poweroff();
                Gtk.main_quit();
             });
             add_row(grid, btn_poweroff);
        }



        /***************
         * Is there any real use for this? Closing LID triggers sleep mode.
         *
        if (pw.has_suspend)
        {
            var button_suspend = new Gtk.Button.with_label (_("Suspend"));
            button_suspend.clicked.connect (() => {
                pw.suspend();
                Gtk.main_quit(); });
            grid.add(button_suspend);
        }

        if (pw.has_hybrid_sleep)
        {
            var button_hSleep = new Gtk.Button.with_label (_("Sleep"));
            button_hSleep.clicked.connect (() => {
                pw.hybrid_sleep();
                Gtk.main_quit(); });
            grid.add(button_hSleep);
        }*************/

        Label label = new Gtk.Label (_("You are about to exit the session."));
        grid.attach(label, 0, 0, row_pos, 2);

        this.add(grid);
    }

    private void add_row(Grid grid, Button btn) {
        if (btn == null)
            return;

        grid.attach(btn, row_pos, 2, 1, 1);
        row_pos++;
    }



    static int main (string[] args) {

        GLib.Intl.setlocale(GLib.LocaleCategory.ALL, "");
        GLib.Intl.bindtextdomain(Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        GLib.Intl.textdomain(Config.GETTEXT_PACKAGE);

        message("%s - %s\n", Config.GETTEXT_PACKAGE, Config.LOCALEDIR);

        Gtk.init (ref args);

        var app = new ObSessionWindow();
        app.show_all ();
        Gtk.main ();
        return 0;
    }
}


