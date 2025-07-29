import QtQuick
import Quickshell
import Quickshell.Io
import qs.Settings
import qs.Components

Item {
    id: batteryDisplay
    property int batteryLevel: -1
    property string batteryStatus: ""
    property bool isCharging: false
    width: pill.width
    height: pill.height

    FileView {
        id: batteryCapacityFile
        path: "/sys/class/power_supply/BAT1/capacity"
        watchChanges: true
        blockLoading: true
        onLoaded: updateBattery()
        onFileChanged: {
            batteryCapacityFile.reload();
            updateBattery();
        }
    }

    FileView {
        id: batteryStatusFile
        path: "/sys/class/power_supply/BAT1/status"
        watchChanges: true
        blockLoading: true
        onLoaded: updateBattery()
        onFileChanged: {
            batteryStatusFile.reload();
            updateBattery();
        }
    }

    function updateBattery() {
        const capacity = parseInt(batteryCapacityFile.text().trim());
        const status = batteryStatusFile.text().trim();

        if (!isNaN(capacity)) {
            batteryLevel = capacity;
            batteryStatus = status;
            isCharging = status === "Charging";

            pill.text = batteryLevel + "%";
            pill.icon = getBatteryIcon(batteryLevel, isCharging);
            pill.iconCircleColor = getBatteryColor(batteryLevel, isCharging);
            pill.show(); // Mostra quando muda
        }
    }

    function getBatteryIcon(level, charging) {
        if (charging) {
            return "battery_charging_full";
        } else if (level >= 90) {
            return "battery_full";
        } else if (level >= 75) {
            return "battery_6_bar";
        } else if (level >= 60) {
            return "battery_5_bar";
        } else if (level >= 45) {
            return "battery_4_bar";
        } else if (level >= 30) {
            return "battery_3_bar";
        } else if (level >= 15) {
            return "battery_2_bar";
        } else if (level >= 5) {
            return "battery_1_bar";
        } else {
            return "battery_alert";
        }
    }

    function getBatteryColor(level, charging) {
        if (charging) {
            return Theme.accentPrimary;
        } else if (level <= 15) {
            return "#ff4444";
        } else if (level <= 30) {
            return "#ffaa00";
        } else {
            return Theme.accentPrimary;
        }
    }

    PillIndicator {
        id: pill
        icon: "battery_unknown"
        text: batteryLevel >= 0 ? batteryLevel + "%" : ""
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary

        StyledTooltip {
            id: batteryTooltip
            text: "Battery: " + batteryLevel + "%" + (isCharging ? " (Charging)" : " (" + batteryStatus + ")")
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                pill.show();
                batteryTooltip.tooltipVisible = true;
            }
            onExited: {
                pill.hide();
                batteryTooltip.tooltipVisible = false;
            }
            cursorShape: Qt.PointingHandCursor
        }
    }

    Component.onCompleted: {
        updateBattery();
    }
}
