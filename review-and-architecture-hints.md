# Review and architecture hints: Pulsar for SailfishOS

For anyone reviewing the `sailfishos` branch: where the code comes from, how it is laid out, what is worth reading and what is boilerplate.

## Where the code comes from

The app is the AsteroidOS watch app on `main`. This branch forks from it at `a7b9339`, and its commits are the SailfishOS port. The reliable view of what the port changed:

    git diff a7b9339 sailfishos -- qml src rpm '*.pro' '*.desktop'

Many port edits carry a `SailfishOS:` comment, but not all of them. Each commit message says what changed, why, and what was not checked, and ends with an LLMGD line grading it.

The port was written by an LLM (Claude), directed and tested by the author, who has not read the code. Everything here is a prototype until a reviewer owns it. That is the point of this file.

## Architecture

- `qml/harbour-asteroid-pulsar.qml`: the Silica `ApplicationWindow`. It sizes `Dims` from the screen width, then loads the app (`game/main.qml`). When the app goes to the background, the same item is moved into the cover and scaled down, so the home screen tile shows it live. The same shell is used in all eight ports.
- `qml/game/Dims.qml`, `Label.qml`, `HighlightBar.qml`, `Icon.qml`, `PageHeader.qml`, `ValueCycler.qml`, `IntSelector.qml`, `DeviceSpecs.qml` (whichever exist here): small stand-ins for AsteroidOS's `org.asteroid.controls` and `org.asteroid.utils`, so the watch QML runs unchanged where possible. Each is a few dozen lines.
- `qml/game/main.qml`: the app frame. It raises the display brightness to maximum through `org.nemomobile.systemsettings` and restores it in `Component.onDestruction`.
- `qml/game/StrobePage.qml` (about 200 lines): the strobe timing, the drag-to-adjust frequency (1 to 25 Hz) and the RPM readout.
- Packaging: pure QML, no binary. `Exec=sailfish-qml harbour-asteroid-pulsar` (package `libsailfishapp-launcher`), the `.pro` is `TEMPLATE = aux` with plain `INSTALLS`, and the spec is `BuildArch: noarch` with an xz payload (rpm 4.14 on SailfishOS 3.4 can not unpack the zstd of newer SDKs).

## Read these first

1. `StrobePage.qml`: how the flash timing is driven. A QML `Timer` and the frame rate limit how precise the strobe can be. Check whether the RPM readout claims more precision than the display can deliver.
2. The brightness handling in `main.qml`.

## Skim

Stand-ins, icons, translations, packaging.

## Worth questioning

- The brightness is restored only on a clean exit. If the app is killed, the display stays at maximum.
- The `org.nemomobile.systemsettings` import keeps the app out of the Jolla Store; it is meant for Chum.

## How it was tested

By the author, by playing it on a Jolla C2 (SailfishOS 5.1), the Jolla Tablet (4.6, x86) and a Jolla 1 (3.4, 32-bit ARM), with the same noarch package on all three. Before each handover, the LLM checked builds, package contents and start logs on those devices.

There are no automated tests; the on-device checks are listed in the commit messages.
