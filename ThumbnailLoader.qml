import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  visible: false
  property string helperPath: ""
  property string revision: ""
  property var rows: []
  property var images: ({})
  property var attempts: ({})
  property int generation: 0
  property int activeGeneration: 0
  property var activeRows: []
  property bool active: false
  property bool cancelled: false
  property bool received: false
  property bool exited: false
  property bool ready: false
  readonly property string identity: (enabled ? "on" : "off") + "|" + revision + "|"
    + JSON.stringify(rows.map(function(row) { return [row.id, row.previewThumbnail || row.previewImage] }))

  onIdentityChanged: {
    if (!ready) return
    generation++
    if (active) {
      cancelled = true
      worker.running = false
      killDeadline.restart()
    }
    schedule.restart()
  }
  onRevisionChanged: {
    images = ({})
    attempts = ({})
  }

  function startNext() {
    if (!enabled || active || !helperPath) return
    var batch = []
    for (var i = 0; i < rows.length && batch.length < 12; i++) {
      var row = rows[i]
      var url = String(row.previewThumbnail || row.previewImage || "")
      if (!url) continue
      var cached = images[row.id]
      if (cached && cached.url === url && cached.revision === revision && cached.localSource) continue
      if (Number(attempts[row.id] || 0) > Date.now()) continue
      batch.push({ id: row.id, url: url })
    }
    if (!batch.length) return
    activeRows = batch
    activeGeneration = generation
    cancelled = false
    received = false
    exited = false
    active = true
    worker.stdinEnabled = true
    deadline.restart()
    worker.running = true
  }

  function acceptResponse(text) {
    if (!active || cancelled || activeGeneration !== generation) return
    try {
      var result = JSON.parse(text)
      if (!result || result.ok !== true || result.action !== "thumbnails"
          || Number(result.generation) !== activeGeneration) return
      var next = ({})
      // Bound the in-memory map independently of the disk cache.
      var keys = Object.keys(images).slice(-128)
      for (var i = 0; i < keys.length; i++) next[keys[i]] = images[keys[i]]
      for (var j = 0; j < activeRows.length; j++) {
        var requested = activeRows[j]
        var image = result.thumbnails && result.thumbnails[requested.id]
        next[requested.id] = { url: requested.url, localSource: image && image.url === requested.url
          ? String(image.localSource || "") : "", revision: revision }
      }
      images = next
    } catch (error) { }
  }

  function finish() {
    if (!active || !exited || !received) return
    deadline.stop()
    killDeadline.stop()
    drainDeadline.stop()
    if (!cancelled) {
      var next = ({})
      var keys = Object.keys(attempts).slice(-128)
      for (var j = 0; j < keys.length; j++)
        if (attempts[keys[j]] > Date.now()) next[keys[j]] = attempts[keys[j]]
      for (var i = 0; i < activeRows.length; i++) next[activeRows[i].id] = Date.now() + 60000
      attempts = next
    }
    active = false
    activeRows = []
    schedule.restart()
  }

  Timer { id: schedule; interval: 180; onTriggered: root.startNext() }
  Timer {
    interval: 60000
    repeat: true
    running: root.enabled && root.rows.length > 0
    onTriggered: root.startNext()
  }
  Timer {
    id: deadline
    interval: 45000
    onTriggered: {
      worker.running = false
      killDeadline.restart()
    }
  }
  Timer { id: killDeadline; interval: 2000; onTriggered: if (worker.running) worker.signal(9) }
  Process {
    id: worker
    objectName: "thumbnailWorker"
    command: ["/usr/bin/python3", "-I", "-B", root.helperPath]
    stdinEnabled: true
    onStarted: {
      if (root.cancelled) {
        running = false
        return
      }
      write(JSON.stringify({ action: "thumbnails", generation: root.activeGeneration,
        pluginIds: root.activeRows.map(function(row) { return row.id }) }) + "\n")
      stdinEnabled = false
    }
    stdout: StdioCollector {
      objectName: "thumbnailCollector"
      waitForEnd: true
      onStreamFinished: {
        root.acceptResponse(text)
        root.received = true
        root.finish()
      }
    }
    onExited: {
      root.exited = true
      if (!root.received) drainDeadline.restart()
      root.finish()
    }
  }
  Timer { id: drainDeadline; interval: 50; onTriggered: { root.received = true; root.finish() } }
  Component.onCompleted: { ready = true; schedule.restart() }
  Component.onDestruction: if (worker.running) worker.running = false
}
