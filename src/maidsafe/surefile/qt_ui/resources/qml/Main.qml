import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import SureFile 1.0

ApplicationWindow {
    id: root
    title: qsTr("SureFile")
    color: "lightblue"
    width: 1200
    minimumWidth: 800
    height: 650
    minimumHeight: 640

    toolBar: ToolBar {
        id: toolbar
        opacity: 0.4
        width: root.width
        height: 27
        ToolButton {
            tooltip: "Help"
            iconSource: "qrc:/icons/about_normal.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 1
            anchors.right: parent.right
            scale:  mouseArea.containsMouse ? 0.8 : 1.0
            smooth: mouseArea.containsMouse
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                onClicked: Qt.quit()
            }
        }
            ToolButton {
                id: login_button
                text: "New User?"
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                onClicked: loader.source = "qrc:/qml/NewUser.qml"
            }
        }
// ##############Pages ########################
    Item {
        id: appRoot
       // Component.onCompleted: loader.source = SureFile.isLoggedIn ? "main_page.qml" : "Login.qml"
        Component.onCompleted: loader.source = "qrc:/qml/Login.qml"
        // content
        Loader {
            id: loader
            focus: true
        }
    }

//#########################################


//    statusBar: StatusBar {
//        id: status
//        height: 12
//        anchors.right: parent.right
//        anchors.left: parent.left
//        anchors.top: parent.top
//            Label {
//                id: statusrow
//                anchors.centerIn: parent
//                text: "Welcome to SureFile"
//                fontSizeMode: Text.Fit
//            }
//    }
}
