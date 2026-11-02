---
name: petals-windui
description: Create a NEW Roblox Lua/Luau script UI using the user's personal Silk-WindUI fork or Petals Hub identity. Use for a requested new Petals Hub game UI; do not trigger for ordinary Lua scripts, existing UI maintenance, or unrelated WindUI projects.
---

# Petals Hub: new game UI

Use the user's fork at https://github.com/levox00/silk-windui (branch `silk`), not stock WindUI. Its image resources and example scripts are in https://github.com/levox00/ps. Check current repository state and APIs before use; preserve unrelated work. Read `references/README-template.md` for the mandatory layout and exact visible English copy.

## Before building

Ask the user, preferably together, for any missing decisions: game name; theme/accent color; whether and how the logo/icon should be customized or tinted to match; whether to use Lucide icons for the other controls; the anime character and outfit/visual direction; whether a petal overlay is wanted; and which gameplay features to implement, including the option to start with UI only. Do not repeat answers already given. Never invent features when the user requests a UI-only foundation. Overview and Settings are mandatory even when no features are requested. Use the user's exact game and branding choices; do not replace Petals Hub with the game name.

## Required structure and behavior

- Window header: show the game name above `Petals Hub`, with the themed logo on the left. In Overview, show `Petals Hub` first and the game underneath; follow the exact ordering and copy in the reference. Always use the Lucide `layout-dashboard` icon for Overview and the Lucide `settings` icon for Settings; follow the user's Lucide preference for other controls.
- Provide a personalized background; tint the existing Petals logo to the chosen color, with preserved transparency, and use it in the window and draggable minimized button. Use the optional petal overlay only when requested. Keep backgrounds and overlays clipped inside the UI; keep controls usable with mouse and touch. Use normal WindUI window buttons.
- `Overview` must include actual latest update and changes, then the exact Show/Hide section, then Community with the fixed description, Copy Discord Invite action and visible invite. Do not fabricate release notes or premium services.
- `Settings` must have independently adjustable Background Image Transparency and UI Surface Transparency. Apply UI transparency hierarchically to the outer panel, feature/section surfaces, selected sidebar tabs, dropdown menus and selectable dropdown items; the panel is most transparent, nested controls less transparent but still adjustable. Preserve readable text and icons. Use the fork's `SetBackgroundImageTransparency` and `SetUITransparency` APIs where available; do not fake dropdown support with a slider that does not affect the actual open menu. Do not add an Interface Theme selector or saved profiles.
- Add Diagnostics with Copy Full Debug Report, Save Debug Report to File and Clear Hub Log, with fallbacks when executor capabilities are missing. Do not leak secrets in diagnostics. Add `Stop and Close Hub` to Settings. The top-right X and this action must invoke the same idempotent full shutdown: stop workers, release connections, cancel owned continuations where applicable and destroy only this hub's GUI. Minimize must not stop the hub.
- F8 and Right Control must toggle visibility and re-center an off-screen window on keyboard-equipped devices. Do not consume keys while typing in a text field or create duplicate hotkey listeners. Keep the minimized button draggable and usable on touch.
- Show the Discord popup on the first execution on the local device only. Use the exact text in the reference. Save a per-hub flag after a successful display through available executor file APIs; if persistence is unavailable, state the limitation and do not claim once-only behavior. The popup must not stop initialization if it fails.
- Use one active instance of the specific hub across re-execution; do not destroy other hubs or unrelated UI. Preserve existing features when updating an existing authorized project.

## Delivery and verification

Implement the requested design and only the approved game features. Validate actual paths, alpha channels and raw URLs; compile Luau and check UI lifecycle, dropdown transparency, cleanup and singleton behavior. Where possible, visually verify desktop and touch layouts; distinguish mocks and compilation from live Roblox/Delta evidence. Follow normal publication permissions and the user's hosting choices. Do not add obfuscation, networking or auto-execute unless requested.
