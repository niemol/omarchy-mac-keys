# Omarchy Mac Keys

**macOS keyboard shortcuts for [Omarchy](https://omarchy.org).**

> [!IMPORTANT]
> Omarchy is an opinionated setup, and much of that opinion lives on the
> keyboard. Out of the box, the Super key runs the desktop: Super+W closes a
> window, Super+T floats it, Super+F goes full screen, Super+1…9 switch
> workspaces, Super+arrows move focus between tiled windows. It is fast once
> learned, but it is its own system.
>
> **This module changes that a lot.** It gives the Super key back to apps and
> text, the way Cmd works on a Mac, and moves Omarchy's window management out of
> the way. The result feels much more like a traditional Mac. If you like
> Omarchy's keyboard-driven defaults as they are, this is probably not for you.

Coming from a Mac? This makes the Cmd key work the way your fingers expect:
Cmd+T opens a tab, Cmd+Z undoes, Cmd+Left jumps to the start of the line,
Option+Left moves by word, Shift+Cmd+4 takes a screenshot. Omarchy's own
window-management shortcuts that used those keys move to **Ctrl+Cmd**, the
combination macOS itself uses for window functions.

Omarchy already does part of this: Cmd+C / V / X / A are its "universal
clipboard". This module carries the same idea through the rest of the keyboard.

> On a PC keyboard, Cmd is the **Super** (Windows) key and Option is **Alt**.
> On a Mac-layout keyboard (or one switched to Mac mode), Cmd sits next to the
> space bar, as on a Mac.

## Install

```bash
git clone https://github.com/niemol/omarchy-mac-keys ~/.local/share/omarchy-mac-keys
```

Then add this line to the **end** of `~/.config/hypr/hyprland.lua`:

```lua
dofile(os.getenv("HOME") .. "/.local/share/omarchy-mac-keys/mac-keys.lua")({})
```

Hyprland reloads its config on save. Update later with
`git -C ~/.local/share/omarchy-mac-keys pull`.

**Recommended:** install [Omarchy App Switcher](https://github.com/niemol/omarchy-app-switcher)
for a real Cmd+Tab. When it is installed, this module binds Cmd+Tab to it
automatically.

## Shortcuts

### Apps

In apps, Cmd sends the Ctrl shortcut. In terminals, Cmd+C / V / T / W / N / F
send Ctrl+Shift instead, so Ctrl+C still stops a process.

| Mac | Action | Omarchy's function that moved |
|---|---|---|
| ⌘C ⌘V ⌘X ⌘A | Copy, paste, cut, select all | *(Omarchy default)* |
| ⌘Z / ⇧⌘Z | Undo / redo | |
| ⌘S / ⇧⌘S | Save / save as | Scratchpad → ⌃⌘S · Google Maps (removed) |
| ⌘F | Find | Full screen → ⌃⌘F |
| ⌘G / ⇧⌘G | Find next / previous | Grouping → ⌃⌘G · Signal (removed) |
| ⌘T / ⇧⌘T | New tab / reopen closed tab | Float/tile → ⌃⌘T · Activity (removed) |
| ⌘W | Close tab | Close window stays on ⌘Q |
| ⌘N / ⇧⌘N | New window / private window or folder | Editor (removed) |
| ⌘R | Reload | |
| ⌘L | Address bar | Workspace layout → ⌃⌘L |
| ⌘P | Print | Pseudo window → ⌃⌥⌘P |
| ⌘O | Open | Pop window out → ⌃⌥⌘O |
| ⌘B ⌘I ⌘U | Bold, italic, underline | Input language → ⌃⌥⌘I |
| ⌘D | Bookmark | |
| ⌘, | Settings | Notification → ⌃⌥⌘, |
| ⌘+ / ⌘- / ⌘0 | Zoom in / out / reset | Resize window (⌃⌘ / ⌥⌘ variants stay) |
| ⌘1 … ⌘9 | Go to tab | Workspaces → ⌃⌘1 … ⌃⌘9 |

### Text

| Mac | Action | Omarchy's function that moved |
|---|---|---|
| ⌘← / ⌘→ | Start / end of line | Focus window → ⌃⌘arrows |
| ⌘↑ / ⌘↓ | Start / end of document | |
| ⇧ + the above | Select to there | Swap window → ⌃⇧⌘arrows |
| ⌥← / ⌥→ (+⇧) | Previous / next word (select) | |
| ⌥⌫ | Delete word | |
| ⌘⌫ | Delete to start of line | Window transparency → ⌃⌘⌫ |

### Windows and desktops

| Mac | Action | Notes |
|---|---|---|
| ⌘Tab / ⇧⌘Tab | App switcher | Needs [Omarchy App Switcher](https://github.com/niemol/omarchy-app-switcher). Omarchy's next/previous workspace moves to ⌃→ / ⌃← |
| ⌘Space | Omarchy menu | *(Omarchy default)* |
| ⌘Q | Close window | *(Omarchy default)* |
| ⌘M / ⌘H | Minimize to the dock | ⌘M is Omarchy's default; ⌘H "hides" the same way |
| ⌥⌘Esc | Force quit | |
| ⌃⌘F | Full screen | Omarchy's "tiled full screen" → ⌃⇧⌘F |
| ⌃⌘Q | Lock screen | Was ⌃⌘L, which now cycles the workspace layout |
| ⌃⌘Space | Emoji picker | Background switcher stays on ⌃⌘W |
| ⌃← / ⌃→ | Previous / next desktop | |
| ⌃⌘1 … ⌃⌘9 | Go to desktop | Move window there: ⌃⇧⌘1 … ⌃⇧⌘9 |
| ⇧⌘3 / ⇧⌘4 / ⇧⌘5 | Screenshot: full screen / region / capture menu | Opens Omarchy's screenshot tool |

### Moved Omarchy shortcuts at a glance

| Omarchy function | Was | Now |
|---|---|---|
| Switch / move to workspace | ⌘1-9 / ⇧⌘1-9 | ⌃⌘1-9 / ⌃⇧⌘1-9 |
| Next / previous workspace | ⌘Tab / ⇧⌘Tab | ⌃→ / ⌃← |
| Focus / swap window | ⌘arrows / ⇧⌘arrows | ⌃⌘arrows / ⌃⇧⌘arrows |
| Grouped window focus | ⌃⌘← / ⌃⌘→ | ⌃⌥⌘← / ⌃⌥⌘→ |
| Move window to monitor | ⌃⇧⌘arrows | ⌃⇧⌥⌘arrows |
| Close window | ⌘W or ⌘Q | ⌘Q |
| Full screen / tiled full screen | ⌘F / ⌃⌘F | ⌃⌘F / ⌃⇧⌘F |
| Float / tile | ⌘T | ⌃⌘T |
| Workspace layout | ⌘L | ⌃⌘L |
| Lock | ⌃⌘L | ⌃⌘Q |
| Scratchpad / share | ⌘S / ⌃⌘S | ⌃⌘S / ⌃⌥⌘S |
| Window grouping | ⌘G | ⌃⌘G |
| Pseudo window / pop out | ⌘P / ⌘O | ⌃⌥⌘P / ⌃⌥⌘O |
| Input language | ⌘I | ⌃⌥⌘I |
| Last notification | ⌘, | ⌃⌥⌘, |
| Transparency / square aspect | ⌘⌫ / ⌃⌘⌫ | ⌃⌘⌫ / ⌃⌥⌘⌫ |
| Emoji picker | ⌃⌘E | ⌃⌘Space (⌃⌘E still works) |
| Google Maps, Signal, Editor, Activity | ⇧⌘S, ⇧⌘G, ⇧⌘N, ⇧⌘T | Removed (open them from the app launcher) |

## Options

```lua
dofile(os.getenv("HOME") .. "/.local/share/omarchy-mac-keys/mac-keys.lua")({
  mac_layout = "fi",        -- switch the keyboard to its Macintosh variant (fi, se, de, ...)
  app_switcher = "auto",    -- Cmd+Tab via Omarchy App Switcher: true, false or "auto"
  desktop_arrows = true,    -- Ctrl+Left/Right switch desktops
  word_navigation = true,   -- Option+Left/Right/Backspace work by word
  screenshots = true,       -- Shift+Cmd+3/4/5
  alt_tab_classes = { "^firefox$", "^librewolf$", "^zen$" }, -- apps that pick tabs with Alt+N
})
```

### Mac keyboard layout

`mac_layout` switches your layout to its Macintosh variant, so special
characters sit where they do on a Mac. On the Finnish/Swedish Mac layout, for
example, @ is Option+2 and the brackets are Option+8 / 9.

In the Linux Mac layouts only the **right** Option key types special
characters. The left one stays Alt, which keeps Option+arrows and Omarchy's
Super+Alt shortcuts working.

## Differences from macOS

- **⌘Q** closes the window, not the whole app, and **⌘H** minimizes instead of
  hiding: Linux has no notion of a running app without a window.
- Without the App Switcher plugin, **⌘Tab** does nothing: Omarchy's "next
  workspace" moves to ⌃→. Install the plugin or bind ⌘Tab yourself.
- **⌃← / ⌃→** switch desktops, as on a Mac. Use ⌥← / ⌥→ to move by word.
- Shortcuts are sent to apps as Ctrl shortcuts, so an app's own Ctrl shortcuts
  decide what happens. Most apps match macOS, some don't.
- No Mission Control (⌃↑) or global menu bar.
- Holding a key (⌘Z, ⌘← …) repeats through Hyprland, which can feel slightly
  different from a native key repeat.
- Omarchy's keybindings help (⌘K) lists the new bindings by their descriptions.

## How it works

`mac-keys.lua` is a Lua module for Omarchy's Hyprland config. It rebinds keys
with Omarchy's `o.rebind` and sends shortcuts to the focused window with
Hyprland's `send_key_state`, the same technique Omarchy uses for its universal
clipboard. Terminals are recognized by Omarchy's `terminal` window tag.

Nothing in Omarchy is modified: remove the `dofile(...)` line and Hyprland
reloads with Omarchy's defaults.

## Uninstall

Remove the `dofile(...)` line from `~/.config/hypr/hyprland.lua`, then:

```bash
rm -rf ~/.local/share/omarchy-mac-keys
```

## License

[MIT](LICENSE)
