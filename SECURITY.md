# Security reporting and boundaries

Use GitHub's private vulnerability reporting on this repository's Security page
when it is enabled. If it is unavailable, request a private contact channel in
an issue without including exploit details, credentials or personal data. Private
reporting must be enabled as part of the publication checklist.

Outfit is an unsandboxed Omarchy shell plugin. Its external Python helpers use
fixed executable paths and argument arrays, bounded input/output, restricted
probe environments, timeouts and process-group cleanup. Remote content is
untrusted: URLs are host/path constrained and cache writes are private and atomic.
Listing and device text is rendered as plain text. README formatting uses an
escaped markup allowlist; repository HTML and inline images are not rendered.
Optional video is loaded only on explicit playback.

Review `scripts/outfit.py`, `Service.qml`, `BackgroundWorker.qml`,
`ThumbnailLoader.qml`, and the media components when changing those boundaries.
New network hosts, subprocesses, write locations or automatic actions require
matching documentation and adversarial regression tests.

The demo environment is explicit and isolated by `OUTFIT_DEMO_ROOT` (with the
historical `OMAFIT_DEMO_ROOT` fallback); it dispatches
to the fictional helper instead of the system helper. Demo plugin mutations and
real network/probe commands are disabled. The VM/capture harnesses refuse physical
hosts. They do not certify that a release works on hardware not yet tested.

Static validation and passing tests are scoped evidence for a particular source
revision, not a security certification or a guarantee about third-party plugins.
