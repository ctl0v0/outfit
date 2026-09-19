# Outfit technical guide

This describes the new **0.2.0** build, whose plugin ID is
`io.github.ctl0v0.outfit`. Start with the [README](../README.md) or
[user guide](USER_GUIDE.md) for everyday use. The version in the manifest does not
imply that a Git tag, public source update, or search-pack release already exists.

## Runtime and requirements

- Supported baseline: stock **Omarchy 4.0.4 stable with Quattro** and shell-plugin
  support. A custom host checkout or `omarchy dev link` is not required.
- Python 3.12 or newer at `/usr/bin/python3`; helpers run in isolated mode.
  Development verification uses Qt 6.11.2 and Python 3.14; portable CI configures
  Python 3.12. Fresh-machine public-revision verification is a separate gate in
  [RELEASE_CHECKLIST.md](../RELEASE_CHECKLIST.md).
- Kinds: `service`, `bar-widget`, `panel`. The singleton service stays loaded for
  the shell session. Optional Qt Multimedia/codecs enable inline video; missing
  support offers external playback without blocking browsing.
- Existing tools such as `hyprctl`, `bluetoothctl`, `wpctl`, and `omarchy` supply
  optional probes. Missing probes are reported without failing the whole scan.
- No account, privileged setup, or additional Python package is required.

The optional Apps helper installs a marked desktop entry and scalable icon under
absolute `$XDG_DATA_HOME`, or `~/.local/share`. It is repeatable, refuses unrelated
launcher assets, and opens the existing shell-hosted panel. Native plugin install
does not run application-registration hooks. Native plugin registration uses
`$HOME/.config/omarchy/plugins`; Outfit's private data uses the XDG roots below.

## Startup and helper architecture

The singleton service coordinates a persistent interactive query helper,
background scan/enrichment workers, a low-priority README indexing worker,
serialized plugin mutations, and a visible-card thumbnail loader. Background work
does not occupy the interactive search queue.

1. Local loading supplies a bundled real public catalog snapshot on a fresh
   installation, or usable cached metadata on later opens. It needs no hardware
   scan or network round trip before browsing can begin.
2. Authoritative inventory is checked before optional full hardware analysis.
   Inventory readiness gates management independently of optional fit checks.
3. Catalog and public engagement data refresh in the background. Local inventory
   is merged with listings: shipped plugins are **First party**, installed
   community plugins **Third party**, and local-only records remain usable.
4. When documentation is enabled, a public search pack is downloaded, validated,
   and imported transactionally into the local search index. Remaining eligible
   README coverage grows through local upstream requests while the panel is open.
5. Background activity separates catalog, inventory, optional system fit, and
   optional documentation. Byte-download and document-import progress represent
   different phases. Unavailable documents can count as checked without becoming
   searchable; cached coverage does not mean all checks have completed.

Local probes read displays, input devices, connected Bluetooth names and bounded
device metadata, USB products, system vendor, battery presence, graphics vendors,
audio devices, and selected installed capabilities. Inventory comes from
`omarchy plugin list --json`, with bar sections from local Omarchy configuration.
The raw profile remains in memory. Failed probes retain last-confirmed in-memory
observations as stale; successful checks can establish disappearance.

## Matching, search, and presentation

Matching scores listing names, IDs, tags, categories, descriptions, and optional
cached README text against detected inputs and saved interests. Evidence records
identify the signal, matched phrase/field, strength, revision, and contribution.
Enabled detected and saved evidence avoid counting the same matching phrase twice.
**Hardware fit** uses hardware only; **Recommended** also uses software capabilities
and saved interests. Purpose-relative ranking combines 60% logarithmically
normalized GitHub stars with 40% fit; zero-fit entries remain visible.

The app/service registry uses curated exact terms and reviewed inclusions and
exclusions for ambiguous names. Purpose classification uses primary-task metadata,
with cached README fallback for broad purposes. Custom and hardware shortcuts use
bounded literal-match evidence, including current-revision cached README text when
enabled. This is text-based curation, not official integration or endorsement.

Search determines membership before the selected sort orders all results;
grouping and pagination follow. **Best match** is distinct from **Recommended**.
Complete matches suppress partial matches, and a spelling suggestion requires an
explicit user action. Multiple interest/service shortcuts form a deduplicated OR
union; other facets and the query AND with that union. Contextual facet counts are
computed before grouping and pagination. Search/sort changes do not save interests.

**Most liked** is the default Browse sort. Added-date sorting uses `listedAt` with
`addedAt` fallback; activity uses the newest valid `versionUpdatedAt` or
`repositoryUpdatedAt`. Unknown metrics sort last; name and ID break ties. Verified
and Unverified facets use marketplace status and exclude local-only, built-in, and
suite entries from verification-specific matches. **New** expires after the
marketplace's twelve-hour window without requiring a fresh download.

### Layout and accessibility

Typography follows Omarchy's live theme family and resolved sizes. Body text is
12 px by default, detail/interests reading text about 13 px, and metric icons
16 px in Browse and roughly 18 px in detail/interests. Larger fonts grow/wrap
layouts without double scaling. Interest sections are bounded to 540 theme-scaled
units with nearby controls.

Comfortable/Compact/Dense preview height caps are 160/120/96 theme-scaled units,
with nominal minimum card widths 290/260/240. Actual minimum widths also fit a
full-count metric row. Gaps shrink from 8 to 2 units before wrapping metrics;
counts are never abbreviated or text-shrunk. Oversized counts wrap digits rather
than clip. Grid descriptions allow four lines; images preserve their aspect ratio.

List uses 80/96/112-unit thumbnails for narrow/medium/wide panes and row-height
targets of 136/112/96, growing with wrapped content. Disabling thumbnails reclaims
their column. Larger counts or fonts can reduce grid columns; denser layouts can
gain space primarily through shorter cards. View changes preserve the top visible
plugin where scroll bounds allow. Density saves are local and independent of an
unsaved Settings draft; reselecting a mode can retry a failed save.

Metric help supports hover, click, and keyboard focus without opening the plugin.
It dismisses on pointer leave, outside press, Escape, scroll, view change, or
deactivation. Cards are themselves accessible open targets. The detail component
is `ui/PluginDetailPage.qml`, with persistent management controls, source links,
expanded documentation, and initially collapsed recommendation evidence. Narrow
layouts move explanation content into the main scroll area and retain controls.

## Search library and current measurements

The bundled catalog is metadata, not a bundled full README index. The separate
public gzip search pack seeds local documentation search after download/import.
It is fetched from the fixed project release alias:

```text
https://github.com/ctl0v0/outfit/releases/download/search-pack/latest.json
```

Source and assets may be published separately. Until compatible pack assets are
available, the pack stage can report unavailable and use progressive local
indexing. No `v0.2.0` tag is assumed by these instructions.

The current preparation measurements for this build (2026-09-18) are:

| Measurement | Current value |
| --- | --- |
| Compressed public pack | About 7.3 MiB |
| Documents included with matching license evidence | 3,159 of 3,464 candidate repository/revision documents |
| Local search index | About 29.9 MiB (roughly 30 MB for planning) |
| Measured cache | About 44 MiB |

These are a snapshot, not fixed download sizes, coverage promises, or storage
limits. Documents are deduplicated by repository and exact catalog revision, so
document counts are not plugin counts. Catalog updates, SQLite sidecars, images,
and locally added text change disk usage. The remaining documents are not
redistributed in the pack; eligible ones can still be fetched locally over time.

The builder requires pinned public sources and matching license evidence. Its
current redistribution allowlist is MIT, Apache-2.0, BSD-2-Clause, BSD-3-Clause,
and ISC. It preserves source license/notice text; missing or ambiguous grants are
excluded rather than inferred from public availability. See
[SEARCH_PACK.md](SEARCH_PACK.md) for the full policy, provenance, wire format,
builder, and publication gates. Outfit's license does not relicense these texts.

### Runtime bounds and fallback indexing

Pack processing checks source identity, schema/data version, hashes, sizes,
record bounds, and catalog revision compatibility. Import is transactional;
failure retains previous searchable text. Downloaded data seeds a locally built
SQLite index rather than supplying an executable plugin or a remote database.

Automatic local indexing processes up to twelve documents per batch with four
download workers. It yields to scans and plugin changes, pauses on close, and
resumes committed work. GitHub rate limits and complete network failures use
persisted backoff; unavailable documents have per-document retries. Pause/resume
retains cached matches; disabling README enrichment also disables README search.

Documents are keyed to the listing's exact `listingValidatedCommit`. Changing
that commit makes old text ineligible for current search. Shared repository/commit
pairs download once. A bounded set of common README paths is tried without GitHub
credentials or fallback to an unpinned branch. Analysis enrichment can request up
to twelve broad candidates; opening details can fetch another pinned README.
Interactive search never requests documentation.

Text includes prose and command/code terms, capped at 24,000 sanitized characters
from responses bounded to 256 KiB. The transactional search database has a 256 MiB
limit, separate from the 320-entry inspector cache. Truncated or unavailable
documents do not establish complete coverage. Indexing fetches no images/video.

## Privacy and network requests

Opening Outfit starts analysis and permits local hardware checks for the shell
session. When enabled, follow-up checks run every 60 seconds and on reopening a
stale session. The raw profile is not persisted and is cleared when the shell
stops/restarts. Outfit does not scan the LAN, inspect application usage/process
history, send telemetry, or upload a raw hardware profile. Derived preferences,
interests, bounded score/resume snapshots, and public caches can persist.

Network requests still reveal ordinary request metadata to their recipients:

- **Catalog:** `https://plugins.omarchy.org/catalog.json` provides public listings.
  Refresh uses the network; the bundled snapshot and cache enable local browsing.
- **Popularity:** `https://api.omarchyplugins.com/v1/stats` supplies aggregate
  hearts/views/copies. Session refresh can update a cache older than 15 minutes;
  **Refresh catalog** explicitly refreshes it. This bounded read-only request
  sends no credentials, selected IDs, search text, or hardware. Outfit submits
  no view, copy, or heart events.
- **Search pack:** the fixed project release URL above and GitHub's approved
  release-asset delivery host provide public metadata/text. These requests reveal
  a pack download, not a query, watchlist, or hardware profile.
- **READMEs:** public raw GitHub requests identify owner, repository, and exact
  revision. Broad analysis candidates can indirectly suggest relevant hardware;
  an inspector request identifies the selected repository. Progressive indexing
  can request documents across the eligible catalog, potentially thousands when
  no pack is available. Search text and saved interests are not sent.
- **Marketplace thumbnails:** visible cards and a small scroll margin request
  only `https://plugins.omarchy.org/assets/img/plugins/` images when enabled.
  Requests reveal viewed assets, not queries or hardware. Batches queue up to
  twelve images with four concurrent downloads; obsolete work is cancelled.
- **Detail media:** validated GitHub raw-content, attachment, and asset hosts can
  receive preview-image/poster requests. Video transfer starts only after **Play
  demo**; YouTube opens externally only after **Watch demo**. README enrichment
  and marketplace thumbnails have independent Settings controls.
- **Install:** native Omarchy downloads the validated GitHub repository. Enable,
  disable, placement, and removal are local-only and fetch no catalog or README.

### Private storage and retention

Outfit honors absolute XDG cache/config/data roots, falling back to their usual
home locations. Files are owner-only. The default cache is
`~/.cache/io.github.ctl0v0.outfit/`:

| File | Contents and bounds |
| --- | --- |
| `catalog.json` | Normalized public metadata; normal age threshold 24 hours, with explicit refresh available. |
| `engagement.json` | Public totals and timestamp, capped at 2 MiB; failed updates retain old values. |
| `readme-search.sqlite` and sidecars | Revision-keyed text, document/retry state, and search-pack receipt. Committed work survives interruptions; no raw profile or general search-history log. |
| `readmes.json` | Bounded inspector text, excerpts, formatted content, and up to four validated media references per cached entry. |
| `preview-*` images | Up to four bounded local preview/poster slots, replaced when another plugin's previews are prepared. |
| `thumb-*` images | Separate marketplace previews, up to 2 MiB/four megapixels each, at most 256 files and 64 MiB retained. |

Thumbnail identities change with catalog revisions; an older image can be used
when offline. Marketplace previews are presentation assets, not proof of the
exact reviewed Git revision. Older compatible caches are read/upgraded lazily.

Private settings default to `~/.config/io.github.ctl0v0.outfit/`:

- `preferences.json`: settings, including derived choices and view preferences.
- `interests.json`: saved criteria, detected-input overrides, and minimal review
  bookkeeping (schema 1, 4 MiB cap, up to 10,000 listing records). Revision checks
  and atomic scoped writes protect concurrent edits. Raw profiles are not stored.
- `quick-setup.json`: at most 50 selections, activation choices, reviewed/installed
  revisions, bounded score snapshots, and outcomes. A resume snapshot may include
  query, filters, selection, viewport, and Settings draft; this is not a general
  browsing-history log. A full shell restart restores an interrupted batch paused
  and requires explicit retry after verification.

Reset settings preserves interests/review state. Clear preview cache preserves
catalog, preferences, interests, and batch selections. Uninstall retains Outfit's
data; optional deletion instructions are in the [FAQ](USER_GUIDE.md#faq).
Early-build data/registration migration is explicit, documented in
[IDENTITY_MIGRATION.md](../IDENTITY_MIGRATION.md).

## Native operations and security boundaries

Before a management action, the helper validates the ID and rechecks authoritative
inventory or the validated cached listing. Install invokes
`omarchy plugin add <validated-github-repo>.git --yes`; bar placement uses
`omarchy plugin enable <id> <left|center|right>`. Enable/disable use native commands,
and confirmed third-party removal uses `omarchy plugin remove <id> --yes`.
Outfit cannot toggle/remove itself, but can move its widget. First-party plugins
cannot be removed here and expose disable only when supported; active bar
replacements have no off toggle.

Batches advance on authoritative inventory, preserve each outcome, and report
marketplace-reviewed and installed revisions separately. Native installation
uses the repository's current revision, which can differ from the reviewed one.
Installed is distinct from successfully loaded, enabled, or restart-required.
Removing another plugin does not necessarily remove its separate data.

Probes use fixed argument arrays, short deadlines, bounded output, a restricted
environment, and process-group cleanup. HTTP requests require approved HTTPS
hosts, constrained redirects, deadlines, and size limits. Up to four useful
README media references are extracted before text conversion. Relative media
is pinned to the catalog commit; badges, logos, traversal paths, arbitrary image
hosts, and unsupported embeds are discarded. Images/posters use bounded private
cache files. Remote/device strings are plain text; README formatting uses an
escaped allowlist, without repository HTML or inline images.

Omarchy plugins remain unsandboxed code inside `omarchy-shell`. Matching and
marketplace review labels are neither compatibility guarantees nor security
certifications. Media recognition is heuristic and some user-level hardware
signals are unavailable. See [SECURITY.md](../SECURITY.md) for reporting and review
boundaries in `Service.qml`, `BackgroundWorker.qml`, `ThumbnailLoader.qml`, media
components, and `scripts/outfit.py`.

## Host lifecycle and session recovery

Native commands resolve through the canonical session `OMARCHY_PATH/bin`, with a
restricted PATH including that directory and system executables. Stock hosts use
regular native commands and acknowledgement-based panel restoration. Plugin
install/enable/disable/placement/removal can reload shell surfaces and briefly
close Outfit. Reopening may take seconds; Apps or the widget is the manual fallback.

The kept service retains query, categories, services, filters, sort, page, selected
plugin, and unsaved settings in memory across surface reloads. Repeated reloads can
discard an accepted open request: bounded retries use new tokens and reject late
requests from earlier attempts. Intentional close cancels recovery for that
operation group; reopening enables recovery for later operations. A closed batch
remains suppressed until it ends. Read-only status exposes `panelRecovery` flags
without tokens or view data. Full shell restarts rely on the bounded batch journal.

Hosts exposing the optional version-1 lifecycle API can grant short renewable
visual-reconciliation leases for batches. Outfit releases the lease on completion,
stop, or failure, then checks settlement and load errors. Leases expire and do not
roll back filesystem/config changes. Current development-host work on targeted
reconciliation improves continuity; it is not evidence of uninterrupted stock
behavior. A separate upstream contribution draft is being prepared, with no
promised acceptance, release version, or date. Stock 4.0.4 is sufficient for use.

## Development and verification reference

For a local Git checkout, run from its root after committing the intended source;
Omarchy clones Git history rather than uncommitted files:

```bash
omarchy plugin add "$(pwd)" --enable
```

The project's documented checks are:

```bash
./tests/run
./demo/run
omarchy plugin validate .
```

The default runner requires Qt parsing and executable lifecycle tests.
`./tests/run --python-only` is explicitly partial; `--require-omarchy` adds the
native validation gate. The fixture demo uses fictional catalog/hardware data,
with no system scan or network request. Passing isolated checks does not establish
that a public revision has passed fresh-machine validation.

Development controls include `OUTFIT_DEMO_ROOT`, `OUTFIT_DEMO_SCENARIO`,
`OUTFIT_DEMO_THUMBNAILS`, `OUTFIT_DETAIL_STATE`, `OUTFIT_VERIFY_INTERESTS`,
`OUTFIT_VERIFY_SEARCH_SCROLL`, and `OUTFIT_TEST_VM`. Compatibility aliases and
frozen evidence history are recorded in [RELEASE_CHECKLIST.md](../RELEASE_CHECKLIST.md).
Retained disabled feature internals are not user-facing launch capabilities.

`demo/DetailPrototype.qml` supplies ten fictional detail states with in-memory
interactions for the isolated `details` scenario. Source/listing actions show
notices; no native mutation or browser launch occurs. Production uses the shared
presentation component wired to actual inventory, actions, and validated media.

Inside the disposable VM, with a matching installed candidate, the capture form is:

```bash
OUTFIT_TEST_VM=1 python3 -B demo/ui_capture.py --scenario details \
  --detail-state installed --output /existing/evidence/directory/installed.png
```

`--narrow` selects 760×540. `--detail-interactions` supports installed, disabled,
or pending states; installed interaction capture uses the normal-size window.
The harness restores shell/workspace/cursor/configuration and writes provenance.
See the release checklist for VM lifecycle, fault, UI capture, and performance
evidence. [Support](../SUPPORT.md) covers the redacted user diagnostic report.
