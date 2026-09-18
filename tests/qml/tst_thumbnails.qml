import QtQuick
import QtTest
import "../.." as Plugin

TestCase {
  id: testCase
  name: "ThumbnailLifecycle"
  when: windowShown
  Component { id: loaderComponent; Plugin.ThumbnailLoader {} }

  function row(id) {
    return { id: id, previewThumbnail: "https://plugins.omarchy.org/assets/img/plugins/" + id + ".webp" }
  }
  function loader() {
    return createTemporaryObject(loaderComponent, testCase, {
      helperPath: "/fictional/helper.py", revision: "one", rows: [row("one")]
    })
  }
  function complete(object, order) {
    var worker = findChild(object, "thumbnailWorker")
    var collector = findChild(object, "thumbnailCollector")
    var images = {}
    for (var i = 0; i < object.activeRows.length; i++) {
      var active = object.activeRows[i]
      images[active.id] = { url: active.url, localSource: "file:///fictional/" + active.id + ".webp" }
    }
    collector.text = JSON.stringify({ ok: true, action: "thumbnails", generation: object.activeGeneration,
      thumbnails: images })
    worker.running = false
    if (order === "exit-first") worker.exited(0, 0)
    collector.streamFinished()
    if (order !== "exit-first") worker.exited(0, 0)
  }
  function test_success_and_bounded_batch() {
    var object = loader()
    var rows = []
    for (var i = 0; i < 30; i++) rows.push(row("plugin" + i))
    object.rows = rows
    tryCompare(object, "active", true)
    compare(object.activeRows.length, 12)
    findChild(object, "thumbnailWorker").started()
    complete(object, "exit-first")
    compare(Object.keys(object.images).length, 12)
    tryCompare(object, "active", true)
    compare(object.activeRows[0].id, "plugin12")
  }
  function test_switch_rejects_old_response_and_starts_latest() {
    var object = loader()
    tryCompare(object, "active", true)
    object.rows = [row("two")]
    object.rows = [row("three")]
    verify(object.cancelled)
    complete(object, "stream-first")
    compare(Object.keys(object.images).length, 0)
    tryCompare(object, "active", true)
    compare(object.activeRows[0].id, "three")
    complete(object, "exit-first")
    verify(Boolean(object.images.three))
    verify(!object.images.one)
  }
  function test_disable_before_start_prevents_input_and_restarts_on_enable() {
    var object = loader()
    tryCompare(object, "active", true)
    object.enabled = false
    var worker = findChild(object, "thumbnailWorker")
    worker.started()
    compare(worker.written, "")
    complete(object, "exit-first")
    compare(Object.keys(object.images).length, 0)
    wait(220)
    compare(object.active, false)
    object.enabled = true
    tryCompare(object, "active", true)
  }
  function test_revision_change_rejects_old_image() {
    var object = loader()
    tryCompare(object, "active", true)
    object.revision = "two"
    complete(object, "stream-first")
    compare(Object.keys(object.images).length, 0)
    tryCompare(object, "active", true)
    complete(object, "stream-first")
    compare(object.images.one.revision, "two")
  }
  function test_failed_result_backs_off_without_blocking_new_rows() {
    var object = loader()
    tryCompare(object, "active", true)
    var worker = findChild(object, "thumbnailWorker")
    var collector = findChild(object, "thumbnailCollector")
    collector.text = "invalid output"
    collector.streamFinished()
    worker.running = false
    worker.exited(1, 0)
    wait(250)
    compare(object.active, false)
    verify(object.attempts.one > Date.now())
    object.rows = [row("two")]
    tryCompare(object, "active", true)
    compare(object.activeRows[0].id, "two")
  }
}
