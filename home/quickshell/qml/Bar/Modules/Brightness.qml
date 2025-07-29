import QtQuick
import Quickshell
import Quickshell.Io
import qs.Settings
import qs.Components

Item {
    id: brightnessDisplay
    property int brightness: -1
    width: pill.width
    height: pill.height

    Process {
        id: brightnessUpProcess
        command: ["brightnessctl", "set", "+2%"]
    }

    Process {
        id: brightnessDownProcess
        command: ["brightnessctl", "set", "2%-"]
    }

    Process {
        id: brightnessGetProcess
        command: ["sh", "-c", "echo $(($(brightnessctl get) * 100 / $(brightnessctl max))) > /tmp/brightness_osd_level"]
    }

    FileView {
        id: brightnessFile
        path: "/tmp/brightness_osd_level"
        watchChanges: true
        blockLoading: true
        onLoaded: updateBrightness()
        onFileChanged: {
            brightnessFile.reload();
            updateBrightness();
        }
        function updateBrightness() {
            const val = parseInt(brightnessFile.text());
            if (!isNaN(val) && val !== brightnessDisplay.brightness) {
                brightnessDisplay.brightness = val;
                pill.text = brightness + "%";
                pill.show();
            }
        }
    }

    PillIndicator {
        id: pill
        icon: "brightness_high"
        text: brightness >= 0 ? brightness + "%" : ""
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary

        StyledTooltip {
            id: brightnessTooltip
            text: "Brightness: " + brightness + "%\nScroll up/down to change brightness"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: brightnessTooltip.tooltipVisible = true
            onExited: brightnessTooltip.tooltipVisible = false
            cursorShape: Qt.PointingHandCursor

            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) {
                    brightnessUpProcess.running = true;
                    // Atualiza o arquivo OSD após mudança
                    Qt.callLater(() => {
                        brightnessGetProcess.running = true;
                    });
                } else if (wheel.angleDelta.y < 0) {
                    brightnessDownProcess.running = true;
                    // Atualiza o arquivo OSD após mudança
                    Qt.callLater(() => {
                        brightnessGetProcess.running = true;
                    });
                }
            }
        }
    }

    Component.onCompleted: {
        // Inicializa o valor do brightness
        brightnessGetProcess.running = true;
        if (brightness >= 0) {
            pill.show();
        }
    }
}
