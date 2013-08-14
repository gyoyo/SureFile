import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0

ApplicationWindow {
    id: root
    title: qsTr("SureFile")
    width: 380
    height: 425
    color: "white"

    ColumnLayout {
    TableView {
        model: StorePath {}
        anchors.fill: parent
        //headerVisible: false
        alternatingRowColors: false
        width:380

        TableViewColumn {
            role: "name"
            title: "Name"
            width: 190

        }
        TableViewColumn {
            role: "path"
            title: "Path"
            //width:parent.width /2
            width: 190
        }
    }
        Button {
            text:"New User"
            id:newUser
        }
        TextField {
            id:passwordInput
            echoMode: TextInput.Password
        }
        Button {
            id:loginButton
            text:"Log in"
        }
    }

}
