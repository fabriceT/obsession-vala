class ObSessionCli : Application {
    private PowerManager pm;

    public ObSessionCli () {
        pm = new PowerManager ();
    }

    public override void activate () {
        pm.display_providers ();
    }

    public static int main (string[] args) {
        var app = new ObSessionCli ();
        return app.run ();
    }
}
