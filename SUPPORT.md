# Support and diagnostics

Outfit targets **Omarchy 4.0.4 stable with Quattro**. A stock installation is
sufficient; no custom host checkout or `omarchy dev link` is required. The current
development host uses Qt **6.11.2** and Python **3.14**; Python 3.12 is configured
in portable CI. Fresh-machine testing of the public source is still a separate
gate; historical VM results do not establish a tested public revision.

## Report an issue

Use the repository's Issues page: https://github.com/ctl0v0/outfit/issues

Include:

- the steps that reproduce the problem and what you expected;
- **Settings → Check diagnostics → Copy diagnostics**;
- whether it occurs offline, with previews disabled, or after restarting Outfit;
- a cropped screenshot if helpful, after checking it for private information.

The copied report contains versions, optional-command availability, cache sizes
and timestamps. It excludes hardware profiles, device names, paths and watchlist
contents. Review it before sharing. Never attach your entire configuration or
environment, credentials, or unrelated notification/history data.

## Recovery

- **More actions → Rescan system** retries hardware/inventory detection. Missing
  inventory disables mutations instead of guessing that a plugin is uninstalled.
- **More actions → Refresh catalog** retries remote data while cached browsing
  remains usable. A failed likes refresh retains previous counts.
- **More actions → README search** shows coverage and pause/resume controls.
  Indexing runs while Outfit is open and yields to manual maintenance. GitHub
  rate limits and complete network failures apply a persisted backoff; missing
  documents have longer per-document retries. Cached text stays searchable while
  indexing is paused. Disabling README enrichment also disables README matches.
- For a damaged README search database, close Outfit, remove only
  `readme-search.sqlite`, `readme-search.sqlite-wal`, and `readme-search.sqlite-shm`
  from `~/.cache/io.github.ctl0v0.omafit/` (or its XDG cache location), then reopen.
  The index rebuilds progressively. Keep the preferences and other caches.
- **Settings → Clear preview cache** removes only recognized local image files.
  It preserves the catalog, preferences, interests and batch-install queue. Wait for active
  preview work to stop if the control is temporarily disabled.
- **Retry startup** retries a helper/storage failure. The error distinguishes
  permissions/read-only storage from disk/quota exhaustion.
- Video support is optional. If Qt Multimedia or a codec is missing, use
  **Open externally**. Browsing does not depend on loading the video module.

Interrupted batch-install queues remain available for review and explicit retry. Do not
assume a timeout means installation failed: Outfit reconciles actual inventory
before reporting the resulting state.

On a host that globally reloads plugins, uninstall can temporarily close Outfit. Its
service retries reopening automatically, including when another reload discards the
first request. Recovery can take several seconds. An intentional close cancels it;
opening Outfit again from Apps or the bar enables recovery for later operations.
Keeping the original window continuously open requires targeted host reconciliation.

**Setup & interests** distinguishes a failed check from an absent device. Last-confirmed
signals can remain visible as stale. Reload saved inputs after a revision conflict; the
draft is retained until explicitly discarded. Saved interests with zero matches are valid.
Discover and Matches are disabled in the current launch configuration; saved
interests and Browse remain available.

The optional targeted lifecycle API can improve window continuity on development
hosts. It is not required for browsing, installation, enablement, placement or
removal on stock Omarchy. Native load errors and restart-required results remain
distinct from inventory-confirmed installation success. If stock-host recovery
leaves Outfit closed, reopen it from its bar widget or optional Apps launcher.
