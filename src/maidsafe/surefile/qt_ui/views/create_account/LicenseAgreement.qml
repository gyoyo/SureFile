import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  spacing: 25

  Label {
    text: qsTr("License Agreement")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }
  TextArea {
    id:licenseAgreementText
    text: qsTr("License Agreement blah blah blah")
    wrapMode: TextEdit.WordWrap
    Layout.fillHeight: true
    Layout.fillWidth: true
    width:parent.width
  }
  Label {
    textFormat: Text.RichText
    Layout.maximumWidth: parent.width
    text: qsTr("You must agree to the Terms and Conditions to proceed")
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap
  }
}
