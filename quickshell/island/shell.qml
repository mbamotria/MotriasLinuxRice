import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
    id: root

    property bool visibleIsland: true 
    property bool isExpanded: false
    property var currentDate: new Date()

    // Re-added the Ghost Timer to free your mouse, updated to 550ms to accommodate your 500ms animation
    Timer {
        id: hideTimer
        interval: 550 
        running: !visibleIsland
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: false
                right: false
                bottom: false
            }

            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay

            // Wayland ghost-shield fix intact
            implicitWidth: (visibleIsland || hideTimer.running) ? (isExpanded ? 400 : compactRow.implicitWidth + 64) : 0
            implicitHeight: (visibleIsland || hideTimer.running) ? (isExpanded ? 400 : 100) : 0
            color: "transparent"

            Item {
                id: islandContainer
                anchors.horizontalCenter: parent.horizontalCenter
                y: visibleIsland ? 8 : -100 
                
                // Added your bezier curve to the slide-down animation as well!
                Behavior on y { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1] } }

                Rectangle {
                    id: islandPill
                    clip: true 
                    color: "#000000"
                    
                    anchors.horizontalCenter: parent.horizontalCenter

                    width: isExpanded ? 320 : compactRow.implicitWidth + 32
                    height: isExpanded ? 360 : 34 
                    radius: isExpanded ? 24 : 17 

                    // Fixed the array to 4 exact control points so QML doesn't crash
                    Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1] } }
                    Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1] } }
                    // Re-added radius morphing so the pill stays perfectly rounded
                    Behavior on radius { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1] } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            isExpanded = !isExpanded
                            if (isExpanded) {
                                autoHideTimer.stop() 
                            } else {
                                autoHideTimer.restart()
                            }
                        }
                    }

                    // --- COMPACT VIEW ---
                    Item {
                        id: compactWrapper
                        width: compactRow.implicitWidth
                        height: 34
                        anchors.centerIn: parent
                        
                        opacity: isExpanded ? 0 : 1
                        scale: isExpanded ? 0.8 : 1.0 
                        
                        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1] } }
                        Behavior on scale { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1] } }

                        RowLayout {
                            id: compactRow
                            anchors.centerIn: parent
                            spacing: 12
                            
                            Text {
                                text: Qt.formatDateTime(currentDate, "HH:mm")
                                color: "#ffffff"
                                font { pixelSize: 14; bold: true; family: "system-ui" }
                            }
                            
                            Rectangle {
                                width: 1
                                height: 14
                                color: "#333333"
                            }
                            
                            Text {
                                text: Qt.formatDateTime(currentDate, "ddd, MMM d")
                                color: "#a6adc8"
                                font { pixelSize: 14; bold: true; family: "system-ui" }
                            }
                        }
                    }

                    // --- EXPANDED VIEW (Calendar) ---
                    Item {
                        id: expandedWrapper
                        width: 280
                        height: 320
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        
                        opacity: isExpanded ? 1 : 0
                        scale: isExpanded ? 1.0 : 0.95 
                        
                        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0] } }
                        Behavior on scale { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1.0] } }

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 16

                            Text {
                                text: Qt.formatDateTime(currentDate, "MMMM yyyy")
                                color: "#ffffff"
                                font { pixelSize: 18; bold: true; family: "system-ui" }
                                Layout.alignment: Qt.AlignHCenter
                            }

                            DayOfWeekRow {
                                Layout.fillWidth: true
                                delegate: Text {
                                    text: model.shortName
                                    color: "#666666"
                                    font { pixelSize: 12; bold: true; family: "system-ui" }
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            MonthGrid {
                                id: calendarGrid
                                month: currentDate.getMonth()
                                year: currentDate.getFullYear()
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                delegate: Item {
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 28
                                        height: 28
                                        radius: 14
                                        color: "#ffffff"
                                        visible: model.date.getDate() === currentDate.getDate() && 
                                                 model.date.getMonth() === currentDate.getMonth() && 
                                                 model.date.getFullYear() === currentDate.getFullYear()
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.day
                                        font { pixelSize: 14; family: "system-ui" }
                                        color: {
                                            let isToday = (model.date.getDate() === currentDate.getDate() && model.date.getMonth() === currentDate.getMonth() && model.date.getFullYear() === currentDate.getFullYear());
                                            if (isToday) return "#000000";
                                            if (model.isCurrentMonth) return "#ffffff";
                                            return "#444444";
                                        }
                                        font.bold: model.date.getDate() === currentDate.getDate() && model.date.getMonth() === currentDate.getMonth() && model.date.getFullYear() === currentDate.getFullYear()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Timer {
                id: autoHideTimer
                interval: 6500
                running: visibleIsland && !isExpanded
                onTriggered: {
                    visibleIsland = false
                    isExpanded = false
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentDate = new Date()
    }
}