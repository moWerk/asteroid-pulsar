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
import QtGraphicalEffects 1.0

// Stand-in for Icon of org.asteroid.controls: an ionicon from icons/,
// tinted with `color`.
Item {
    property string name: ""
    property color color: "white"
    Image {
        id: img
        anchors.fill: parent
        source: parent.name ? Qt.resolvedUrl("icons/" + parent.name + ".svg") : ""
        sourceSize.width: width
        sourceSize.height: height
        visible: false
        smooth: true
    }
    ColorOverlay {
        anchors.fill: img
        source: img
        color: parent.color
    }
}
