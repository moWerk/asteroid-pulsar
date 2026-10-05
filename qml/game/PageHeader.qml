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

// Stand-in for PageHeader of org.asteroid.controls: a title at the top,
// over a dark gradient, below the camera notch of a phone.
Item {
    property alias text: title.text
    height: Dims.l(20)
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.2; color: "#dd000000" }
            GradientStop { position: 0.8; color: "#55000000" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }
    Label {
        id: title
        anchors.fill: parent
        anchors.topMargin: Dims.l(6)
        font.pixelSize: Dims.l(7)
        font.weight: Font.Light
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        maximumLineCount: 2
    }
}
