import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  property bool isValid : false

  id: passwordWarningPage
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
    text: qsTr("For security reasons we don't store your password. If you forget your password all your data will be lost forever.<br/><br/>Please make sure you memorise it.")
    wrapMode: TextEdit.WordWrap
    Layout.maximumWidth: parent.width
    horizontalAlignment: Qt.AlignHCenter
  }

  CheckBox {
    id: passwordWarningCheckBox
    text: qsTr("I understand the Password Warning")
    Layout.maximumWidth: parent.width
    Layout.alignment: Qt.AlignHCenter
    Binding {
      target: passwordWarningPage;
      property: "isValid";
      value: passwordWarningCheckBox.checked
    }
  }

  Item {
    Layout.fillHeight: true
  }
}
