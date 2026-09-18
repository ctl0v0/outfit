# Outfit

Outfit helps you explore what your Omarchy desktop can do. **Browse**, the launch workspace, combines the local plugin inventory with marketplace search, sorting, and filters. A shared inspector explains the benefit, setup requirements, source, and confirmed local state before you install or change a plugin.

![Outfit plugin browser with toolbox branding](preview.png)

*Preview uses fictional plugin data. This is an early testing build.*

Outfit was formerly named OmaFit. Its immutable plugin ID remains
`io.github.ctl0v0.omafit` so upgrades retain settings, caches, IPC integration,
self-protection and ID-based launcher/icon filenames. The launcher accepts both
historical and current ownership markers and upgrades owned assets in place.

Kinds: `service`, `bar-widget`, `panel`

Outfit can install validated marketplace entries after confirmation, toggle supported installed plugins on or off, place bar widgets on the left, center, or right, and remove installed third-party plugins after confirmation. Its batch-install queue lets you review several choices once and installs them sequentially.

## Requirements

- **Omarchy 4.0.4 stable with the Quattro shell and shell-plugin support** is the supported baseline. A stock installation is sufficient; no custom host checkout or `omarchy dev link` is required. Development verification uses Qt 6.11.2; fresh-machine verification is documented in [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md).
- Python 3.12 or newer at `/usr/bin/python3` (helpers run in isolated mode).
- Network access to `plugins.omarchy.org`, `api.omarchyplugins.com` for public like counts, and, for README enrichment and previews, GitHub's raw-content, user-attachment, and user-asset delivery hosts.
- Qt Multimedia is optional for inline video; unavailable modules/codecs offer external playback without preventing browsing.
- No authentication, privileged setup, or additional package is required.

Hardware probes use existing Omarchy tools when available: `hyprctl`, `bluetoothctl`, `wpctl`, and `omarchy`. Missing optional probes are reported without failing the analysis.

## Installation

```bash
omarchy plugin add https://github.com/ctl0v0/outfit.git --enable
```

For a local Git checkout, run this from the repository root after it has a commit
(Omarchy clones Git history; uncommitted files are not an installation candidate):

```bash
omarchy plugin add "$(pwd)" --enable
```

Add the Outfit widget to the bar if Omarchy does not place it automatically. Select **Outfit** in the bar settings under **Other**.

Optionally register the toolbox launcher in Omarchy's **Apps** list and app search
(the bar widget works without it):

```bash
python3 -I -B "${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/io.github.ctl0v0.omafit/scripts/launcher.py"
```

This repeatable command installs Outfit's marked desktop entry and scalable icon
under `$XDG_DATA_HOME` (or `~/.local/share`). The installed launcher opens the existing shell-hosted
panel and refuses to overwrite unrelated launchers. Run it after installation;
Omarchy's plugin installer does not execute application-registration hooks.

On stock Omarchy, plugin changes can reload shell surfaces and briefly close
Outfit. Automatic reopening can take several seconds; this is expected stock-host
behavior. If it stays closed, reopen it from the widget or optional Apps launcher.

## Use

1. Open **Outfit** from Apps or its toolbox bar widget. **Browse** is the only launch workspace. Cached listings remain usable while a separate worker scans hardware and inventory. Plugin mutations wait for confirmed inventory; optional network enrichment follows in the background.
2. Browse has an independently scrollable filter rail: service filters OR together; status, source, purpose, category, verification, hardware match, and search combine with AND.
3. **Browse all** clears the search and every active filter, restoring the pre-search browse sort while keeping the service watchlist, grouping, and plugins already added to setup. Reopening Outfit restores the last Quick Scan state during the shell session. The **No grouping** and **Group by category** buttons control presentation; **No grouping** is the default. Group headings show counts in parentheses. Purpose remains an independent sidebar filter. Search determines membership, then the selected sort orders the complete result set before pagination; grouping does not change scores or sorting.
4. Open **Setup & interests** from Settings or Browse. **Detected** shows compact, grouped recommendation inputs with one checkbox and inline details per item. **Added by you** opens a searchable multi-select picker immediately: check several apps/features, add custom topics from the same search, then **Save changes** once. Saving does not activate Browse filters or select plugins for installation.
5. Select a card to open its full detail page. The primary **Install…** action opens a confirmation and defaults to enabling ordinary plugins; widget placement is explicit, and shell replacements require opt-in. Open, enablement, bar position, and **Uninstall plugin…** share a persistent control area. Open is available for confirmed enabled plugins declaring a standard panel, overlay, or menu; it requests the interface without implicitly enabling it. A disabled widget's location is staged until you enable it. Uninstall requires confirmation; first-party plugins and Outfit itself are protected. Confirmed local state is kept separate from in-flight intent.
6. Use **Add to batch install** to collect up to 50 available plugins. **Remove from batch** removes a selection. **Review batch install** shows source status, placement, exclusive replacements and additional requirements before confirmation.
7. Batch install runs one plugin at a time. Ordinary plugins are enabled automatically, bar widgets use their selected placement, and exclusive replacements remain inactive unless explicitly selected. Progress, stop-after-current, resume and retry controls preserve each outcome.
8. Use the top-right **Settings cog** to control 60-second local hardware checks, optional GitHub README enrichment, and **Show marketplace thumbnails** (on by default). Browse-card thumbnails load independently of README enrichment. The adjacent **More actions** menu contains **Rescan system**, a local-only inventory/hardware check, and **Refresh catalog**, which updates listings and marketplace like counts. Settings has a **Back** button; the corner **×** closes Outfit.
9. **Add to batch install** collects several plugins; a selected plugin offers **Review batch install** as its primary action. Manual-only listings offer the project page. A failed operation offers contextual recovery, and unknown inventory pauses mutations. The inspector retains its selection when a plugin leaves the current filter/page.
10. Documentation opens expanded with theme-aware headings, lists, links, tables and code blocks, capped at 24,000 source characters. The README is fetched from the listing's exact revision when enrichment is enabled. Repository HTML and inline images are not rendered; links open only after an explicit action. Preview media remains separately validated, and video is requested only after **Play demo**, initially muted.

Quick Scan filters and reranks the merged local inventory and cached marketplace data against the in-memory hardware profile. Filters are applied before grouping and pagination. When enabled in **Settings**, Outfit also checks hardware every 60 seconds after analysis and on reopening when the last scan is at least a minute old. These follow-up checks are local-only. Background scans and enrichment do not occupy the interactive search queue.

Quick Scan supports `Ctrl+F` to focus search, `Ctrl+S` to save settings changes, and `Esc` to cancel a confirmation, close the inspector, return from review, or close the window.

Sidebar counts use parentheses, such as **Installed (12)**; unconfirmed counts show **(—)**. Routine automatic scans finish quietly. Manual scans and catalog refreshes use short header progress/completion messages. **More actions** contains compact Catalog, Popularity, and System update ages; exact UTC timestamps remain in Diagnostics. Failed updates stay visible, and optional popularity-data warnings appear in More actions.

The compact header combines branding, Browse navigation, and window
actions. Filters start expanded. **Collapse filters** gives the grid more width;
**Filters** expands the sidebar again. It has just two states: expanded or collapsed.
The choice is retained for the shell session. Active filter chips remain visible.
The grid uses additional columns as space permits, with readable minimum widths.
With thumbnails enabled, every card reserves a preview area. Missing or failed
images use a theme-aware toolbox placeholder; title, status, metrics and text
slots keep descriptions aligned. Installed badges share the button corner radius.

### Search

Starting a search automatically selects **Best match**, a relevance sort separate
from **Recommended**. Choose another sort to keep it while editing that search;
clearing the query restores your previous browse sort. Reopening retains the
current search and sort for the shell session. Search sorting does not save preferences.

Complete matches exclude partial matches. If there are no complete matches, a
discreet **Partial matches** line identifies the fallback results; status, source,
purpose, category, verification, hardware and saved-interest filters still apply.
Zero-result searches may offer **Did you mean …?**. Click it (or focus it and press
Enter) to populate and run the suggested query with the same filters. Queries are
never silently corrected.

While searching, a short plaintext search excerpt replaces the description in
cards and List view. README excerpts have a separate **README match** label.
Clearing the search restores descriptions. Title, badges, metrics and detail
actions stay available in every density. The sidebar's **SELECT A FILTER** heading
introduces saved-interest shortcuts; selecting several retains their OR behavior,
combined with search and the other filter types using AND.

### Browse views and density

Typography follows the live Omarchy theme font family and resolved font sizes.
Browse descriptions and metric values use the body role
(12 px by default), with slightly larger bold titles and readable small-body
metadata/badges. Likes, GitHub stars, Views and Copies appear in that order, each with an icon and the full count.
Browse metric icons are drawn at 16 px by default and scale with the body
font. Detail and interests retain their enlarged reading sizes (about 13 px by
default) and roughly 18 px drawn icons. Larger fonts remeasure counts, grow rows
and wrap layouts without applying theme scaling twice. Interest sections stay
bounded to 540 theme-scaled units with controls nearby.
Metrics use compact text/icon-height rows (about 20–24 px by default), 4-unit
row gaps. Browse has no metric info `(i)` icons: hover or click an icon/count for
its explanation. A metric click shows help without opening the plugin; clicking
the rest of the card opens details. With a card focused, Enter/Space opens details;
F2 focuses the first metric, arrows move through metrics, and Enter/Space shows
or restores their help. Help dismisses on pointer leave, outside press, Escape,
scroll, view changes or window deactivation; fresh hover/click or keyboard navigation
rearms it without sticky mouse focus. Detail-page info icons remain available.
All four Browse modes measure the four natural icon/count widths and keep them
on one line whenever possible, reducing the three gaps from 8 to 2 theme-scaled
units before wrapping. Counts are never abbreviated or text-shrunk.

Four icon buttons beside **No grouping / Group by category** select **Comfortable**,
**Compact**, **Dense**, or **List**. Hover or focus an icon for its label; Left/Right changes
the selected mode. Comfortable is the initial default. The choice is saved
automatically across app and shell restarts and shared by both grouping modes.

Compact and Dense use smaller preview frames and tighter spacing while preserving
text sizes, thumbnails/placeholders, descriptions, badges, metrics and status.
Browse grid cards allow four description lines, reclaiming space from matching
explanations and redundant footer actions. Preview height caps are 160 / 120 / 96 theme-scaled units;
nominal minimum card widths are 290 / 260 / 240. Actual minimums also accommodate
one full-count metric row with minimum gaps. Large counts/fonts can therefore
reduce the number of cards per row. Only when the available pane cannot fit that
minimum do metrics wrap to two columns or one; an individually oversized count
wraps its digits rather than clipping. Images preserve their aspect ratio.

Switching density reflows the current page in place, preserving the top visible
plugin where scroll bounds allow, selected inspector, grouping and filters.
The number of columns depends on available space; some widths gain density mainly
through shorter cards. The accessible card itself opens details, without a redundant
Details button or chevron. Plugin type is bottom-left, Verified/Unverified bottom-right;
matching explanations live in the detail page. Density saves are local-only and isolated
from unsaved Settings drafts; a failed save can be retried by selecting the mode again.

**List** uses one full-width horizontal row per plugin. A 16:9 thumbnail or toolbox
placeholder sits beside the name, New badge, description and exact metric
counts. Stars, Likes, Views and Command copies appear in every Browse mode and
grouping. Recommended and Hardware fit remain available for sorting, and hardware
filtering remains operational. Both scores appear with the four popularity metrics
on the six-metric detail page.
Installation/queue status and enabled/disabled state remain distinct from the
type/verification footer. Installed badges use tighter padding only on Browse cards.
Descriptions allow up to four lines. List status moves below the text when reserving
a side column would unnecessarily wrap the metrics.

List thumbnails are 80, 96 or 112 theme-scaled units wide. Row-height targets are
136, 112 or 96 for narrow, medium or wide results panes, growing for wrapped text
and metrics. Short text does not reserve empty lines. Explicitly disabling thumbnails
reclaims the image column. Up/Down moves between rows, including across category
headings; Enter/Space or a click opens the inspector, and Escape restores row focus.
List is optimized for line-by-line scanning; wide Dense grids can show more items.

**Verified** badges use marketplace verification status. **New** uses the
marketplace's rolling twelve-hour window from `listedAt`/`addedAt`, and expires
without requiring a download. The inspector also reports snapshot/revision state.

### Setup & interests and recommendations

The Detected page shows recognized recommendation signals, not an exhaustive
hardware inventory. It distinguishes hardware, installed software capabilities,
direct/inferred observations, and current/stale results. Failed probes retain
last-confirmed observations in memory; successful checks establish disappearance.
The suggestion checkbox changes a draft override; **Save changes** applies it.
Partial scan explanations remain visible; probe details and matching terms expand inline.

Select up to 64 saved interests across categories and searches without leaving
the picker. Add a custom topic directly from the search text (up to 64 characters).
All selections share one draft and one Save action; no per-interest review or
match-preview step is required. Existing multi-term interests remain supported.
Existing service choices migrate automatically; legacy goals/software/notes and
retired negative feedback remain inert. Known choices reuse existing interests.
Saved interests can be paused, resumed or removed, and remain useful with zero matches.
Any pending legacy edit remains visible inline and joins the same Save action.
Browse interest shortcuts include curated services, hardware features and custom
topics, and follow the current draft, so removed or paused interests disappear
immediately. Selected interests sit in a fixed-height horizontal chip strip with
Remove actions, leaving the picker at a stable position. Pause/Resume is hidden
while Discover is disabled; existing paused interests retain their saved state.
An accent-tinted save bar and highlighted Save button make unsaved changes explicit.
A save reminder remains visible
until **Save interests** applies the changes to recommendations. **Review changes…**
returns to an unfinished editor without discarding it. Discarding the draft restores
the saved shortcuts; active Browse filters remain independently selectable.
Custom and hardware filters use bounded local literal-match evidence, including
cached current-revision README evidence when enabled. Selected filters OR together;
search and other facets AND with that union. Draft filters do not save interests
or change saved recommendation scoring. A selected filter retains its criterion
snapshot if its shortcut is subsequently paused or removed.

**Discover is temporarily disabled for launch.** `Service.qml` declares the
non-persisted launch flag `property bool discoveryEnabled: false`. There is no
Settings, environment or summon-payload override. Future-feature QML tests explicitly
opt in by setting this service property to `true`; a future release can reverse the
default without removing the existing feature implementation.

While disabled, Discover/Ideas/Matches navigation, inbox indicators and review
controls are hidden. Old summon, session and batch-resume payloads requesting
`workspaceView: "discover"` resolve to Browse. Idea fetching and saved-interest
inbox checks/review requests are blocked at the service boundary, including after
catalog, scan, README-index and interest updates. Existing saved interests and
review bookkeeping are preserved. Local recommendation scoring, context loading,
interest previews, multi-select editing, saving and Browse service shortcuts remain
available. The backend's legacy discovery/query-cache commands remain callable for
tests. IPC status reports `discoveryEnabled`; consumers must not wait for
`matchesLoaded` when it is false (the fixture capture harness follows this rule).

Recommendations combine enabled detected and saved evidence without double-counting
the same matching phrase. **Hardware Fit** and its sort/filter use detected hardware
only; **Recommended** additionally considers saved interests and software capabilities.
The inspector explains the origin, matched field/phrase, exact/related strength and revision.

### README search coverage

With **Use GitHub READMEs and previews** enabled, Outfit automatically indexes
eligible marketplace READMEs while its window is open. A separate low-priority
worker handles up to twelve documents per batch with four download workers. It
yields to scans and plugin changes, pauses on close, and resumes committed work
next time. **More actions** and **Settings** show indexed/pending/unavailable
counts and **Pause indexing / Resume indexing**. Pausing preserves cached search.

Search combines listing metadata with the local README index and explains README
matches. Typing never requests README downloads. Coverage grows progressively;
unavailable documents and temporary errors are reported separately and retried
with backoff. Each document is pinned to the catalog commit; changing that commit
invalidates the old document for search. Shared repository/revision pairs are
downloaded once. A bounded set of common README paths is checked without using
GitHub credentials or falling back to an unpinned branch.

Indexed text includes prose and command/code terms, up to 24,000 sanitized
characters from responses bounded to 256 KiB. The transactional SQLite search
database has a 256 MiB limit and is separate from the 320-entry inspector cache.
Documents exceeding limits or missing at supported paths do not count as complete
coverage. Indexing does not fetch images or video. Visible-card thumbnails follow
their separate setting. Disabling README enrichment disables README search too.

Browse cards use the marketplace's small thumbnail when available. Missing images keep the card usable. The full detail page exposes all six metrics in a single wrapping row inside a distinct themed container. All metrics provide hover, click and keyboard help; only Recommended and Hardware fit retain info icons. Why recommended starts collapsed below the right-hand computer controls, returning to the main scrolling content in narrow layouts. Documentation starts expanded. **★** shows GitHub stars and **♥** shows anonymous marketplace hearts. An em dash means unknown; zero means a reported zero. Hearts are read-only reactions, not unique-user ratings. **Fit** is a heuristic hardware match; **Recommended** blends purpose-relative GitHub popularity with hardware fit.

Browse defaults to **Most liked**. Sort by **Recommended**, **Most starred**, **Hardware fit**, **A–Z**, **Recently added**, **Recent activity**, **Most liked**, **Most viewed**, or **Most copied**. Added uses `listedAt` with `addedAt` fallback; activity uses the newest valid `versionUpdatedAt`/`repositoryUpdatedAt`. Copies mean successful install-command copies, not confirmed installations. Unknown values sort last; ties use name and plugin ID. **All / Verified / Unverified** filters use marketplace status and exclude local-only/built-in/suite entries from verification-specific matches. Detail text retains revision-specific review information.

The retained, disabled Discover implementation combines deterministic daily ordering and session rotation with owner/task-family diversity. Its editorial notes remain in `data/discovery.json`, and its saved-interest review bookkeeping remains intact. There is no telemetry, rating submission or automatic installation.

**Not a fit** has been retired. Legacy stored feedback is preserved as inert data; it no longer changes scores, styling, filtering or discovery. The legacy feedback command is explicitly rejected.

Purpose filters include **Messaging**, **Files, Sync & Backup**, **Email & Calendars**, and **News & Weather**, alongside the existing desktop, appearance, media, productivity, hardware, power, network, development and games purposes. New purpose rules use the listing's primary task, with exclusions for AI chat, theme integrations, and ambiguous service names.

## How It Works

The singleton service uses a persistent interactive query helper, background scan/enrichment and README indexing workers, a serialized mutation helper, and a visible-card thumbnail loader. The raw hardware profile stays in memory. Public matching caches are revision-aware; the private batch journal retains bounded selection/outcome scores and a resume snapshot. The helpers:

1. Reads local signals for displays, input devices, connected Bluetooth names and bounded device metadata, USB products, system vendor, battery presence, graphics vendors, audio devices, selected installed capabilities, the authoritative local inventory from `omarchy plugin list --json`, and current bar sections from the local Omarchy shell configuration.
2. Downloads and validates the community catalog from `https://plugins.omarchy.org/catalog.json` when no current cache exists or when refresh is requested.
3. Merges catalog records with local inventory. Locally shipped Omarchy plugins are labeled **First party**; installed community plugins are labeled **Third party**. Local-only records remain filterable even when no marketplace listing is cached.
4. Scores listing names, IDs, tags, categories, descriptions, and optional README text against the local hardware and capability profile. Each result includes bounded evidence records showing the signal, matched term, listing field, and contribution.
5. If README enrichment is enabled, fetches at most 12 broad candidates' `README.md` files during analysis at each listing's exact `listingValidatedCommit`, then reranks with the extracted plain text. Interactive searches use only cached README text and never wait for network enrichment. Opening another plugin's inspector can fetch its bounded exact-revision README to discover a preview and prepare the sanitized full text.
6. Uses unadjusted recommendation scores. Legacy negative feedback is not applied.
7. Matches Quick Scan's bundled app and service registry against listing names, tags, and descriptions using exact curated terms plus reviewed inclusions and exclusions for ambiguous names. Active service filters form a deduplicated union; every result identifies why it matched. **Most starred** orders by reported GitHub stars, including manual-setup listings, with stable name and ID tie-breaking. This matching is local and never turns an interactive choice or search into a README request.
8. Classifies purpose from the merged local inventory and listing metadata, with cached README text as a fallback for broad purposes. Contextual facets are computed before grouping and pagination. Recommended order combines 60% logarithmically normalized GitHub stars within the purpose group with 40% hardware fit; zero-fit entries remain visible. **Most liked** is the default Browse sort. All sorts behave consistently with or without category grouping.
9. Before every management action, validates the plugin ID and rereads authoritative inventory or the validated cached marketplace record. Install runs `omarchy plugin add <validated-github-repo>.git --yes`; selected bar placement runs `omarchy plugin enable <id> <left|center|right>`; enable and disable use their native Omarchy commands; and confirmed third-party removal runs `omarchy plugin remove <id> --yes`. Outfit cannot toggle or remove its own running plugin, but it can move its own bar widget.
10. Runs setup installations serially, advances after authoritative inventory confirms each result instead of using a fixed inter-item delay, records completed, partial, failed, skipped, and queued states, and reads the installed Git checkout revision when available. The reviewed marketplace revision and installed revision are reported separately when they differ.
11. Extracts at most four useful README media references before converting Markdown to plain text. Relative image and video paths are pinned to the listing's exact commit; badges, logos, traversal paths, arbitrary image hosts, and unrecognized embeds are discarded. Preview images and video posters are downloaded by the helper under byte and pixel limits, stored in owner-only temporary cache slots, and rendered as static local images. Remote and device-derived strings are rendered as plain text in QML.

Probe commands use fixed argument arrays, short deadlines, bounded output, a restricted environment, and process-group cleanup. Backend HTTP requests require approved HTTPS hosts, constrained redirects, deadlines, and response-size limits. Qt displays images only from the bounded local cache; GitHub-hosted video transfer starts only after explicit playback.

Enable, disable, bar placement, and removal are local-only operations and do not fetch catalog or README data. Installation clones from the validated GitHub repository recorded in the cached marketplace entry and invokes Omarchy's native validation before the plugin is added. Removing a plugin does not automatically delete that plugin's separate configuration or cache unless the plugin's own removal behavior does so. Remove Outfit itself with the terminal command in the **Removal** section.

Omarchy may reload shell plugins after install, enable, disable, bar placement, or removal. Outfit's kept session service restores Quick Scan's query, categories, services, filters, sort, page, selected plugin, and unsaved settings from memory when reopening after a plugin reload. On stock Omarchy the window may briefly disappear; uninterrupted window continuity is not required for normal use. Setup selection and batch outcomes use a bounded local journal so an interrupted shell session can be reviewed and explicitly resumed or retried.

## Privacy And Storage

Opening the Outfit editor starts analysis and grants hardware access for the current shell session. When the watcher is enabled in **Settings**, local-only rescans run every 60 seconds and when reopening a stale session; stopping or restarting the shell clears the raw hardware profile. Outfit does not scan the LAN, use telemetry, upload the hardware profile, inspect application usage or process history, or persist the raw hardware profile.

Network requests expose the following metadata:

- A catalog request tells `plugins.omarchy.org` that the public marketplace catalog was requested.
- Opening-session analysis can fetch the public aggregate heart counts from `https://api.omarchyplugins.com/v1/stats` when its cache is more than 15 minutes old; **Refresh catalog** explicitly refreshes them. This is one bounded read-only request with no credentials, selected plugin IDs, search text, or hardware data. Browsing, filtering, and local rescans use cached totals. Outfit does not send view, copy, or heart events.
- When marketplace thumbnails are enabled, visible cards and a small scroll margin request images only under `https://plugins.omarchy.org/assets/img/plugins/`. These requests reveal the preview assets viewed, but do not send search text or hardware data. Up to 12 images are queued per batch with four concurrent downloads. Changing visible results or closing the window cancels obsolete thumbnail work.
- README enrichment tells GitHub which candidate owner, repository, and exact commit were requested. Those candidates are selected from broad local analysis matches, so the request set can indirectly suggest relevant hardware. Interactive search terms do not trigger README requests. Opening a plugin inspector identifies the selected repository and may request its validated preview images or video poster through the bounded helper cache. Video data is requested only after **Play demo**; YouTube links open externally only after **Watch demo**. README and preview enrichment can be disabled in **Settings**.
- Automatic README indexing requests public repository/revision documents across the eligible catalog while Outfit is open. This first pass may involve thousands of bounded text requests. It sends no search query, watchlist or hardware data. Pause/resume is available in More actions and Settings; GitHub rate limits and complete network failures trigger persisted backoff.
- Installing a plugin contacts its validated GitHub repository and downloads that repository through Omarchy's native plugin installer.

Owner-only cache files are stored under `~/.cache/io.github.ctl0v0.omafit/`:

- `catalog.json`: normalized public marketplace metadata, refreshed after 24 hours during an explicit analysis or immediately with **Refresh**.
- `engagement.json`: validated marketplace heart/view/copy totals and their fetch time, capped at 2 MiB. Old heart-only caches remain readable with unknown views/copies. A failed refresh retains previous totals.
- `readme-search.sqlite` and SQLite sidecars: revision-keyed search text, document state and retry metadata. Completed documents survive interrupted indexing; no hardware profile or search history is stored. Diagnostics reports coverage and truncation counts.
- `readmes.json`: bounded plain-text README search text, excerpts, sanitized display content, and up to four validated media references keyed by plugin ID and exact commit. Up to four bounded local image or poster files are kept separately and replaced when another plugin's previews are prepared. Older flattened cache entries remain readable and are upgraded lazily when inspected.
- `thumb-*.{webp,png,jpg,gif}`: marketplace thumbnails, kept separately from inspector media. Each file is capped at 2 MiB and four megapixels; the retained cache is bounded to 256 files and 64 MiB. New catalog revisions get fresh cache identities, with an older image used if a refresh is offline. Marketplace previews are presentation assets, not evidence of the exact reviewed Git revision.

The cache is not required for removal and can be deleted independently:

```bash
rm -rf ~/.cache/io.github.ctl0v0.omafit
```

Settings are stored in owner-only `~/.config/io.github.ctl0v0.omafit/preferences.json`.
Saved criteria, detected-input overrides and minimal match-review bookkeeping live
in `interests.json` (schema 1, 4 MiB cap, at most 10,000 listing records). They use
revision checks and atomic scoped writes. Service IDs remain an effective compatibility
mirror. Scan reports/raw device profiles are not stored there. Reset settings preserves
interests and review state; removing the configuration directory deletes both.

The batch-install journal `quick-setup.json` stores at most 50 selections, activation
choices, reviewed/installed revisions, recommendation-score snapshots and outcomes.
Its bounded resume snapshot can include the current search, filters, selected plugin,
viewport and settings draft; it is not a general browsing-history log. A batch interrupted
by a full shell restart restores paused and requires explicit retry after verification.

```bash
rm -rf ~/.config/io.github.ctl0v0.omafit
```

## Limitations

- Matching is deterministic text scoring, not a compatibility guarantee or security endorsement.
- Marketplace review labels are shown as supplied by the catalog. Review the repository and exact listed revision yourself.
- Omarchy installs the repository's current revision, which can be newer than the marketplace-reviewed revision. The setup progress view reports both revisions when the installed checkout is available.
- First-party plugins can be disabled only when Omarchy marks them disableable, and cannot be removed through Outfit.
- Active bar replacements have no off state in Omarchy and therefore do not expose a toggle.
- README indexing is progressive and bounded. Matching uses available cached documents;
  the coverage report distinguishes incomplete evidence from confirmed absence.
- README media detection is heuristic. Repositories without a useful supported image or demo keep the normal text-only inspector, and unsupported video codecs fall back to opening the validated URL externally.
- App and service matching is a maintained text-based curation layer, not a claim of official integration or endorsement. Listings can change between registry updates; each result exposes its match reason and source for review.
- Some hardware is unavailable through normal user-level interfaces and may not produce a signal.

## Validation And Tests

```bash
./tests/run
./demo/run
omarchy plugin validate .
```

The fixture demo uses fictional catalog and hardware data and performs no system scan or network request.

The default test runner requires Qt parsing and executable Qt lifecycle tests.
Use `./tests/run --python-only` only for explicitly partial checks, and
`./tests/run --require-omarchy` for the native validation gate. See
[RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) for the isolated VM lifecycle runner,
fault scenarios, actual hosted-UI fixture capture and performance benchmark.

Development controls use `OUTFIT_DEMO_ROOT`, `OUTFIT_DEMO_SCENARIO`,
`OUTFIT_DEMO_THUMBNAILS`, `OUTFIT_DETAIL_STATE`, `OUTFIT_VERIFY_INTERESTS`,
`OUTFIT_VERIFY_SEARCH_SCROLL` and `OUTFIT_TEST_VM`. Their historical `OMAFIT_`
spellings remain fallbacks; a nonempty `OUTFIT_` value takes precedence. VM checks
still require the same virtualization, ownership and path guards. Recovery
markers, temporary fixture/candidate prefixes, fixture IDs/URLs, evidence JSON
keys, the `omafit` guest share and `/home/tester/omafit` checkout retain their
historical names so existing recovery and evidence workflows remain valid.
The UI mutation harness is now `tests/vm/outfit_mutation_check.py`.
Historical screenshots and release-evidence paths in the checklist are unchanged.

**Settings → Check diagnostics** produces a redacted version/cache report that can
be copied for support. **Clear preview cache** preserves preferences, feedback,
catalog and setup selections. See [SUPPORT.md](SUPPORT.md) for recovery guidance.

## Full detail page and development fixtures

The production inspector uses a full detail view in the existing Outfit window: a
preview-led overview, compact always-expanded metrics, prominent source/listing
links, and a persistent group of installation and management controls. Matching
evidence and long documentation start collapsed. At short, narrow sizes, preview
and summary sit side by side above a pinned control tray.

`ui/PluginDetailPage.qml` is presentation-only. `demo/DetailPrototype.qml` supplies
ten fictional states and in-memory interactions, including a simulated Open
panel and uninstall confirmation. It is loaded only for the isolated `details`
demo scenario. Source/listing buttons produce demo notices; there are no native
plugin mutations or browser launches from the prototype. Normal browsing uses
the same presentation component connected to canonical inventory, native actions,
validated previews/video and source links. Back preserves the
originating Browse state. The development fixture selector does not appear
in normal use.

Inside the disposable VM, after installing the matching candidate:

```bash
OUTFIT_TEST_VM=1 python3 -B demo/ui_capture.py --scenario details \
  --detail-state installed --output /existing/evidence/directory/installed.png
```

Use `--narrow` for the 760×540 layout, or `--detail-interactions` with an installed,
disabled, or pending fixture for recorded interaction evidence (the installed
interaction sequence uses the normal-size window). The harness restores the
normal shell, workspace, cursor and configuration and writes provenance beside
each image. See [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) for verified evidence
and the remaining production-integration boundary.

## Host lifecycle integration

Outfit uses the canonical session `OMARCHY_PATH/bin` for native Omarchy commands and
a restricted PATH containing that directory plus system executables. On hosts exposing
the version-1 lifecycle API, batch install acquires a short renewable visual-reconciliation
lease, releases it on completion/stop/failure, then checks settlement and plugin load errors.
Leases expire automatically and do not roll back filesystem/configuration changes.
Stock hosts without that optional API use the regular native commands and the
acknowledgement-based panel-restoration fallback. A repeated host reload may discard
an accepted open request; Outfit retries with
a new token and a bounded deadline, rejecting late requests from earlier attempts. Closing
Outfit intentionally cancels recovery for the operation group. Reopening from Apps or the
bar restores recovery for later operations; a closed batch remains suppressed until it ends.
The read-only status IPC includes `panelRecovery` flags without exposing tokens or view data.

Separate development-host experiments implement targeted reconciliation to preserve
window/background/bar surfaces during ordinary add/remove. Those experiments are
optional developer work, not installation prerequisites or evidence of uninterrupted
continuity on stock Omarchy. Outfit alone cannot eliminate stock-host plugin reloads.

## Update

```bash
omarchy plugin update io.github.ctl0v0.omafit
```

## Removal

Remove the optional launcher **before** removing the plugin, while its helper is
still installed. The launcher removal command is safe if no launcher was registered:

```bash
python3 -I -B "${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/io.github.ctl0v0.omafit/scripts/launcher.py" --remove
omarchy plugin remove io.github.ctl0v0.omafit
```

Preferences, saved interests, batch recovery state and caches are retained. If you
also want to erase that data, explicitly opt in to the following cleanup:

```bash
rm -rf -- "${XDG_CACHE_HOME:-$HOME/.cache}/io.github.ctl0v0.omafit"
rm -rf -- "${XDG_CONFIG_HOME:-$HOME/.config}/io.github.ctl0v0.omafit"
```

## Security

Omarchy plugins run as unsandboxed code inside `omarchy-shell`. Review this repository before enabling it. Process and network boundaries are in `Service.qml`, `BackgroundWorker.qml`, `ThumbnailLoader.qml`, the optional video components, and `scripts/outfit.py`. See [SECURITY.md](SECURITY.md) for reporting instructions.

## License

MIT, Copyright 2026 ctl0v0
