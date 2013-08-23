import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
  anchors.fill: parent
  anchors.margins: 30

  ColumnLayout {
    anchors.fill: parent
    spacing: 25

    Label {
      text: qsTr("License Agreement")
      verticalAlignment: Text.AlignBottom
      font.bold: true
      font.pixelSize: 18
      Layout.minimumHeight: implicitHeight
      Layout.alignment: Qt.AlignHCenter
    }
    TextArea {
      id: licenseAgreement
      horizontalAlignment: Text.AlignHCenter
      Layout.alignment: Qt.AlignHCenter
      frameVisible: frameCheckbox.checked
      text: qsTr("License Agreement blah blah blah")
      wrapMode: wrapCheck.checked ? TextEdit.WordWrap : TextEdit.NoWrap
      Layout.fillWidth: true
    }
    Label {
      textFormat: Text.RichText
      text: qsTr("You must agree to the <br>Terms and Conditions to proceed")
      horizontalAlignment: Text.AlignHCenter
      Layout.alignment: Qt.AlignHCenter
      width:parent.width
      wrapMode: Text.Wrap
      Layout.fillWidth: true
    }
    Button {
      id: createAccountButton
      text: qsTr("Agree")
      isDefault: true
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      Layout.alignment: Qt.AlignHCenter
    }
    Item {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Progress {
        visible: mainController.isBusy
        progressMessage: qsTr("Creating Account...")
      }
      ErrorView {
        visible: mainController.errorMessage.length > 0
        errorMessage: mainController.errorMessage
      }
    }
  }
}
