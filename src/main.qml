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
import Nemo.KeepAlive 1.1

Application {
    id: app

    centerColor: "#1A0033"
    outerColor:  "#000000"

    property bool strobeOn: false
    property int  startBrightness: -1
    property var  displaySettings: null

    onStrobeOnChanged: DisplayBlanking.preventBlanking = strobeOn
    Component.onDestruction: {
        if (displaySettings) displaySettings.brightness = startBrightness
    }

    // Dark rect for frame 1 — matches strobe idle background, costs nothing.
    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    Loader {
        id: appShellLoader
        anchors.fill: parent
        active: false
        source: "AppShell.qml"
    }

    Component.onCompleted: {
        DisplayBlanking.preventBlanking = strobeOn
        appShellLoader.active = true
    }
}
