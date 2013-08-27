import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  property bool isValid : false
  spacing: 15

  Label {
    text: qsTr("Important!!!")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 10
  }

  Label {
    text: qsTr("If you forget your password, you're done!!!")
    wrapMode: TextEdit.WordWrap
  }

  CheckBox {
    id: passwordReminderCheckBox
    text: qsTr("I agree to remember my password.")
    onCheckedChanged: UpdateIsValid()
  }

  Item {
    Layout.preferredHeight: 10
  }

  Label {
    textFormat: Text.RichText
    text: qsTr("Please read and understand the <a href=\"http://google.com\">MaidSafe License Agreement</a>.")
    wrapMode: TextEdit.WordWrap
    onLinkActivated: Qt.openUrlExternally(link)
  }

  CheckBox {
    id: licenseCheckBox
    text: qsTr("I agree to MaidSafe License Agreement.")
    onCheckedChanged: UpdateIsValid()
  }

  Item {
    Layout.fillHeight: true
  }

  function UpdateIsValid() {
    isValid = licenseCheckBox.checked && passwordReminderCheckBox.checked
  }
}
