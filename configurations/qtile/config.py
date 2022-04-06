from custom.screens import screens
from custom.groups import groups
from custom.bindings import keys, mouse
from custom.layouts import layouts, floating_layout
from custom.widgets import widget_defaults, extension_defaults


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# Hack from the default config for some java application support
# Read more in the default config
wmname = "LG3D"
