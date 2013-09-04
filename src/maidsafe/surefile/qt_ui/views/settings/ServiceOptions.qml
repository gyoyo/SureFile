import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {  
  spacing: 20
  anchors.fill: parent

  Item {
    Layout.fillHeight: true
  }
  Label {
    text: "Service Options"
    font.weight: Font.Bold
    font.pixelSize: 24
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.fillHeight: true
  }
  Button {
    text: qsTr("Add")
    Layout.alignment: Qt.AlignHCenter
    onClicked: mainLoader.source = "AddService.qml"
  }
  Button {
    text: qsTr("Rename")
    Layout.alignment: Qt.AlignHCenter
  }
  Button {
    text: qsTr("Remove")
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.fillHeight: true
  }
}
