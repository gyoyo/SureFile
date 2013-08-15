import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.0

Window {
    title: "Surefile"
    width:320
    height:300
    //width: 538 + frame.margins * 2
    //height: 360 + frame.margins * 2
    color: "white"
    minimumWidth: loginButton.implicitWidth+newUser.implicitWidth+tbView.anchors.leftMargin*2

    ColumnLayout {
        //anchors.top: header.bottom
        anchors.fill:  parent
        width:parent.width
        anchors.bottom:  parent.bottom
        anchors.margins: 8
                TableView {
                    id:tbView
                    anchors.topMargin: 10
                    anchors.bottomMargin: 100
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    model: StorePath {}
                    alternatingRowColors: false
                    headerVisible: false
                    //anchors.margins: 12
                    anchors.fill: parent
                    //height: parent.height - 64

                    TableViewColumn {
                        role: "name"
                        title: "Name"
                        width: 120
                    }
                    TableViewColumn {
                        role: "path"
                        title: "Path"
                        width: 220
                    }
                }
                TextField {
                    id:passwordInput
                    text: tbView.implicitWidth+tbView.anchors.leftMargin*2
                    //echoMode: TextInput.Password
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: tbView.width/2
                    anchors.top:tbView.bottom
                    anchors.margins: 10
                }

                Button {
                    id:loginButton
                    text:"Log in"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:passwordInput.bottom
                    anchors.margins: 5
                }

                Button {
                    text:"New User"
                    id:newUser
                    anchors.bottom:parent.bottom
                    anchors.leftMargin: 12
                }
            }
}
