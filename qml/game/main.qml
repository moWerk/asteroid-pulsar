import QtQuick 2.6
import QtGraphicalEffects 1.0
import org.nemomobile.systemsettings 1.0
import Nemo.KeepAlive 1.2
import "."

// SailfishOS: Application of org.asteroid.utils draws a radial background;
// here a plain Item does the same. DisplaySettings comes from
// org.nemomobile.systemsettings instead of org.asteroid.settings.
Item {
    id: app
    anchors.fill: parent

    property color centerColor: "#1A0033"
    property color outerColor:  "#000000"

    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: app.centerColor }
            GradientStop { position: 0.5; color: app.outerColor }
        }
    }
    
    
    property bool strobeOn:       false
    property int  startBrightness: -1
    DisplayBlanking { preventBlanking: strobeOn }
    
    
    Component.onDestruction: {
        if (startBrightness !== -1)
            displaySettings.brightness = startBrightness
    }
    
    DisplaySettings {
        id: displaySettings
        onBrightnessChanged: {
            if (app.startBrightness !== -1) return
                app.startBrightness = brightness
                brightness = maximumBrightness
        }
    }
    
    StrobePage {
        anchors.fill: parent
    }
}
