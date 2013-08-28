import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  id: licensePage
  property bool isValid : false
  spacing: 10

  Label {
    text: qsTr("License Agreement")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 20
  }

  Label {
    textFormat: Text.RichText
    text: qsTr("You must read and agree to the <br><a href=\"http://google.com\">SureFile License Agreement</a>.")
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
