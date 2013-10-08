import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  id: licensePage
  property bool isValid : false
  spacing: 10
  Component.onCompleted: titleLabel.forceActiveFocus()

  Label {
    id: titleLabel
    text: qsTr("License Agreement")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
    Keys.onEnterPressed: createAccountButton.clicked()
    Keys.onReturnPressed: createAccountButton.clicked()
  }

  Item {
    Layout.preferredHeight: 20
  }

  Label {
    textFormat: Text.RichText
    text: qsTr("You must read and agree to the <br><a href=\"http://maidsafe.net/licenses/SureFile-EULA.txt\">SureFile License Agreement</a>.")
    wrapMode: TextEdit.WordWrap
    onLinkActivated: Qt.openUrlExternally(link)
    horizontalAlignment: Qt.AlignHCenter
    Layout.fillWidth: true
  }

  Item {
    Layout.preferredHeight: 10
  }

  CheckBox {
    id: licenseCheckBox
    text: qsTr("I agree")
    Layout.alignment: Qt.AlignHCenter
    Keys.onEnterPressed: createAccountButton.clicked()
    Keys.onReturnPressed: createAccountButton.clicked()
    Binding {
      target: licensePage;
      property: "isValid";
      value: licenseCheckBox.checked
    }
  }

  Item {
    Layout.fillHeight: true
  }
}
