TARGET = harbour-asteroid-pulsar

CONFIG += sailfishapp sailfishapp_i18n sailfishapp_i18n_idbased sailfishapp_i18n_unfinished

SOURCES += src/main.cpp

DISTFILES += qml/harbour-asteroid-pulsar.qml \
    qml/game/*.qml \
    qml/game/qmldir \
    rpm/harbour-asteroid-pulsar.spec \
    harbour-asteroid-pulsar.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# qsTrId() with //% engineering English: the id based build keeps the
# unfinished entries, so the default .qm carries that English.
TRANSLATIONS += translations/harbour-asteroid-pulsar.ts
