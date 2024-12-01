project('obsession','c', 'vala',
  version: '0.1.0',
  meson_version: '>= 0.40.0',
)

# make i18n works.
i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE=' + meson.project_name(), language: 'c')

# get useful informations
prefix = get_option('prefix')
localedir = join_paths(prefix, get_option('localedir'))

# configuration
conf = configuration_data()
conf.set_quoted('VERSION', '1.2.0')
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('LOCALEDIR', localedir)
config_h = configure_file(output : 'config.h', configuration : conf)

# run in subdirs
subdir('src')
subdir('po')
