import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var pluginApi: null

    readonly property string binDir: Quickshell.env("HOME") + "/.local/bin"

    function run(name) {
        Quickshell.execDetached(["sh", "-c", binDir + "/" + name]);
    }

    function runFull() {
        run("screenshot-fullscreen");
    }
    function runRegion() {
        run("screenshot-region");
    }
    function runWindow() {
        run("screenshot-window");
    }
    function runOcr() {
        run("screenshot-ocr");
    }

    function openMenu() {
        if (!pluginApi)
            return;
        const screens = Quickshell.screens;
        if (!screens || screens.length === 0)
            return;
        pluginApi.openPanel(screens[0], null);
    }

    IpcHandler {
        target: "plugin:quick-screenshot"

        function full() {
            root.runFull();
        }
        function region() {
            root.runRegion();
        }
        function window() {
            root.runWindow();
        }
        function ocr() {
            root.runOcr();
        }
        function menu() {
            root.openMenu();
        }
    }
}
