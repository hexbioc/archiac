import subprocess

from libqtile import bar, widget
from libqtile.log_utils import logger
from libqtile.config import Screen


def _get_monitor_count():
    xrandr_cmd = "xrandr --listactivemonitors | sed -n -r 's/^Monitors: ([0-9]+)/\1/p'"
    try:
        with subprocess.Popen(xrandr_cmd, stdout=subprocess.PIPE, shell=True) as proc:
            return ord(proc.stdout.readline().strip())
    except Exception:
        logger.exception("Error while trying to count monitors")

    return 1

def _get_secondary_bar():
    return bar.Bar(
        [
            widget.CurrentLayout(),
            widget.GroupBox(),
            widget.Prompt(),
            widget.WindowName(),
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
        ],
        36,
        # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
        # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    )

def _get_secondary_screens():
    return [
        Screen(
            bottom=_get_secondary_bar(),
        ) for _ in range(_get_monitor_count())
    ]


_primary_bar = bar.Bar(
    [
        widget.CurrentLayout(),
        widget.GroupBox(),
        widget.Prompt(),
        widget.WindowName(),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        widget.Systray(),
        widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
        widget.QuickExit(),
    ],
    36,
    # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
    # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
)

_primary_screen = Screen(
    bottom=_primary_bar,
)

screens = [
    _primary_screen,
    *_get_secondary_screens(),
]
