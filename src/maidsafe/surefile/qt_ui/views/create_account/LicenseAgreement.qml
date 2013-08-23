import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  anchors.fill: parent
  spacing: 25

  Label {
    text: qsTr("License Agreement")
    verticalAlignment: Text.AlignBottom
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }
  TextArea {
    horizontalAlignment: Text.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    text: qsTr("License Agreement blah blah blah")
    wrapMode: TextEdit.WordWrap
    Layout.fillHeight: true
  }
  Label {
    textFormat: Text.RichText
    text: qsTr("You must agree to the Terms and Conditions to proceed")
    horizontalAlignment: Text.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    wrapMode: Text.Wrap
  }
}
