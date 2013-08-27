import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  property bool isValid : false
  spacing: 15

  Label {
    text: qsTr("License Agreement")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 10
  }

  Label {
    textFormat: Text.RichText
    text: qsTr("You must read and agree to the <br><a href=\"http://google.com\">SureFile License Agreement</a>.")
    wrapMode: TextEdit.WordWrap
    onLinkActivated: Qt.openUrlExternally(link)
    horizontalAlignment: Qt.AlignHCenter
    Layout.fillWidth: true
  }

  CheckBox {
    id: licenseCheckBox
    text: qsTr("I agree")
    onCheckedChanged: updateIsValid()
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.fillHeight: true
  }

  function updateIsValid() {
    isValid = licenseCheckBox.checked && passwordReminderCheckBox.checked
  }
}
