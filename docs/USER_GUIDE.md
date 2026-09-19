# Outfit user guide

Outfit helps you browse, understand, and manage plugins for your Omarchy desktop.
Start with the [installation instructions](../README.md#install), then open the
toolbox widget or optional Apps launcher.

## First open and background activity

**Browse** is the starting workspace. A bundled public catalog snapshot is ready
on first open, even before a network refresh. Later opens can use cached listings.
Outfit checks installed plugins first; once inventory is confirmed, plugin
management can become ready without waiting for optional hardware checks.

Open **More actions → Background activity** for the separate stages:

| Stage | What it means |
| --- | --- |
| Catalog | Saved or bundled listings are usable while marketplace listings and public counts refresh. |
| Installed plugins | Outfit is confirming what is installed, enabled, and placed on your bar. Plugin changes wait for this check. |
| System fit · optional | Local checks add recommendation signals. Browsing does not wait for them. |
| Documentation · optional | A public search pack downloads, then its documents are validated and imported locally. Remaining documents are indexed progressively. |

Downloading and local import are different steps: receiving all bytes does not
mean the search library has finished importing. Measured progress is shown when
available. **Library prepared** means available documentation is searchable,
not that every repository has a usable README. Searchable, checked, pending,
unavailable, retrying, and skipped counts describe different outcomes.

An error in an optional stage does not prevent catalog browsing. Use that stage's
retry control, or continue with the information already available. Before public
pack assets are published, or when a pack cannot be downloaded, local progressive
README indexing remains the fallback. Closing Outfit pauses indexing; committed
work is retained for the next open.

## Browse, filter, and search

Type a plugin name, task, app, or feature. Search combines listing metadata with
available current-revision README text on your computer. Typing does not request
README downloads. Search excerpts replace card descriptions while you search;
**README match** identifies evidence found in documentation.

- Starting a search selects **Best match**. Choose another sort to keep it while
  editing that search. Clearing the query restores your previous browse sort.
- Complete matches take priority. If none exist, **Partial matches** identifies
  the fallback results. **Did you mean …?** runs a suggestion only when selected.
- Several interest/service shortcuts match with **OR**: a plugin may match any
  selected shortcut. Search and other filter types combine with **AND**.
- Status, source, purpose, category, verification, and hardware-fit filters can
  narrow the results. Counts appear in parentheses; **(—)** means unconfirmed.
- **Browse all** clears the query and active filters. It preserves saved interests,
  grouping, and batch selections, and restores the pre-search browse sort.
- **Collapse filters** gives the results more room. Active filter chips remain
  visible; use **Filters** to expand the sidebar again.

Browse defaults to **Most liked**. Other sorts include **Recommended**, **Most
starred**, **Hardware fit**, **A–Z**, **Recently added**, **Recent activity**, **Most
viewed**, and **Most copied**. Sorting applies to the whole result set before
pagination. **No grouping** and **Group by category** change presentation without
changing scores or result membership.

### Views, counts, and keyboard controls

Choose **Comfortable**, **Compact**, **Dense**, or **List** beside the grouping
controls. Comfortable is the default. Your view preference survives app and shell
restarts; switching views keeps the selection, filters, and scroll context where
possible. Smaller views tighten spacing and previews while retaining text sizes.
Disabling thumbnails removes the image column in List view.

Likes, GitHub stars, views, and command copies are public marketplace/repository
counts. A dash means unknown, while zero means a reported zero. Copies count
install-command copies, not confirmed installations; likes are anonymous reactions,
not unique-user ratings. Hover or select a metric for its explanation.

**Verified** reflects the marketplace's status, not a security certification.
**New** uses the marketplace's rolling twelve-hour added window. The detail page
includes revision information, plus **Recommended** and **Hardware fit** scores.

| Shortcut | Action |
| --- | --- |
| `Ctrl+F` | Focus search. |
| `Ctrl+S` | Save settings changes. |
| `Esc` | Dismiss help or a confirmation, leave details/review, or close the window, depending on focus. |
| `Enter` / `Space` on a card | Open its details. |
| `F2` on a card, then arrow keys | Focus and move through metrics; `Enter` / `Space` shows help. |
| Left/Right on view controls | Change the selected view. |
| Up/Down in List | Move between rows, including across category headings. |

## Setup and interests

Open **Setup & interests** from Browse or Settings.

**Detected** shows recognized recommendation inputs, rather than an exhaustive
hardware inventory. Hardware and installed software capabilities are distinguished,
as are direct/inferred observations and current/stale results. Expand an item to
see probe details and matching terms. A failed probe can retain its last confirmed
observation as stale; it does not prove the device disappeared. Change the
checkboxes and save to choose which detected inputs contribute to suggestions.

**Added by you** opens a searchable multi-select picker. Choose several apps or
features across searches, add a custom topic from the search text, then **Save
changes** once. You can keep up to 64 interests, with custom topics up to 64
characters. Selected chips provide Remove actions without moving the picker.
An interest is still valid when it currently has no matches.

The highlighted save controls identify an unfinished draft. **Review changes…**
returns to it; discarding restores saved shortcuts. Saving interests neither
activates Browse filters nor selects anything for installation. Browse shortcuts
can reflect the current draft, but using a shortcut does not save it or change
saved recommendation scoring. A selected filter keeps its criterion if the
corresponding shortcut is subsequently removed.

**Hardware fit** uses detected hardware. **Recommended** also considers saved
interests, software capabilities, and popularity. For example, a recognized
Framework laptop, connected headphones, display, or pen input may surface relevant
listings. Expand the match explanation to see the input, phrase, field, and
revision behind it. Text matching cannot establish compatibility, and some
hardware is not visible through normal user-level checks.

## Read a plugin's details

Select a card or list row for its preview, metrics, source/listing links, setup
requirements, documentation, and management controls. **Why recommended** starts
collapsed; documentation starts expanded. Back returns to your previous Browse
state, and the detail selection remains available if a filter changes.

Documentation supports headings, lists, links, tables, and code blocks. It is
bounded and may be truncated; use the source link for the complete original.
Repository HTML and inline images are not rendered. Preview images are handled
separately; missing or unsupported media leaves the text usable. Video downloads
start only after **Play demo**, initially muted. **Open externally** is available
when a codec or Qt Multimedia is unavailable; external links require your action.

## Install and manage plugins

**Install…** opens a confirmation showing the source and any additional setup.
Ordinary plugins default to enabled; choose bar-widget placement explicitly.
Exclusive shell replacements require opt-in. Manual-only listings link to the
project's own instructions.

After inventory confirms a plugin's state, its controls can:

- **Open** an enabled plugin with a standard panel, overlay, or menu entry point.
  This does not implicitly enable a disabled plugin.
- Enable or disable supported plugins. First-party plugins must be marked
  disableable by Omarchy; active bar replacements have no off state.
- Place a widget on the left, center, or right. For a disabled widget, the location
  is staged until it is enabled.
- **Uninstall plugin…** after confirmation. First-party plugins and Outfit itself
  are protected from removal here. Outfit can move its own widget.

Native Omarchy installation downloads the repository's current revision, which
may be newer than the marketplace-reviewed revision. Outfit reports both when
the installed checkout is available. Marketplace labels and match scores do not
replace reading the source and requirements.

### Batch install

Use **Add to batch install** to collect up to 50 plugins, or **Remove from batch**
to change your selection. **Review batch install** shows sources, placements,
exclusive replacements, and requirements before you confirm.

Plugins install one at a time. The next operation waits for confirmed inventory,
not a fixed delay. Progress distinguishes completed, partial, failed, skipped,
and queued outcomes. Use stop-after-current to pause further work. Interrupted
batches remain available for review and explicit resume/retry after verification;
a timeout alone does not prove an installation failed.

Stock Omarchy can briefly close Outfit while reloading plugin surfaces. Automatic
reopening may take several seconds. If it remains closed, reopen from the bar or
Apps. Intentionally closing Outfit cancels automatic reopening for that operation
group. Full uninterrupted window continuity requires host-side support; see the
[technical guide](TECHNICAL.md#host-lifecycle-and-session-recovery).

## Settings and maintenance

The top-right cog opens Settings; **Back** returns, and the corner **×** closes
Outfit. Settings include:

- Optional local hardware checks every 60 seconds, including a check when
  reopening a session whose last scan is at least a minute old.
- **Use GitHub READMEs and previews**, which controls README enrichment and
  README search. Turning it off also removes cached README matches from search.
- **Show marketplace thumbnails**, on by default and independent of README
  enrichment. Missing images use a toolbox placeholder.
- Documentation indexing pause/resume. Pausing retains cached README search;
  it differs from disabling README enrichment altogether.
- **Check diagnostics** and **Clear preview cache** for support and maintenance.

**More actions → Rescan system** retries local hardware and inventory checks.
**Refresh catalog** updates listings and public popularity counts. Routine checks
finish quietly; manual work has short progress/completion messages. More actions
shows update ages, while Diagnostics provides exact UTC timestamps. Failed updates
remain visible and keep usable cached data. See [Support](../SUPPORT.md) for errors.

## FAQ

### Does Outfit need an account or send my hardware to a server?

No account is needed, and Outfit sends no telemetry or raw hardware profile.
Search and matching run locally, but public catalogs, search packs, READMEs,
previews, and plugin installations use the network. Resource requests can reveal
which repositories or images were requested; locally selected documentation can
indirectly suggest interests or hardware. See the full
[privacy and storage details](TECHNICAL.md#privacy-and-network-requests).

### Can I browse offline?

Yes: bundled/cached listings and already indexed documentation remain usable.
Fresh metadata, uncached documentation/images, and installations need a connection.
Hardware and inventory checks are local. Download or import errors do not erase
the previous searchable library.

### Why doesn't every README appear in search immediately?

The public pack includes documents with matching license evidence and exact
catalog revisions. Other eligible documents are fetched locally over time;
missing, oversized, or unsupported documents may remain unavailable. A catalog
revision change also needs matching new text. **Unavailable** means checked, not
searchable. Current coverage and sizes are recorded in the
[technical guide](TECHNICAL.md#search-library-and-current-measurements).

### How do I update or remove Outfit?

Use the [update](../README.md#update) or [removal](../README.md#remove) commands.
If you installed an early test build, use the
[one-time migration guide](../IDENTITY_MIGRATION.md) first; a native update alone
does not change an old registration name. Removing a plugin normally leaves its
separate data unless that plugin's own removal behavior deletes it.

### How do I erase Outfit's saved data?

After removing Outfit, the following optional commands permanently delete its
cache and private settings, including saved interests and batch recovery state:

```bash
rm -rf -- "${XDG_CACHE_HOME:-$HOME/.cache}/io.github.ctl0v0.outfit"
rm -rf -- "${XDG_CONFIG_HOME:-$HOME/.config}/io.github.ctl0v0.outfit"
```

Deleting only the cache retains settings; documentation will need to be prepared
again. **Reset settings** retains interests and review state. Migration backups
and retained early-build data are separate; consult the migration guide before
removing anything you may need for recovery.
