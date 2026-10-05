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

The `sailfishos` branch is the SailfishOS version, built for Sailfish OS
5.1 on aarch64 and run on a Jolla C2. The strobe is the watch app; the
controls keep the watch proportions across the phone's width, and the
strobe fills the whole screen when it runs.

- The brightness is raised to maximum while the app runs and set back
  when it closes normally, as on the watch. If the app is killed, the
  brightness stays at maximum.
- Install: `devel-su pkcon install-local harbour-asteroid-pulsar-1.0.0-1.aarch64.rpm`
  (aarch64 only).
- Build: `mb2 -t SailfishOS-5.1.0.11-aarch64 build` with the Sailfish
  Platform SDK. SailfishOS is on Qt 5.6; the port uses small stand-ins
  for the AsteroidOS controls and SailfishOS's own display settings.
- Photosensitivity: a strobe at up to 25 Hz on a phone screen is a lot
  brighter than on a watch.

```
Disclosure: LLMGD-2 · origin O0 (LLM-ported overnight; checked through window grabs on one Jolla C2; strobe mode not seen; not used or read by a human; self-graded)
LLMGD: v0.2; assurance=A2; flags=T; origin={O0:.9,O1:.1}; origin_headline=O0; scope=port(code+assets+packaging+docs); graded-by=claude-opus-5-5; retrieval=author-side
```
