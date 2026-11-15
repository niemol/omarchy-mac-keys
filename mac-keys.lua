-- macOS keyboard shortcuts for Omarchy.
--
-- Cmd (the Super key) does what it does on a Mac: in apps it sends the
-- matching Ctrl shortcut (Cmd+T opens a tab, Cmd+Z undoes, Cmd+Left jumps to
-- the start of the line). Omarchy's window-management shortcuts that used
-- those keys move to Ctrl+Cmd, the combination macOS itself uses for window
-- functions (Ctrl+Cmd+F full screen, Ctrl+Cmd+Q lock).
--
-- Load it at the end of ~/.config/hypr/hyprland.lua:
--
--   dofile(os.getenv("HOME") .. "/.local/share/omarchy-mac-keys/mac-keys.lua")({})
--
-- Options (all optional):
--   mac_layout        Keyboard layout to switch to its Macintosh variant, e.g. "fi",
--                     "se", "de" (sets kb_layout and kb_variant = "mac"). Default: leave
--                     the layout alone.
--   app_switcher      true / false / "auto". Bind Cmd+Tab to the App Switcher plugin
--                     (github.com/niemol/omarchy-app-switcher). "auto" (default) binds it
--                     when the plugin is installed.
--   desktop_arrows    Ctrl+Left / Ctrl+Right switch desktops, as on a Mac. Default true.
--   word_navigation   Option(Alt)+Left/Right/Backspace move or delete by word. Default true.
--   screenshots       Shift+Cmd+3 / 4 / 5 take screenshots. Default true.
--   alt_tab_classes   Lua patterns of window classes that switch tabs with Alt+1..9
--                     instead of Ctrl+1..9. Default { "^firefox$", "^librewolf$", "^zen$" }.
--
-- Symbols in comments: ⌘ Cmd/SUPER, ⌃ CTRL, ⌥ Option/ALT, ⇧ SHIFT.

return function(opts)
  opts = opts or {}

  local function option(name, default)
    if opts[name] == nil then return default end
    return opts[name]
  end

  local alt_tab_classes = option("alt_tab_classes", { "^firefox$", "^librewolf$", "^zen$" })

  -- ── Helpers ─────────────────────────────────────────────────────────────

  -- Sends a key combination to the focused window. Press and release are sent
  -- separately, as Omarchy's own universal clipboard does, because Hyprland's
  -- send_shortcut can leave a synthetic key stuck. Explicit mods (even "") make
  -- the physically held Cmd key stay out of the sent shortcut.
  local function send_now(mods, key)
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 30, type = "oneshot" })
  end

  local function send(mods, key)
    return function() send_now(mods, key) end
  end

  -- Omarchy tags terminal windows "terminal" (default/hypr/apps/terminals.lua).
  local function is_terminal()
    local window = hl.get_active_window()
    if not window then return false end
    for _, tag in ipairs(window.tags or {}) do
      if tag:gsub("%*$", "") == "terminal" then return true end
    end
    return false
  end

  local function class_matches(patterns)
    local window = hl.get_active_window()
    local class = window and window.class
    if not class then return false end
    for _, pattern in ipairs(patterns) do
      if class:match(pattern) then return true end
    end
    return false
  end

  -- A Cmd shortcut that terminals take with Shift added (Ctrl+Shift+T opens a
  -- tab in a terminal, where plain Ctrl+T belongs to the shell).
  local function app_key(mods, key, terminal_mods)
    return function()
      send_now(is_terminal() and terminal_mods or mods, key)
    end
  end

  -- Every binding goes through o.rebind, which first removes whatever Omarchy
  -- had on the same keys. Note that hl.unbind matches the modifiers in the
  -- order they were written, so Omarchy's "SUPER + SHIFT + CTRL" bindings are
  -- removed explicitly below.
  local function bind(keys, description, dispatcher, options)
    o.rebind(keys, description, dispatcher, options)
  end

  local REPEAT = { repeating = true }
  local ARROWS = { l = "LEFT", r = "RIGHT", u = "UP", d = "DOWN" }

  -- Number row keys by keycode, so they work on every layout.
  local function number_key(n) return "code:" .. tostring(n == 0 and 19 or n + 9) end

  -- ── Keyboard layout ─────────────────────────────────────────────────────

  if opts.mac_layout then
    hl.config({ input = { kb_layout = opts.mac_layout, kb_variant = "mac" } })
  end

  -- ── 1. Move Omarchy's window functions out of the way ──────────────────
  -- Done first, so the Cmd keys are free for the Mac shortcuts below.

  -- Workspaces: ⌃⌘1-9, move window there with ⌃⇧⌘1-9.
  -- Frees ⌘1-9 for tabs and ⇧⌘3/4/5 for screenshots.
  for workspace = 1, 10 do
    local key = number_key(workspace % 10)
    hl.unbind("SUPER + " .. key)
    hl.unbind("SUPER + SHIFT + " .. key)
    bind("SUPER + CTRL + " .. key, "Switch to workspace " .. workspace, o.workspaces.focus(workspace))
    bind("SUPER + CTRL + SHIFT + " .. key, "Move window to workspace " .. workspace, o.workspaces.move_window(workspace))
  end

  -- Window focus ⌃⌘arrows, swap ⌃⇧⌘arrows. The functions Omarchy had on those
  -- keys get Option added: grouped-window focus ⌃⌥⌘←/→, move to monitor ⌃⇧⌥⌘arrows.
  bind("SUPER + CTRL + ALT + LEFT", "Move grouped window focus left", hl.dsp.group.prev())
  bind("SUPER + CTRL + ALT + RIGHT", "Move grouped window focus right", hl.dsp.group.next())
  for dir, key in pairs(ARROWS) do
    hl.unbind("SUPER + SHIFT + CTRL + " .. key)
    bind("SUPER + CTRL + SHIFT + ALT + " .. key, "Move window to " .. key:lower() .. " monitor", o.workspaces.move_window_to_monitor(dir))
    bind("SUPER + CTRL + " .. key, "Focus window " .. key:lower(), hl.dsp.focus({ direction = dir }))
    bind("SUPER + CTRL + SHIFT + " .. key, "Swap window " .. key:lower(), hl.dsp.window.swap({ direction = dir }))
  end

  bind("SUPER + CTRL + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
  bind("SUPER + CTRL + SHIFT + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
  bind("SUPER + CTRL + Q", "Lock system", "omarchy-system-lock")
  bind("SUPER + CTRL + SPACE", "Emojis", { panel = "omarchy.emojis" })
  bind("SUPER + CTRL + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
  bind("SUPER + CTRL + L", "Cycle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
  bind("SUPER + CTRL + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
  bind("SUPER + CTRL + ALT + S", "Share", { menu = "share" })
  bind("SUPER + CTRL + G", "Toggle window grouping", hl.dsp.group.toggle())
  bind("SUPER + CTRL + ALT + P", "Pseudo window", hl.dsp.window.pseudo())
  bind("SUPER + CTRL + ALT + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
  bind("SUPER + CTRL + ALT + I", "Switch input language", "omarchy-input-method cycle")
  bind("SUPER + CTRL + ALT + comma", "Dismiss, invoke, or focus last notification", { ipc = "notifications.act" })
  bind("SUPER + CTRL + BACKSPACE", "Toggle transparency on a window", "omarchy-hyprland-window-transparency-toggle")
  bind("SUPER + CTRL + ALT + BACKSPACE", "Toggle single-window square aspect", "omarchy-hyprland-window-single-square-aspect-toggle")

  -- Omarchy's ⌘+ / ⌘´ (resize window) become zoom. The ⌃⌘ and ⌥⌘ resize
  -- variants stay. ⌘Tab / ⇧⌘Tab (next / previous workspace) are freed for
  -- the app switcher; ⌃←/→ switch desktops instead.
  hl.unbind("SUPER + code:20")
  hl.unbind("SUPER + code:21")
  hl.unbind("SUPER + TAB")
  hl.unbind("SUPER + SHIFT + TAB")

  -- ── 2. Apps: ⌘ sends the Ctrl shortcut ──────────────────────────────────
  -- ⌘C / ⌘V / ⌘X / ⌘A already work this way in Omarchy (bindings/clipboard.lua).
  -- These replace Omarchy's ⌘W (close window), ⌘T (float), ⌘F (full screen),
  -- ⌘L (layout), ⌘S (scratchpad), ⌘G (group), ⌘P, ⌘O, ⌘I and ⌘, as well as the
  -- app launchers on ⇧⌘S (Google Maps), ⇧⌘G (Signal), ⇧⌘N (Editor), ⇧⌘T (Activity).

  bind("SUPER + Z", "Undo", send("CTRL", "Z"), REPEAT)
  bind("SUPER + SHIFT + Z", "Redo", send("CTRL SHIFT", "Z"), REPEAT)
  bind("SUPER + S", "Save", send("CTRL", "S"))
  bind("SUPER + SHIFT + S", "Save as", send("CTRL SHIFT", "S"))
  bind("SUPER + F", "Find", app_key("CTRL", "F", "CTRL SHIFT"))
  bind("SUPER + G", "Find next", send("CTRL", "G"), REPEAT)
  bind("SUPER + SHIFT + G", "Find previous", send("CTRL SHIFT", "G"), REPEAT)
  bind("SUPER + T", "New tab", app_key("CTRL", "T", "CTRL SHIFT"))
  bind("SUPER + SHIFT + T", "Reopen closed tab", send("CTRL SHIFT", "T"))
  bind("SUPER + W", "Close tab", app_key("CTRL", "W", "CTRL SHIFT"))
  bind("SUPER + N", "New window", app_key("CTRL", "N", "CTRL SHIFT"))
  bind("SUPER + SHIFT + N", "New private window / new folder", function()
    -- Firefox-based browsers open a private window with Ctrl+Shift+P.
    send_now("CTRL SHIFT", class_matches(alt_tab_classes) and "P" or "N")
  end)
  bind("SUPER + R", "Reload", send("CTRL", "R"))
  bind("SUPER + L", "Address bar", send("CTRL", "L"))
  bind("SUPER + P", "Print", send("CTRL", "P"))
  bind("SUPER + O", "Open", send("CTRL", "O"))
  bind("SUPER + B", "Bold", send("CTRL", "B"))
  bind("SUPER + I", "Italic", send("CTRL", "I"))
  bind("SUPER + U", "Underline", send("CTRL", "U"))
  bind("SUPER + D", "Bookmark", send("CTRL", "D"))
  bind("SUPER + comma", "Settings", send("CTRL", "comma"))
  bind("SUPER + code:20", "Zoom in", send("CTRL", "plus"), REPEAT)
  bind("SUPER + minus", "Zoom out", send("CTRL", "minus"), REPEAT)
  bind("SUPER + " .. number_key(0), "Reset zoom", send("CTRL", "0"))

  -- ⌘1-9: go to tab N. Firefox on Linux uses Alt+N, most other apps Ctrl+N.
  for n = 1, 9 do
    bind("SUPER + " .. number_key(n), "Go to tab " .. n, function()
      send_now(class_matches(alt_tab_classes) and "ALT" or "CTRL", tostring(n))
    end)
  end

  -- ── 3. Moving around in text ────────────────────────────────────────────

  bind("SUPER + LEFT", "Line start", send("", "Home"), REPEAT)
  bind("SUPER + RIGHT", "Line end", send("", "End"), REPEAT)
  bind("SUPER + UP", "Document start", send("CTRL", "Home"), REPEAT)
  bind("SUPER + DOWN", "Document end", send("CTRL", "End"), REPEAT)
  bind("SUPER + SHIFT + LEFT", "Select to line start", send("SHIFT", "Home"), REPEAT)
  bind("SUPER + SHIFT + RIGHT", "Select to line end", send("SHIFT", "End"), REPEAT)
  bind("SUPER + SHIFT + UP", "Select to document start", send("CTRL SHIFT", "Home"), REPEAT)
  bind("SUPER + SHIFT + DOWN", "Select to document end", send("CTRL SHIFT", "End"), REPEAT)

  -- ⌘⌫ deletes to the start of the line: select to the start, then delete.
  bind("SUPER + BACKSPACE", "Delete to line start", function()
    send_now("SHIFT", "Home")
    hl.timer(function() send_now("", "BackSpace") end, { timeout = 60, type = "oneshot" })
  end)

  if option("word_navigation", true) then
    bind("ALT + LEFT", "Word left", send("CTRL", "Left"), REPEAT)
    bind("ALT + RIGHT", "Word right", send("CTRL", "Right"), REPEAT)
    bind("ALT + SHIFT + LEFT", "Select word left", send("CTRL SHIFT", "Left"), REPEAT)
    bind("ALT + SHIFT + RIGHT", "Select word right", send("CTRL SHIFT", "Right"), REPEAT)
    bind("ALT + BACKSPACE", "Delete word", send("CTRL", "BackSpace"), REPEAT)
  end

  -- ── 4. Windows and desktops ─────────────────────────────────────────────

  bind("SUPER + H", "Hide window (minimize to the dock)", "omarchy-hyprland-window-minimize")
  bind("SUPER + ALT + ESCAPE", "Force quit", hl.dsp.window.kill())
  -- ⌘Q (close window), ⌘M (minimize) and ⌘Space (Omarchy menu) are Omarchy's
  -- defaults and already match macOS.

  if option("desktop_arrows", true) then
    bind("CTRL + LEFT", "Previous desktop", hl.dsp.focus({ workspace = "m-1" }))
    bind("CTRL + RIGHT", "Next desktop", hl.dsp.focus({ workspace = "m+1" }))
  end

  if option("screenshots", true) then
    bind("SUPER + SHIFT + " .. number_key(3), "Screenshot full screen", "omarchy-capture-screenshot --capture-fullscreen")
    bind("SUPER + SHIFT + " .. number_key(4), "Screenshot region", "omarchy-capture-screenshot --capture-region")
    bind("SUPER + SHIFT + " .. number_key(5), "Capture menu", { menu = "capture" })
  end

  -- ⌘Tab: the App Switcher plugin, if installed.
  local switcher = os.getenv("HOME") .. "/.config/omarchy/plugins/niemol.app-switcher/hypr/app-switcher.lua"
  local use_switcher = option("app_switcher", "auto")
  if use_switcher == "auto" then
    local f = io.open(switcher, "r")
    use_switcher = f ~= nil
    if f then f:close() end
  end
  if use_switcher then
    dofile(switcher)({})
  end
end
