{ lib, config, ... }:
let
  wezterm = "${config.programs.wezterm.package}/bin/wezterm";
  nvim = "${config.programs.neovim.finalPackage}/bin/nvim";

  # Launch an app by bundle ID, or focus it (and jump to its workspace) if running
  app = id: "exec-and-forget open -b ${id}";

  # One kind of app per workspace. Workspace => list of bundle IDs.
  # Find an app's bundle ID with: osascript -e 'id of app "AppName"'
  workspaceApps = {
    # 1: Terminal (also where coding happens)
    "1" = [
      "com.github.wez.wezterm"
      "com.apple.Terminal"
    ];
    # 2: Browser
    "2" = [ "com.apple.Safari" ];
    # 3: Chat
    "3" = [
      "com.tinyspeck.slackmacgap"
      "com.apple.MobileSMS"
      "com.apple.FaceTime"
    ];
    # 4: Mail & calendar
    "4" = [
      "com.apple.mail"
      "com.apple.iCal"
      "com.apple.reminders"
      "com.apple.AddressBook"
    ];
    # 5: Notes & documents
    "5" = [
      "com.apple.Notes"
      "com.apple.freeform"
      "com.apple.TextEdit"
      "com.apple.Preview"
    ];
    # 6: Media
    "6" = [
      "com.apple.Music"
      "com.apple.podcasts"
      "com.apple.TV"
      "com.apple.Photos"
      "com.apple.QuickTimePlayerX"
    ];
    # 7: Maker / hardware
    "7" = [
      "com.bambulab.bambu-studio"
      "com.raspberrypi.rpi-imager"
    ];
    # 8: System & utilities
    "8" = [
      "com.apple.systempreferences"
      "com.apple.AppStore"
      "com.apple.Passwords"
    ];
    # 9: Spare, nothing auto-assigned
  };

  # Small utility windows that shouldn't be tiled
  floatingApps = [
    "com.apple.calculator"
    "com.apple.finder"
  ];

  workspaces = map toString (lib.range 1 9);

  assignRules = lib.flatten (
    lib.mapAttrsToList (
      ws: ids:
      map (id: {
        "if".app-id = id;
        run = "move-node-to-workspace ${ws}";
      }) ids
    ) workspaceApps
  );

  floatRules = map (id: {
    "if".app-id = id;
    run = "layout floating";
  }) floatingApps;
in
{
  programs.aerospace = {
    enable = true;
    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      default-root-container-layout = "tiles";
      # Stack top to bottom (LG DualUp is taller than wide)
      default-root-container-orientation = "vertical";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      gaps = {
        inner.horizontal = 16;
        inner.vertical = 16;
        outer.left = 16;
        outer.right = 16;
        outer.top = 16;
        outer.bottom = 16;
      };

      on-window-detected = floatRules ++ assignRules;

      mode.main.binding = {
        # Layouts
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";
        alt-f = "fullscreen";
        alt-shift-space = "layout floating tiling";

        # Focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # Move
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # Join with neighbour (nest the two in a container)
        alt-ctrl-h = "join-with left";
        alt-ctrl-j = "join-with down";
        alt-ctrl-k = "join-with up";
        alt-ctrl-l = "join-with right";

        # Resize
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";

        # Windows
        alt-t = "layout floating tiling";
        alt-shift-r = "flatten-workspace-tree";

        # Terminal and editor (new window each time)
        alt-enter = "exec-and-forget ${wezterm} start";
        alt-shift-n = "exec-and-forget ${wezterm} start -- ${nvim}";

        # Apps: launch or focus
        alt-shift-b = app "com.apple.Safari";
        alt-shift-s = app "com.tinyspeck.slackmacgap";
        alt-shift-g = app "com.apple.MobileSMS";
        alt-shift-e = app "com.apple.mail";
        alt-shift-c = app "com.apple.iCal";
        alt-shift-o = app "com.apple.Notes";
        alt-shift-m = app "com.apple.Music";
        alt-shift-p = app "com.bambulab.bambu-studio";
        alt-shift-comma = app "com.apple.systempreferences";
        alt-shift-slash = app "com.apple.Passwords";
        alt-shift-f = "exec-and-forget open ~";
      }
      // lib.listToAttrs (
        lib.concatMap (ws: [
          (lib.nameValuePair "alt-${ws}" "workspace ${ws}")
          (lib.nameValuePair "alt-shift-${ws}" "move-node-to-workspace ${ws}")
        ]) workspaces
      );

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
      };
    };
  };
}
