# Changelog

## 0.3.0 — 2026-09-20

### Plugin updates

- Inspect installed and upstream versions/revisions from plugin details.
- Review available updates in a virtualized table, with individual and batch
  updates through native Omarchy commands.
- Update Outfit separately through **More actions → Update Outfit…**; an
  independent user-systemd worker verifies the result and reopens the app.
- Show local customizations, manual installations, and unavailable checks as
  distinct states. Preserve local edits rather than overwriting them.

### Previews and usability

- Fall back to suitable screenshots from pinned GitHub READMEs when marketplace
  previews are missing or unavailable, respecting both preview/README settings.
- Cache preview discovery, back off failed image requests, and keep useful
  in-flight work while scrolling.
- Return pagination to the top of new results while preserving detail-Back position.
- Align update controls to the right, use compact table rows with left-side
  expanders, and match confirmation buttons to the theme's corner radius.
- Place version information above recommendations and update checking with the
  installed-plugin controls.

### Performance and reliability

- Pause optional work when closed and sleep after 30 seconds, releasing the query
  helper and heavy view data. Explicit saves and plugin operations finish safely.
- Construct only the active Browse layout and visible Updates delegates; coalesce
  viewport work, bound image decoding, and release inactive document/media content.
- Avoid unrelated Git-version scans during targeted updates, merge concurrent
  README-cache writes, skip unchanged search packs when coverage remains valid,
  and prune obsolete attribution records.
- Bound IPC before complete-line delivery, preserve Unicode with escaped JSON,
  validate request ownership, and fix timeout, EOF-handoff, and rapid-reopen races.

Validation and measurements: [backend results](tests/PERFORMANCE_RESULTS.md),
[native lifecycle results](tests/vm/PERFORMANCE_RESULTS.md), and
[plugin-update results](tests/vm/PLUGIN_UPDATES_RESULTS.md). Performance gains are
workload-specific; cold queries did not demonstrate a general speedup.

## 0.2.0

- Introduced the `io.github.ctl0v0.outfit` identity and explicit migration helper.
- Added immediate bundled-catalog browsing, public documentation search packs,
  background preparation status, and local README relevance search.
