import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  property string successMessage : "Success"
  spacing: 20
  anchors.fill: parent
  Label {
    text: successMessage
    horizontalAlignment: Qt.AlignHCenter
    wrapMode: TextEdit.WordWrap
    font.pixelSize: 18
    font.weight: Font.Bold
    Layout.alignment: Qt.AlignHCenter
    Layout.maximumWidth: parent.width - 40
  }
  Item {
    Layout.fillHeight: true
  }
  Button {
    text: qsTr("Ok")
    Layout.alignment: Qt.AlignHCenter
    onClicked: mainLoader.source = "ServiceOptions.qml"
  }
}
