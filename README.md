# asteroid-pulsar

A stroboscope app for [AsteroidOS](http://asteroidos.org/)

Set a flash rate between 1 and 25 Hz, tap the center button to start.
While strobing, drag horizontally anywhere on screen to adjust the rate
on the fly — a large Hz readout confirms the current value.
RPM is shown above the button for anyone using it for mechanical work.

![shot-pulsar](https://github.com/user-attachments/assets/e7b4abed-10e5-41c2-a904-8504d0f182d2)

Drag adjustable Hz on the strobe action screen

![shot-pulsar2](https://github.com/user-attachments/assets/8341398a-d6c6-4edb-b355-7470c1fc5298)

## SailfishOS

Reviewing the code? Start with [review-and-architecture-hints.md](review-and-architecture-hints.md).

The `sailfishos` branch is the SailfishOS version, built for Sailfish OS
5.1 on aarch64 and run on a Jolla C2. Since 1.2.0 the controls are
SailfishOS's own (see below); the strobe fills the whole screen when it runs.

- The brightness is raised to maximum while the app runs and set back
  when it closes normally, as on the watch. If the app is killed, the
  brightness stays at maximum.
- Install: `devel-su pkcon install-local harbour-asteroid-pulsar-1.2.0-1.noarch.rpm`
- Build: `mb2 -t SailfishOS-5.1.0.11-aarch64 build` with the Sailfish
  Platform SDK.
- Photosensitivity: a strobe at up to 25 Hz on a phone screen is a lot
  brighter than on a watch.

```
Disclosure: LLMGD-2 · origin O0 (LLM-ported overnight; checked through window grabs on one Jolla C2; strobe mode not seen; not used or read by the author at the time; self-graded)
LLMGD: v0.2; assurance=A2; flags=T; origin={O0:.9,O1:.1}; origin_headline=O0; scope=port(code+assets+packaging+docs); graded-by=claude-opus-5-5; retrieval=author-side
```

### Pure QML, one package for every phone (1.1.0)

App developer poetaster pointed out in the forum that these ports need no
compiled code. Since 1.1.0 the app is QML only: the system's `sailfish-qml`
launcher runs it, and one `noarch` package serves aarch64, 32 bit ARM and
x86, SailfishOS 3.4 to 5.1. Install with
`devel-su pkcon install-local harbour-asteroid-pulsar-1.1.0-1.noarch.rpm`;
pkcon brings in the launcher (libsailfishapp-launcher) if it is missing.
The package is compressed with xz, because rpm on SailfishOS 3.4 cannot
unpack the zstd that newer SDKs use by default.

The C++ start code only set the app name and held a screenshot test hook; both went.

Checked: installed and started without QML warnings on a Jolla C2 (5.1),
the Jolla Tablet (4.6) and a Jolla 1 (3.4).

```
Disclosure: LLMGD-3 · origin O1 (idea from a forum reply and the author's go; LLM-converted; start-checked by log on three devices; self-graded)
LLMGD: v0.2; assurance=A3; flags=T; origin={O0:.7,O1:.3}; origin_headline=O0; scope=packaging+code; graded-by=claude-opus-5-5; retrieval=author-side
```

### Silica controls (1.2.0)

Forum user nthn pointed out that Silica is more than a transparent theme. Up
to 1.1.0 the app ran the watch interface inside a SailfishOS page, with its
own dark background over the ambience. 1.2.0 is a SailfishOS page: the
ambience shows through, the header, the rate slider, fonts and colours are
Silica's and follow the theme, and the watch controls are gone. The cover
shows the flash glyph and the current rate. The strobe stops when the app
leaves the screen.

Checked: the author used the strobe on a Jolla C2 (5.1) and set the spacing.
Not checked on the Jolla Tablet (4.6) or the Jolla 1 (3.4).

```
Disclosure: LLMGD-3 · origin O0 (prompted by a forum post and the author's direction; LLM-rewritten; spacing set and strobe tested by the author on a Jolla C2; self-graded)
LLMGD: v0.3; assurance=A3; flags=U,T; origin={O0:.6,O1:.4}; origin_headline=O0; scope=code+packaging+docs; graded-by=claude-opus-5-5; retrieval=author-side
```
