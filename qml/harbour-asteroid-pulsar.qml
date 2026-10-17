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
import "pages"

ApplicationWindow {
    id: app

    property int  hz: 10
    property bool strobeOn: false

    allowedOrientations: Orientation.Portrait

    // A strobe in the background would flash nobody; it stops when the app
    // leaves the screen.
    onApplicationActiveChanged: if (!applicationActive) strobeOn = false

    initialPage: Component { StrobePage { } }

    cover: Component {
        CoverBackground {
            HighlightImage {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -Theme.paddingLarge
                width: Theme.iconSizeLarge
                height: width
                sourceSize { width: width; height: height }
                source: "images/ios-flash-outline.svg"
                color: Theme.primaryColor
            }

            Label {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: Theme.paddingLarge
                    horizontalCenter: parent.horizontalCenter
                }
                text: app.hz + " Hz"
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
        }
    }
}
