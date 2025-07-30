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

    // Timer para verificar bateria periodicamente
    Timer {
        id: batteryTimer
        interval: 5000 // 5 segundos
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityProcess.running = true
            statusProcess.running = true
        }
    }

    Process {
        id: capacityProcess
        command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
        stdout: SplitParser {
            onRead: data => {
                const capacity = parseInt(data.trim())
                if (!isNaN(capacity)) {
                    const oldLevel = batteryLevel
                    batteryLevel = capacity
                    updatePill()

                    // Mostra pill se mudou
                    if (oldLevel !== batteryLevel && oldLevel >= 0) {
                        pill.show()
                    }
                }
            }
        }
    }

    Process {
        id: statusProcess
        command: ["cat", "/sys/class/power_supply/BAT1/status"]
        stdout: SplitParser {
            onRead: data => {
                batteryStatus = data.trim()
                isCharging = batteryStatus === "Charging"
                updatePill()
            }
        }
    }

    function updatePill() {
        if (batteryLevel >= 0) {
            pill.text = batteryLevel + "%"
            pill.icon = getBatteryIcon(batteryLevel, isCharging)
            pill.iconCircleColor = getBatteryColor(batteryLevel, isCharging)
        }
    }

    function getBatteryIcon(level, charging) {
        if (charging) {
            return "battery_charging_full"
        } else if (level >= 90) {
            return "battery_full"
        } else if (level >= 75) {
            return "battery_6_bar"
        } else if (level >= 60) {
            return "battery_5_bar"
        } else if (level >= 45) {
            return "battery_4_bar"
        } else if (level >= 30) {
            return "battery_3_bar"
        } else if (level >= 15) {
            return "battery_2_bar"
        } else if (level >= 5) {
            return "battery_1_bar"
        } else {
            return "battery_alert"
        }
    }

    function getBatteryColor(level, charging) {
        if (charging) {
            return Theme.accentPrimary
        } else if (level <= 15) {
            return "#ff4444"
        } else if (level <= 30) {
            return "#ffaa00"
        } else {
            return Theme.accentPrimary
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
                pill.show()
                batteryTooltip.tooltipVisible = true
            }
            onExited: {
                pill.hide()
                batteryTooltip.tooltipVisible = false
            }
            cursorShape: Qt.PointingHandCursor
        }
    }
}
