# Petals Hub UI – README template

Use this as the common structure for a **new** game-specific Petals Hub UI. Replace bracketed values with the user's answers. The visible English copy in quotes is fixed unless the user explicitly requests a change.

## Identity and assets

- **Game:** `[game name]` (ask the user).
- **Window header:** game name on top, `Petals Hub` beneath it; themed Petals logo at the left.
- **Theme:** `[chosen color and palette]`; user may request an anime character, outfit, background and optional petal overlay.
- **Icons:** always use Lucide `layout-dashboard` for Overview and `settings` for Settings; ask whether Lucide is desired for the other controls. The logo stays the Petals mark, tinted to the chosen theme unless the user chooses a different treatment.
- **Layout:** topbar with normal WindUI window controls; left sidebar for tabs; main content on the right. The background lies underneath content; optional decorative overlay stays clipped to the UI. The minimized button uses the same themed logo and is draggable.
- **Features:** `[user-selected features or none]`; Overview and Settings still exist for a UI-only script.

## Overview – order and exact copy

1. **`Petals Hub`** and immediately underneath the current game name, e.g. `Game: [game name]`.
2. **`Latest Update`**: real current version/date if known and a concise, accurate list of what was added or changed. If no update details are supplied, ask or state that no update details were supplied; never invent features.
3. **`Show / Hide Hub`**:  
   `Press F8 or Right Control to show or hide Petals Hub. The shortcut also moves the window back to the center of the screen.`
4. **`Community`**:  
   `Need help or want a premium key? Join our Discord for support, updates and premium information.`  
   Place the **`Copy Discord Invite`** action immediately below, followed by the visible invite `discord.gg/qktbuBpkY6`. The action copies the invite, with a graceful fallback if clipboard access is unavailable. Do not imply an unverified premium purchase link.

## Settings – order

1. **`Appearance`**: `Background image transparency` controls the background image only; `UI surface transparency` controls the panel, nested feature and section surfaces, selected/hovered sidebar, dropdown menu and selected dropdown options. The layers get progressively less transparent toward the foreground; text and icons remain readable. Values move in the same direction and are clamped between 0% and 100%.
2. **`Diagnostics`**: `Copy Full Debug Report`, `Save Debug Report to File`, `Clear Hub Log`. Redact sensitive values and provide capability fallbacks.
3. **`Session`**: `Stop and Close Hub`. The top-right X must run the same shutdown. No saved-profile controls or interface-theme selector by default.

## First-run Discord popup

- Title: `Join Discord?`
- Content: `Need help or a premium key? Join our Discord.`
- Buttons: `Not now` and `Join Discord`. Open the invite or copy it as a fallback.
- Persist that the dialog was successfully displayed, once per hub on the local device. If the executor cannot persist files, disclose that it may appear again. The prompt must never block hub startup.

## Window lifecycle and shortcuts

- Minimize hides the window but leaves authorized features running; the draggable mini button restores it.
- F8 and Right Control toggle visibility and move the window to the center of the screen on each shortcut press, including when recovering an off-screen UI. Ignore shortcut input while a text box is focused. Touch users retain the draggable mini button.
- Close/X and Stop and Close Hub stop workers and disconnect signals, remove only the current hub UI, and leave exactly one active instance after re-execution. Do not destroy other scripts' GUIs.

## Implementation and validation

Use the user's Silk-WindUI fork. Load its currently verified pinned version; do not assume a mutable main branch is stable. Use its `SetBackgroundImageTransparency` and `SetUITransparency` APIs when present and preserve transparent PNG alpha. Do not modify unrelated UI or silently implement features. Test the real UI controls and dropdown states, cleanup/re-execution, keyboard and touch when possible; label simulated and compilation checks separately from live Roblox/Delta verification.
