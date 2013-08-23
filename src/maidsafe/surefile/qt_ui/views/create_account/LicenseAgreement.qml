import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  anchors.fill: parent
  spacing: 25

  Rectangle {
    color: "red"
    //width:290
    //height:450
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
  }
  Rectangle {
    color: "blue"
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
  }


  Label {
    text: qsTr("License Agreement")
    verticalAlignment: Text.AlignBottom
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }
  TextArea {
    id:licenseAgreementText
    horizontalAlignment: Text.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    text: qsTr("License Agreement blah blah blah")
    wrapMode: TextEdit.WordWrap
    Layout.fillHeight: true

    //Layout.fillWidth: true
  }
  Label {
    textFormat: Text.RichText
    text: qsTr("You must agree to the Terms and Conditions to proceed")
    horizontalAlignment: Text.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    wrapMode: Text.Wrap
    width:licenseAgreementText.width
  }
}
