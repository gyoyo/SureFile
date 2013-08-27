import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  property bool isValid : false
  spacing: 15
  anchors.fill: parent

  Label {
    text: qsTr("Password Warning")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 10
  }

  Label {
    text: qsTr("For security reasons we don’t store your Password. If you forget your password all your data will be lost forever. Please make sure you memorise it.")
    wrapMode: TextEdit.WordWrap
    Layout.maximumWidth: parent.width

  }

  CheckBox {
    id: passwordReminderCheckBox
    text: qsTr("I understand if I forget my Password all <br>my data will be lost.")
    onCheckedChanged: updateIsValid()
    Layout.maximumWidth: parent.width
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.fillHeight: true
  }

  function updateIsValid() {
    isValid = licenseCheckBox.checked && passwordReminderCheckBox.checked
  }
}
