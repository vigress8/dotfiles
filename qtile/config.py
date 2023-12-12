from typing import List  # noqa: F401
import os
import subprocess
from os import path

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, ScratchPad, DropDown, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.widget.backlight import ChangeDirection
from libqtile.widget.battery import Battery, BatteryState
import qtile_extras.widget as extra_widget
from qtile_extras.widget.decorations import RectDecoration
import colors
qtile_path = path.join(path.expanduser('~'), ".config", "qtile")

# Important variables for ease of configuration
mod = "mod4"
terminal = "kitty"
launcher = "rofi -show "
player = "playerctl "
browser = "firefox"
up = "Up"
down = "Down"
left = "Left"
right = "Right"

colors, backgroundColor, foregroundColor, workspaceColor, chordColor = colors.everforest()

IS_WAYLAND: bool = qtile.core.name == "wayland"
if IS_WAYLAND:
    tray = extra_widget.StatusNotifier(background = backgroundColor, icon_theme = "Papirus-Dark", icon_size = 20, padding = 4)
else:
    tray = widget.Systray(background = backgroundColor, icon_theme= "Papirus-Dark", icon_size = 20, padding = 4)

keys = [
# Open terminal
    Key([mod], "Return", lazy.spawn(terminal)),
# Qtile System Actions
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "x", lazy.shutdown()),
# Active Window Actions
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], right,
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete()
        ),
    Key([mod, "control"], left,
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add()
        ),
    Key([mod, "control"], up,
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster()
        ),
    Key([mod, "control"], down,
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster()
        ),

# Window Focus (Arrows and Vim keys)
    Key([mod], up, lazy.layout.up()),
    Key([mod], down, lazy.layout.down()),
    Key([mod], left, lazy.layout.left()),
    Key([mod], right, lazy.layout.right()),
# Qtile Layout Actions
    Key([mod], "r", lazy.layout.reset()),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "shift"], "f", lazy.layout.flip()),
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),

# Move windows around MonadTall/MonadWide Layouts
    Key([mod, "shift"], up, lazy.layout.shuffle_up()),
    Key([mod, "shift"], down, lazy.layout.shuffle_down()),
    Key([mod, "shift"], left, lazy.layout.swap_left()),
    Key([mod, "shift"], right, lazy.layout.swap_right()),

# Change keyboard layout
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout."),
# Volume
    Key([], "XF86AudioRaiseVolume", lazy.widget["pulsevolume"].increase_vol()),
    Key([], "XF86AudioLowerVolume", lazy.widget["pulsevolume"].decrease_vol()),
    Key([], "XF86AudioMute", lazy.widget["pulsevolume"].mute()),
# Brightness
    Key([], "XF86MonBrightnessUp", lazy.widget["backlight"].change_backlight(ChangeDirection.UP)),
    Key([], "XF86MonBrightnessDown", lazy.widget["backlight"].change_backlight(ChangeDirection.DOWN)),
    Key([mod, "shift"], "Return", lazy.spawn(launcher + "drun")),
# Play/pause
    Key([], "XF86AudioPlay", lazy.spawn(player + "play-pause")),
    Key([], "XF86AudioPrev", lazy.spawn(player + "previous")),
    Key([], "XF86AudioNext", lazy.spawn(player + "next")),
]

# Create labels for groups and assign them a default layout.
groups = []
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
group_labels = ["󰖟", "", "", "", "", "", "", "ﭮ", "", ""]
group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]

# Add group names, labels, and default layouts to the groups object.
for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

# Add group specific keybindings
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Mod + number to move to that group."),
        Key([mod], "Tab", lazy.screen.next_group(), desc="Move to next group."),
        Key([mod, "shift"], "Tab", lazy.screen.prev_group(), desc="Move to previous group."),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc="Move focused window to new group."),
    ])

# Define scratchpads
groups.append(ScratchPad("scratchpad", [
    DropDown("term", "kitty --class=scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("term2", "kitty --class=scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("lf", "kitty --class=lf -e lf", width=0.8, height=0.8, x=0.1, y=0.1, opacity=0.9),
]))

# Scratchpad keybindings
keys.extend([
    Key([mod], "n", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([mod], "c", lazy.group['scratchpad'].dropdown_toggle('lf')),
    Key([mod, "shift"], "n", lazy.group['scratchpad'].dropdown_toggle('term2')),
])


# Define layouts and layout themes
layout_theme = {
        "margin": 5,
        "border_width": 4,
        "border_focus": colors[2],
        "border_normal": backgroundColor
    }

layouts = [
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    layout.Floating(**layout_theme),
    # layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme)
]

# Define Widgets
widget_defaults = dict(
    font="JetBrainsMono Nerd Font Bold",
    fontsize = 14,
    padding = 2,
    background=backgroundColor
)

def init_widgets_list(monitor_num):
    widgets_list = [
        widget.Image(
            filename = "~/.config/qtile/icons/logo.png",
            scale = "True",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(launcher + "drun")},
        ),
        widget.GroupBox(
            fontsize = 16,
            margin_y = 2,
            margin_x = 4,
            padding_y = 6,
            padding_x = 6,
            borderwidth = 2,
            disable_drag = True,
            active = colors[4],
            inactive = foregroundColor,
            hide_unused = True,
            rounded = False,
            highlight_method = "line",
            highlight_color = [backgroundColor, backgroundColor],
            this_current_screen_border = colors[5],
            this_screen_border = colors[7],
            other_screen_border = colors[6],
            other_current_screen_border = colors[6],
            urgent_alert_method = "line",
            urgent_border = colors[9],
            urgent_text = colors[1],
            foreground = foregroundColor,
            background = backgroundColor,
            use_mouse_wheel = False
        ),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[5],background = backgroundColor),
        widget.TaskList(
            icon_size = 15,
            foreground = colors[0],
            background = colors[2],
            borderwidth = 0,
            border = colors[6],
            margin = 0,
            padding = 8,
            highlight_method = "block",
            title_width_method = "uniform",
            urgent_alert_method = "border",
            urgent_border = colors[1],
            rounded = False,
            txt_floating = "🗗 ",
            txt_maximized = "🗖 ",
            txt_minimized = "🗕 ",
        ),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0],background = colors[0]),
        widget.PulseVolume(
                    limit_max_volume = True,
                    foreground = colors[6],
                    fmt='󰕾 {}',
                    padding=10,
                    step=5,
                ),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0],background = backgroundColor),
        widget.KeyboardLayout(foreground = colors[6], fmt = '⌨️ {}', configured_keyboards = ['us', 'ru']),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0],background = backgroundColor),
        widget.Battery(foreground = colors[5], format = '{percent:1.0%}', fmt = '🔋 {}'),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0],background = backgroundColor),
        widget.Backlight(foreground = colors[8], fmt = '🌣 {}', backlight_name = 'intel_backlight', change_command = 'brightnessctl s {0}%', step = 5),
        widget.Sep(linewidth = 0, padding = 10),
        widget.CPU(
            fmt = ' {}',
            update_interval = 1.0,
            format = '{load_percent}%',
            foreground = colors[4],
            padding = 5,
        ),
        widget.Sep(linewidth = 0, padding = 10),
        widget.Memory(
            foreground = colors[3],
            format = '🖥 {MemUsed: .0f}{mm}', 
            padding = 5,
        ),
        widget.Sep(linewidth = 0, padding = 10),
        widget.Clock(format='%H:%M', fmt=" {}", padding = 10, foreground = colors[10]),
        tray,
        widget.Sep(linewidth = 0, padding = 5), 
        widget.CurrentLayoutIcon(scale = 0.5, padding = 5, foreground = colors[6], background = colors[6]),
        #widget.Wallpaper(wallpaper = "suna.jpg", fmt = ''),
    ]

    return widgets_list

def init_secondary_widgets_list(monitor_num):
    secondary_widgets_list = init_widgets_list(monitor_num)
    del secondary_widgets_list[14:16]
    return secondary_widgets_list

widgets_list = init_widgets_list("1")
secondary_widgets_list = init_secondary_widgets_list("2")

screens = [
    Screen(top=bar.Bar(widgets=widgets_list, size=36, background=backgroundColor, margin=6, opacity=0.8),),
    Screen(top=bar.Bar(widgets=secondary_widgets_list, size=36, background=backgroundColor, margin=6, opacity=0.8),),
    ]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

@hook.subscribe.startup_once
def autostart():
   home = os.path.expanduser('~/.config/qtile/autostart.sh')
   subprocess.run([home])

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(wm_class='pavucontrol'),
    Match(wm_class='blueman-manager'),
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='GalaxyBudsClient'),
    Match(wm_class='keepassxc'),
], fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True
wmname = "Qtile"
