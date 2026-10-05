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
import "."

// Stand-in for IntSelector of org.asteroid.controls: a pill shaped track
// filled to the value, minus and plus buttons at the ends, and a
// horizontal swipe on the track to scrub.
Item {
    id: sel
    property int min: 0
    property int max: 100
    property int stepSize: 10
    property string unitMarker: "%"
    property int value: 0
    property bool valueLabelVisible: true

    function clamp(v) { return Math.max(min, Math.min(max, v)) }

    Rectangle {
        id: track
        anchors.fill: parent
        anchors.leftMargin: Dims.l(4)
        anchors.rightMargin: Dims.l(4)
        radius: height / 2
        color: "#33ffffff"
        Rectangle {
            width: Math.max(parent.height, parent.width * (sel.value - sel.min) / Math.max(1, sel.max - sel.min))
            height: parent.height
            radius: parent.radius
            color: "#55ffffff"
        }
        Label {
            anchors.centerIn: parent
            visible: sel.valueLabelVisible
            text: sel.value + sel.unitMarker
            font.pixelSize: parent.height * 0.42
        }
        MouseArea {
            anchors.fill: parent
            property real pressX: 0
            property int pressValue: 0
            property bool scrubbing: false
            onPressed: { pressX = mouse.x; pressValue = sel.value; scrubbing = false }
            onPositionChanged: {
                var dx = mouse.x - pressX
                if (!scrubbing && Math.abs(dx) > Dims.l(3)) { scrubbing = true; preventStealing = true }
                if (scrubbing) {
                    var range = sel.max - sel.min
                    sel.value = sel.clamp(pressValue + Math.round(dx / width * range))
                }
            }
            onReleased: {
                if (!scrubbing) {
                    if (mouse.x < width * 0.3) sel.value = sel.clamp(sel.value - sel.stepSize)
                    else if (mouse.x > width * 0.7) sel.value = sel.clamp(sel.value + sel.stepSize)
                }
                scrubbing = false
                preventStealing = false
            }
        }
        Icon {
            name: "ios-remove"
            width: parent.height * 0.6; height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: parent.height * 0.25
        }
        Icon {
            name: "ios-add"
            width: parent.height * 0.6; height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: parent.height * 0.25
        }
    }
}
