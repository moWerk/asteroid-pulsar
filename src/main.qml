import QtQuick 2.9
import org.asteroid.controls 1.0
import org.nemomobile.systemsettings 1.0
import Nemo.KeepAlive 1.1

Application {
    id: app
    
    centerColor: "#1A0033"
    outerColor:  "#000000"
    
    property bool strobeOn:       false
    property int  startBrightness: -1
    
    onStrobeOnChanged: DisplayBlanking.preventBlanking = strobeOn
    
    Component.onCompleted: DisplayBlanking.preventBlanking = strobeOn
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
