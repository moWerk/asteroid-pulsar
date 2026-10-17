/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import org.nemomobile.systemsettings 1.0
import Nemo.KeepAlive 1.2

Page {
    id: page

    allowedOrientations: Orientation.Portrait

    property int startBrightness: -1

    DisplayBlanking { preventBlanking: app.strobeOn }

    // Full brightness while the app runs, restored when it closes.
    DisplaySettings {
        id: displaySettings
        onBrightnessChanged: {
            if (page.startBrightness !== -1) return
            page.startBrightness = brightness
            brightness = maximumBrightness
        }
    }
    Component.onDestruction: {
        if (startBrightness !== -1)
            displaySettings.brightness = startBrightness
    }

    PageHeader {
        id: header
        //% "Strobe"
        title: qsTrId("id-strobe")
        visible: !app.strobeOn
    }

    Label {
        anchors {
            bottom: button.top
            bottomMargin: Theme.paddingLarge * 4
            horizontalCenter: parent.horizontalCenter
        }
        visible: !app.strobeOn
        text: Math.round(app.hz * 60) + " RPM"
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeHuge
    }

    // Start button. Its glyph blinks at the chosen rate as a preview.
    MouseArea {
        id: button
        property bool highlighted: pressed && containsMouse
        anchors.centerIn: parent
        width: Theme.itemSizeHuge * 1.5
        height: width
        visible: !app.strobeOn
        onClicked: app.strobeOn = true

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.rgba(button.highlighted ? Theme.highlightBackgroundColor
                                                 : Theme.primaryColor,
                              button.highlighted ? Theme.highlightBackgroundOpacity : 0.1)
        }

        HighlightImage {
            anchors.centerIn: parent
            width: Theme.itemSizeHuge
            height: width
            sourceSize { width: width; height: height }
            source: "../images/ios-flash-outline.svg"
            color: Theme.primaryColor
            highlighted: button.highlighted
            opacity: strobeTimer.flashPhase ? 0.2 : 1
        }
    }

    Slider {
        id: slider
        anchors {
            top: button.bottom
            topMargin: Theme.paddingLarge * 4
            left: parent.left
            right: parent.right
        }
        visible: !app.strobeOn
        minimumValue: 1
        maximumValue: 25
        stepSize: 1
        value: app.hz
        valueText: value + " Hz"
        onValueChanged: app.hz = value
    }

    // The strobe itself: the whole screen, black and white.
    Rectangle {
        id: strobe
        anchors.fill: parent
        visible: app.strobeOn
        color: strobeTimer.flashPhase ? "white" : "black"
    }

    Timer {
        id: strobeTimer
        property bool flashPhase: false
        interval: Math.max(20, Math.round(500 / app.hz))
        running: Qt.application.active
        repeat: true
        onTriggered: flashPhase = !flashPhase
    }

    Connections {
        target: app
        onHzChanged: {
            if (slider.value !== app.hz) slider.value = app.hz
            if (!app.strobeOn) return
            hzFeedbackLabel.opacity = 1
            hzHideTimer.restart()
        }
        onStrobeOnChanged: strobeTimer.flashPhase = false
    }

    Label {
        id: hzFeedbackLabel
        anchors.centerIn: parent
        text: app.hz + " Hz"
        font.pixelSize: Theme.fontSizeHuge * 2
        font.bold: true
        color: Theme.highlightColor
        opacity: 0
        visible: app.strobeOn
        Behavior on opacity { FadeAnimation { duration: 150 } }
    }

    Timer {
        id: hzHideTimer
        interval: 800
        onTriggered: hzFeedbackLabel.opacity = 0
    }

    // While strobing: a tap stops, a horizontal drag changes the rate.
    MouseArea {
        anchors.fill: parent
        enabled: app.strobeOn

        property bool tracking:    false
        property bool axisDecided: false
        property real pressX:      0
        property real pressY:      0
        property int  pressHz:     0
        property real threshold:   Theme.startDragDistance

        onPressed: {
            pressX      = mouse.x
            pressY      = mouse.y
            pressHz     = app.hz
            axisDecided = false
            tracking    = false
        }

        onPositionChanged: {
            if (axisDecided) {
                if (!tracking) return
            } else {
                var dx = Math.abs(mouse.x - pressX)
                var dy = Math.abs(mouse.y - pressY)
                if (dx < threshold && dy < threshold) return
                axisDecided = true
                if (dx >= dy) {
                    tracking        = true
                    preventStealing = true
                } else {
                    return
                }
            }
            var delta = Math.round((mouse.x - pressX) / Theme.itemSizeSmall)
            app.hz = Math.max(1, Math.min(25, pressHz + delta)) | 0
        }

        onReleased: {
            if (!tracking) app.strobeOn = false
            tracking        = false
            axisDecided     = false
            preventStealing = false
            hzHideTimer.restart()
        }

        onCanceled: {
            tracking        = false
            axisDecided     = false
            preventStealing = false
            hzHideTimer.restart()
        }
    }
}
