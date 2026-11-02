# Petals Hub UI – README template

Use this as the common structure for a **new** game-specific Petals Hub UI. Replace bracketed values with the user's answers. The visible English copy in quotes is fixed unless the user explicitly requests a change.

## Identity and assets

- **Game:** `[game name]` (ask the user).
- **Window header:** game name on top, `Petals Hub` beneath it; themed Petals logo at the left.
- **Theme:** `[chosen color and palette]`. Ask for character preferences, including gender, outfit, pose and style. Default to a newly generated 2D anime character; honor a different character, a provided reference or no character. Generate a fresh coordinated background with petals in the chosen palette for each game UI, plus a matching transparent petal overlay if requested. Do not reuse the PetSim background or overlay.
- **Icons:** always use Lucide `layout-dashboard` for Overview and `settings` for Settings; ask whether Lucide is desired for the other controls. Use only the transparent [Petals logo](https://github.com/levox00/ps/blob/main/assets/petals-logo-transparent.png) from the asset repository. Recolor it to the chosen palette while preserving its design, geometry and transparency; do not otherwise alter it unless explicitly requested.
- **Layout:** topbar with normal WindUI window controls; left sidebar for tabs; main content on the right. The background lies underneath content; optional decorative overlay stays clipped to the UI. The minimized button uses the same themed logo and is draggable.
- **Features:** `[user-selected features or none]`; Overview and Settings still exist for a UI-only script.

## Overview – exact visible hierarchy

Create each named heading as a separate visible, expanded WindUI **section**, not merely as the title of a paragraph or as plain body text. Place the listed controls inside their section. Keep their order, including the repeated names used both as a section heading and as a row title:

```text
Overview [tab: layout-dashboard]
├─ Petals Hub [section heading]
│  ├─ Game [paragraph title]
│  │  └─ Blade Ball [paragraph description: substitute the actual game name]
│  └─ Latest Update [paragraph title]
│     └─ [actual version and changes, or state details were not supplied]
├─ Show / Hide Hub [section heading]
│  └─ Show / Hide Hub [paragraph title]
│     └─ Press F8 or Right Control to show or hide Petals Hub. The shortcut also moves the window back to the center of the screen. [description]
└─ Community [section heading]
   ├─ Community [paragraph title]
   │  └─ Need help or want a premium key? Join our Discord for support, updates and premium information. [description]
   ├─ Copy Discord Invite [button]
   └─ discord.gg/qktbuBpkY6 [visible label]
```

For example, for Blade Ball the visible content is a `Petals Hub` heading, then a row titled `Game` whose description is exactly `Blade Ball`. Do not make `Petals Hub` the row title, do not make `Game: Blade Ball` its description, and do not omit the heading. `Latest Update` is a separate paragraph within `Petals Hub`, not a replacement for that heading. Include only real release details. The Discord button copies the invite, with a graceful fallback if clipboard access is unavailable; do not imply an unverified premium purchase link. Game-specific sections may follow `Community` when requested.

Use the fork's actual section/container API, for example `Overview:Section({Title = "Petals Hub", Opened = true, Box = false})` and its `:Paragraph({Title = "Game", Desc = gameName})`; create separate `Show / Hide Hub` and `Community` sections the same way. Verify that the headings render visibly and that the controls are children of their intended sections; do not rely on a flat list of paragraphs or a group without a visible heading. Adapt only if the checked fork API differs.

## Settings – exact visible hierarchy

Create three separate visible, expanded sections in the same style as Overview; they are headings, not control titles. Keep the controls nested and ordered as follows:

```text
Settings [tab: settings]
├─ Appearance [section heading]
│  ├─ Background image transparency [slider]
│  └─ UI surface transparency [slider]
├─ Diagnostics [section heading]
│  ├─ Copy Full Debug Report [button]
│  ├─ Save Debug Report to File [button]
│  ├─ Clear Hub Log [button]
│  └─ Hub log [status paragraph, if a visible log is implemented]
└─ Session [section heading]
   └─ Stop and Close Hub [button]
```

Use separate section objects such as `Settings:Section({Title = "Appearance", Opened = true, Box = false})` and add each slider to its section rather than to the tab. Create `Diagnostics` and `Session` similarly and place their controls within them. Do not hide these headings or require opening a collapsed section to discover its controls. Only add game-specific session actions if requested or already present in an existing project.

`Background image transparency` controls only the background image. `UI surface transparency` controls the panel, nested feature and section surfaces, selected/hovered sidebar, dropdown menu and selected dropdown options. Layers get progressively less transparent toward the foreground; text and icons remain readable. Both values move in the same direction and are clamped between 0% and 100%. Diagnostics must redact sensitive values and provide capability fallbacks. The top-right X must run the same shutdown as `Stop and Close Hub`. Do not add saved-profile controls or an interface-theme selector by default.

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

Use the user's Silk-WindUI fork as an image-free base. Configure newly generated background and overlay assets in the game script rather than the library. Load its currently verified pinned version; do not assume a mutable main branch is stable. Use its `SetBackgroundImageTransparency` and `SetUITransparency` APIs when present and preserve transparent PNG alpha. Do not modify unrelated UI or silently implement features. Test the real UI controls and dropdown states, cleanup/re-execution, keyboard and touch when possible; label simulated and compilation checks separately from live Roblox/Delta verification.
