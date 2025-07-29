import QtQuick
import Quickshell
import qs.Settings
import qs.Components

Item {
    id: volumeDisplay
    property var shell
    property int volume: 0
    width: pill.width
    height: pill.height

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
            text: "Volume: " + volume + "%\nScroll up/down to change volume"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            propagateComposedEvents: true
            onEntered: {
                pill.show();
                volumeTooltip.tooltipVisible = true;
            }
            onExited: {
                pill.hide();
                volumeTooltip.tooltipVisible = false;
            }
            cursorShape: Qt.PointingHandCursor

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

    Component.onCompleted: {
        if (shell && shell.volume !== undefined) {
            volume = shell.volume;
        }
    }
}
