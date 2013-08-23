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
      text: qsTr("Log In")
      verticalAlignment: Text.AlignBottom
      font.bold: true
      font.pixelSize: 18
      Layout.minimumHeight: implicitHeight
      Layout.alignment: Qt.AlignHCenter
    }

    TextField {
      id: passwordBox
      horizontalAlignment: Text.AlignHCenter
      placeholderText: qsTr("Password")
      echoMode: TextInput.Password
      Layout.alignment: Qt.AlignHCenter
      Binding {
        target: apiModel;
        property: "password";
        value: passwordBox.text
      }
      Layout.minimumWidth: implicitWidth *2
      onTextChanged: mainController.errorMessage = ""
      Keys.onReturnPressed: loginButton.clicked()
      Keys.onEnterPressed: loginButton.clicked()
    }

    Button {
      id: loginButton
      text: qsTr("Log In")
      isDefault: true
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      Layout.alignment: Qt.AlignHCenter
      onClicked: mainController.Login()
    }

    Item {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Progress {
        visible: mainController.isBusy
        progressMessage: qsTr("Logging in...")
      }
      ErrorView {
        visible: mainController.errorMessage.length > 0
        errorMessage: mainController.errorMessage
      }
    }
  }
}
