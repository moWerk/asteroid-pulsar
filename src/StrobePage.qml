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

import QtQuick 2.9
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    id: root
    property int hz: 10

    anchors.fill: parent
    clip: true

    //% "Strobe"
    PageHeader {
        text: qsTrId("id-strobe")
        visible: !app.strobeOn
    }

    Rectangle {
        id: strobeBack
        anchors.centerIn: parent
        width:   Dims.w(40)
        height:  Dims.w(40)
        radius:  width / 2
        color:   "#66444444"
        visible: !app.strobeOn
    }

    Rectangle {
        id: strobeRect
        anchors.centerIn: parent
        color: "#000000"
        width:  app.strobeOn ? root.width  : Dims.w(26)
        height: app.strobeOn ? root.height : Dims.w(26)
        radius: app.strobeOn ? (DeviceSpecs.hasRoundScreen ? width / 2 : 0) : width / 2
        clip: true

        Icon {
            id: strobeIcon
            anchors.centerIn: parent
            visible: !app.strobeOn
            name: "ios-flash-outline"
            width:  parent.width  * 0.95
            height: parent.height * 0.95
            color: "#ffffff"
        }

        MouseArea {
            anchors.fill: parent
            property real pressX: 0
            property real pressY: 0
            onPressed:  { pressX = mouse.x; pressY = mouse.y }
            onReleased: {
                if (Math.abs(mouse.x - pressX) < Dims.l(3) &&
                    Math.abs(mouse.y - pressY) < Dims.l(3))
                    app.strobeOn = !app.strobeOn
            }
        }

        Behavior on width  { SmoothedAnimation { duration: 120; velocity: -1 } }
        Behavior on height { SmoothedAnimation { duration: 120; velocity: -1 } }
        Behavior on radius { SmoothedAnimation { duration: 120; velocity: -1 } }
    }

    Timer {
        id: strobeTimer
        property bool flashPhase: false
        interval: Math.max(20, Math.round(500 / hz))
        running:  true
        repeat:   true
        onTriggered: {
            flashPhase = !flashPhase
            app.strobeOn
            ? strobeRect.color = flashPhase ? "#ffffff" : "#000000"
            : strobeIcon.color = flashPhase ? "#000000" : "#ffffff"
        }
    }

    onHzChanged: {
        if (!app.strobeOn) return
        hzFeedbackLabel.opacity = 1
        hzHideTimer.restart()
    }

    Connections {
        target: app
        function onStrobeOnChanged() {
            if (!app.strobeOn) {
                strobeTimer.flashPhase = false
                strobeRect.color = "#000000"
            }
        }
    }

    Label {
        anchors {
            bottom:           strobeRect.top
            bottomMargin:     Dims.l(8)
            horizontalCenter: parent.horizontalCenter
        }
        visible: !app.strobeOn
        text: Math.round(hz * 60) + " RPM"
        font.pixelSize: Dims.l(8)
    }

    IntSelector {
        anchors {
            top:       strobeRect.bottom
            topMargin: Dims.l(9)
            left:      parent.left
            right:     parent.right
        }
        height: Dims.l(18)
        min:      1
        max:      25
        stepSize: 1
        value:    hz
        unitMarker: " Hz"
        visible:  !app.strobeOn
        onValueChanged: hz = value
    }

    Label {
        id: hzFeedbackLabel
        anchors.centerIn: parent
        text: hz + " Hz"
        font.pixelSize: Dims.l(20)
        font.styleName: "Bold"
        color: "#00A698"
        opacity: 0
        enabled: false
        visible: app.strobeOn
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Timer {
        id: hzHideTimer
        interval: 800
        repeat:   false
        onTriggered: hzFeedbackLabel.opacity = 0
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        propagateComposedEvents: true
        enabled: app.strobeOn

        property bool tracking:    false
        property bool axisDecided: false
        property real pressX:      0
        property real pressY:      0
        property int  pressHz:     0
        property real threshold:   Dims.l(3)

        onPressed: {
            pressX      = mouse.x
            pressY      = mouse.y
            pressHz     = hz
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
                    mouse.accepted = false
                    return
                }
            }
            var delta = Math.round((mouse.x - pressX) / Dims.l(8))
            hz = Math.max(1, Math.min(25, pressHz + delta))
        }

        onReleased: {
            if (!tracking && app.strobeOn) app.strobeOn = false
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
