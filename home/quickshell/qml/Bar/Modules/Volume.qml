import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.Settings
import qs.Components

Item {
    id: volumeDisplay
    property var shell
    property int volume: 0
    property bool isHovered: false
    width: pill.width
    height: pill.height

    // Bind all Pipewire nodes so their properties are valid
    PwObjectTracker {
        id: nodeTracker
        objects: Pipewire.nodes
    }

    PillIndicator {
        id: pill
        icon: volume === 0 ? "volume_off" : (volume < 30 ? "volume_down" : "volume_up")
        text: volume + "%"
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary

        StyledTooltip {
            id: volumeTooltip
            text: "Volume: " + volume + "%\nScroll up/down to change volume\nClick to select audio devices"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            propagateComposedEvents: true
            onEntered: {
                isHovered = true;
                pill.show();
                volumeTooltip.tooltipVisible = true;
            }
            onExited: {
                isHovered = false;
                if (!audioSelector.visible) {
                    pill.hide();
                    volumeTooltip.tooltipVisible = false;
                }
            }
            cursorShape: Qt.PointingHandCursor

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    if (audioSelector.visible) {
                        audioSelector.dismiss();
                    } else {
                        audioSelector.show();
                        audioSelector.anchorItem = pill;
                    }
                }
            }

            onWheel: wheel => {
                if (!shell)
                    return;
                let step = 5;
                if (wheel.angleDelta.y > 0) {
                    shell.updateVolume(Math.min(100, shell.volume + step));
                } else if (wheel.angleDelta.y < 0) {
                    shell.updateVolume(Math.max(0, shell.volume - step));
                }
            }
        }
    }

    // Audio Device Selector Panel
    PanelWithOverlay {
        id: audioSelector
        visible: false
        property int tabIndex: 0
        property Item anchorItem: null

        Rectangle {
            color: Theme.backgroundPrimary
            radius: 20
            width: 340
            height: 340
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 4
            anchors.rightMargin: 4

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                // Tabs centered inside the window
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0
                    
                    Tabs {
                        id: ioTabs
                        tabsModel: [
                            { label: "Output", icon: "volume_up" },
                            { label: "Input", icon: "mic" }
                        ]
                        currentIndex: audioSelector.tabIndex
                        onTabChanged: {
                            audioSelector.tabIndex = currentIndex;
                        }
                    }
                }

                // Add vertical space between tabs and entries
                Item { height: 36; Layout.fillWidth: true }

                // Output Devices
                Flickable {
                    id: sinkList
                    visible: audioSelector.tabIndex === 0
                    contentHeight: sinkColumn.height
                    clip: true
                    interactive: contentHeight > height
                    width: parent.width
                    height: 220
                    ScrollBar.vertical: ScrollBar {}
                    ColumnLayout {
                        id: sinkColumn
                        width: sinkList.width
                        spacing: 6
                        Repeater {
                            model: volumeDisplay.sinkNodes()
                            Rectangle {
                                width: parent.width
                                height: 36
                                color: "transparent"
                                radius: 6
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 8
                                    Text {
                                        text: "volume_up"
                                        font.family: "Material Symbols Outlined"
                                        font.pixelSize: 16
                                        color: (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.id === modelData.id) ? Theme.accentPrimary : Theme.textPrimary
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1
                                        Layout.maximumWidth: sinkList.width - 120
                                        Text {
                                            text: modelData.nickname || modelData.description || modelData.name
                                            font.bold: true
                                            font.pixelSize: 12
                                            color: (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.id === modelData.id) ? Theme.accentPrimary : Theme.textPrimary
                                            elide: Text.ElideRight
                                            maximumLineCount: 1
                                            Layout.fillWidth: true
                                        }
                                        Text {
                                            text: modelData.description !== modelData.nickname ? modelData.description : ""
                                            font.pixelSize: 10
                                            color: Theme.textSecondary
                                            elide: Text.ElideRight
                                            maximumLineCount: 1
                                            Layout.fillWidth: true
                                        }
                                    }
                                    Rectangle {
                                        visible: Pipewire.preferredDefaultAudioSink !== modelData
                                        width: 60; height: 20
                                        radius: 4
                                        color: Theme.accentPrimary
                                        border.color: Theme.accentPrimary
                                        border.width: 1
                                        Layout.alignment: Qt.AlignVCenter
                                        Text {
                                            anchors.centerIn: parent
                                            text: "Set"
                                            color: Theme.onAccent
                                            font.pixelSize: 10
                                            font.bold: true
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: Pipewire.preferredDefaultAudioSink = modelData
                                        }
                                    }
                                    Text {
                                        text: "(Current)"
                                        visible: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.id === modelData.id
                                        color: Theme.accentPrimary
                                        font.pixelSize: 10
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }

                // Input Devices
                Flickable {
                    id: sourceList
                    visible: audioSelector.tabIndex === 1
                    contentHeight: sourceColumn.height
                    clip: true
                    interactive: contentHeight > height
                    width: parent.width
                    height: 220
                    ScrollBar.vertical: ScrollBar {}
                    ColumnLayout {
                        id: sourceColumn
                        width: sourceList.width
                        spacing: 6
                        Repeater {
                            model: volumeDisplay.sourceNodes()
                            Rectangle {
                                width: parent.width
                                height: 36
                                color: "transparent"
                                radius: 6
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 8
                                    Text {
                                        text: "mic"
                                        font.family: "Material Symbols Outlined"
                                        font.pixelSize: 16
                                        color: (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.id === modelData.id) ? Theme.accentPrimary : Theme.textPrimary
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1
                                        Layout.maximumWidth: sourceList.width - 120
                                        Text {
                                            text: modelData.nickname || modelData.description || modelData.name
                                            font.bold: true
                                            font.pixelSize: 12
                                            color: (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.id === modelData.id) ? Theme.accentPrimary : Theme.textPrimary
                                            elide: Text.ElideRight
                                            maximumLineCount: 1
                                            Layout.fillWidth: true
                                        }
                                        Text {
                                            text: modelData.description !== modelData.nickname ? modelData.description : ""
                                            font.pixelSize: 10
                                            color: Theme.textSecondary
                                            elide: Text.ElideRight
                                            maximumLineCount: 1
                                            Layout.fillWidth: true
                                        }
                                    }
                                    Rectangle {
                                        visible: Pipewire.preferredDefaultAudioSource !== modelData
                                        width: 60; height: 20
                                        radius: 4
                                        color: Theme.accentPrimary
                                        border.color: Theme.accentPrimary
                                        border.width: 1
                                        Layout.alignment: Qt.AlignVCenter
                                        Text {
                                            anchors.centerIn: parent
                                            text: "Set"
                                            color: Theme.onAccent
                                            font.pixelSize: 10
                                            font.bold: true
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: Pipewire.preferredDefaultAudioSource = modelData
                                        }
                                    }
                                    Text {
                                        text: "(Current)"
                                        visible: Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.id === modelData.id
                                        color: Theme.accentPrimary
                                        font.pixelSize: 10
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        onVisibleChanged: {
            if (!visible) {
                // Reset tooltip when panel closes
                volumeTooltip.tooltipVisible = false;
                // Also hide the pill if we're not hovering
                if (!isHovered) {
                    pill.hide();
                }
            }
        }
    }

    // Helper functions for device filtering
    function sinkNodes() {
        let nodes = Pipewire.nodes && Pipewire.nodes.values
            ? Pipewire.nodes.values.filter(function(n) {
                return n.isSink && n.audio && n.isStream === false;
            })
            : [];
        if (Pipewire.defaultAudioSink) {
            nodes = nodes.slice().sort(function(a, b) {
                if (a.id === Pipewire.defaultAudioSink.id) return -1;
                if (b.id === Pipewire.defaultAudioSink.id) return 1;
                return 0;
            });
        }
        return nodes;
    }

    function sourceNodes() {
        let nodes = Pipewire.nodes && Pipewire.nodes.values
            ? Pipewire.nodes.values.filter(function(n) {
                return !n.isSink && n.audio && n.isStream === false;
            })
            : [];
        if (Pipewire.defaultAudioSource) {
            nodes = nodes.slice().sort(function(a, b) {
                if (a.id === Pipewire.defaultAudioSource.id) return -1;
                if (b.id === Pipewire.defaultAudioSource.id) return 1;
                return 0;
            });
        }
        return nodes;
    }

    // Original volume connections
    Connections {
        target: shell ?? null
        function onVolumeChanged() {
            if (shell && shell.volume !== volume) {
                volume = shell.volume;
                pill.text = volume + "%";
                pill.icon = volume === 0 ? "volume_off" : (volume < 30 ? "volume_down" : "volume_up");
                pill.show(); // Mostra quando muda
            }
        }
    }

    // Pipewire connections for device changes
    Connections {
        target: Pipewire
        function onReadyChanged() {
            if (Pipewire.ready && Pipewire.nodes && Pipewire.nodes.values) {
                // Refresh device lists when Pipewire is ready
            }
        }
        function onDefaultAudioSinkChanged() {
            // Update UI when default sink changes
        }
        function onDefaultAudioSourceChanged() {
            // Update UI when default source changes
        }
    }

    Component.onCompleted: {
        if (shell && shell.volume !== undefined) {
            volume = shell.volume;
        }
        // Initialize Pipewire nodes if available
        if (Pipewire.nodes && Pipewire.nodes.values) {
            for (var i = 0; i < Pipewire.nodes.values.length; ++i) {
                var n = Pipewire.nodes.values[i];
            }
        }
    }
}
