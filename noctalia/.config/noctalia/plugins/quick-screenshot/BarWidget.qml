import QtQuick
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

NIconButton {
    id: root

    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    property var pluginApi: null

    readonly property string screenName: screen?.name ?? ""
    readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)

    baseSize: capsuleHeight
    applyUiScale: false
    customRadius: Style.radiusL
    icon: "screenshot"
    tooltipText: "Quick Screenshot"
    tooltipDirection: BarService.getTooltipDirection(screenName)
    colorBg: Style.capsuleColor
    colorFg: Color.mOnSurface
    colorBgHover: Color.mHover
    colorFgHover: Color.mOnHover
    colorBorder: Style.capsuleBorderColor
    colorBorderHover: Style.capsuleBorderColor

    onClicked: {
        if (pluginApi)
            pluginApi.openPanel(root.screen, root);
    }
}
