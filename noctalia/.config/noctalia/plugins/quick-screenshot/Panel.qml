import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
    id: root

    property var pluginApi: null

    readonly property var geometryPlaceholder: panelContainer
    readonly property bool allowAttach: true

    property real contentPreferredWidth: panelContainer.implicitWidth + Style.marginM * 2
    property real contentPreferredHeight: panelContainer.implicitHeight + Style.marginM * 2

    property var mainInstance: pluginApi?.mainInstance

    property string pendingTarget: ""

    anchors.fill: parent

    Component.onDestruction: {
        if (pendingTarget === "")
            return;
        if (!mainInstance)
            return;
        switch (pendingTarget) {
        case "full":
            mainInstance.runFull();
            break;
        case "region":
            mainInstance.runRegion();
            break;
        case "window":
            mainInstance.runWindow();
            break;
        case "ocr":
            mainInstance.runOcr();
            break;
        }
    }

    function pick(target) {
        root.pendingTarget = target;
        pluginApi.closePanel(pluginApi.panelOpenScreen);
    }

    NBox {
        id: panelContainer
        anchors.centerIn: parent

        implicitWidth: Math.max(titleRow.implicitWidth, buttonColumn.implicitWidth) + Style.marginM * 2
        implicitHeight: mainLayout.implicitHeight + Style.marginM * 2

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: Style.marginM
            spacing: Style.marginM

            RowLayout {
                id: titleRow
                Layout.fillWidth: true
                spacing: Style.marginS

                NIcon {
                    icon: "screenshot"
                    pointSize: Style.fontSizeL
                    color: Color.mPrimary
                }

                NText {
                    text: "Screenshot"
                    pointSize: Style.fontSizeL
                    font.weight: Style.fontWeightBold
                    color: Color.mOnSurface
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
            }

            ColumnLayout {
                id: buttonColumn
                Layout.fillWidth: true
                spacing: Style.marginS

                NButton {
                    icon: "device-desktop"
                    text: "Fullscreen"
                    backgroundColor: Color.mPrimary
                    textColor: Color.mOnPrimary
                    Layout.fillWidth: true
                    onClicked: root.pick("full")
                }
                NButton {
                    icon: "crop"
                    text: "Region"
                    backgroundColor: Color.mPrimary
                    textColor: Color.mOnPrimary
                    Layout.fillWidth: true
                    onClicked: root.pick("region")
                }
                NButton {
                    icon: "window"
                    text: "Window"
                    backgroundColor: Color.mPrimary
                    textColor: Color.mOnPrimary
                    Layout.fillWidth: true
                    onClicked: root.pick("window")
                }
                NButton {
                    icon: "text-recognition"
                    text: "OCR"
                    backgroundColor: Color.mSecondary
                    textColor: Color.mOnSecondary
                    Layout.fillWidth: true
                    onClicked: root.pick("ocr")
                }
            }
        }
    }
}
