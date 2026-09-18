import QtQuick
import Quickshell.Io

Item {
  id: root
  visible: false
  property string helperPath: ""
  property bool active: false
  property bool started: false
  property bool exited: false
  property bool received: false
  property int generation: 0
  property int exitCode: 0
  property var activeRequest: ({})
  property var response: null
  property string failure: ""
  property bool cancelled: false
  signal finished(var result, var request)

  function submit(action, values) {
    if (active || !helperPath) return false
    generation++
    var request = JSON.parse(JSON.stringify(values || {}))
    request.action = action
    request.generation = generation
    activeRequest = request
    response = null
    failure = ""
    cancelled = false
    received = false
    exited = false
    started = false
    exitCode = 0
    active = true
    worker.stdinEnabled = true
    launchDeadline.restart()
    worker.running = true
    return true
  }

  function stop(message, intentional) {
    if (!active) return
    failure = message || "Background work cancelled."
    cancelled = intentional === true
    launchDeadline.stop()
    deadline.stop()
    worker.running = false
    if (worker.processId > 0) killDeadline.restart()
    else { exited = true; received = true; finish() }
  }

  function finish() {
    if (!active || !exited || !received) return
    launchDeadline.stop()
    deadline.stop()
    killDeadline.stop()
    drain.stop()
    var request = activeRequest
    var result = response
    if (!result || failure || Number(result.generation) !== request.generation
        || result.action !== request.action) result = {
      ok: false, action: request.action, generation: request.generation,
      error: failure || "Outfit's background helper returned an invalid response. Retry the action.",
      cancelled: root.cancelled
    }
    active = false
    activeRequest = ({})
    finished(result, request)
  }

  Timer {
    id: launchDeadline
    objectName: "backgroundLaunchDeadline"
    interval: 2000
    onTriggered: root.stop("Outfit's helper could not start. Check that Python 3 is installed, then retry.")
  }
  Timer {
    id: deadline
    interval: ["enrich", "refresh", "index-readmes"].indexOf(root.activeRequest.action) >= 0 ? 90000 : 45000
    onTriggered: root.stop("Background work timed out. Cached results remain available; retry the action.")
  }
  Timer { id: killDeadline; interval: 2000; onTriggered: if (worker.processId > 0) worker.signal(9) }
  Timer { id: drain; interval: 50; onTriggered: { root.received = true; root.finish() } }
  Process {
    id: worker
    objectName: "backgroundWorker"
    command: ["/usr/bin/python3", "-I", "-B", root.helperPath]
    stdinEnabled: true
    onStarted: {
      if (!root.active || root.failure) { running = false; return }
      root.started = true
      launchDeadline.stop()
      write(JSON.stringify(root.activeRequest) + "\n")
      stdinEnabled = false
      deadline.restart()
    }
    stdout: StdioCollector {
      objectName: "backgroundCollector"
      waitForEnd: true
      onStreamFinished: {
        try { root.response = JSON.parse(text) } catch (error) { root.response = null }
        root.received = true
        root.finish()
      }
    }
    onExited: function(code) {
      root.exitCode = code
      root.exited = true
      if (!root.received) drain.restart()
      root.finish()
    }
  }
  Component.onDestruction: if (worker.processId > 0) worker.signal(9)
}
