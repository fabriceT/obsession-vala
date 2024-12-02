common_sources = [
  '../vapi/config.vapi',
  'Providers/ConsoleKit.vala',
  'Providers/Fallback.vala',
  'Providers/Systemd.vala',
  'Providers/UPower.vala',
  'PowerManager.vala',
  'interfaces.vala'
]

gio = dependency('gio-2.0', version: '>= 2.50')

config_h = configure_file(output : 'config.h', configuration : conf)

# if get_option('gui')
#  gtk = dependency('gtk+-3.0', version: '>= 3.22')

  # Gtk version
#  executable('obsession-gtk', ['ObSessionWindow.vala', common_sources ],
#    dependencies: [ gtk, gio ],
#    install: true,
#  )
#endif

# Cli version
executable('obsession-cli', ['ObSessionCli.vala', common_sources ],
  dependencies: [ gio ],
  install: true,
)
