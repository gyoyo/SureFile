import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
  anchors.fill: parent
  anchors.margins: 15

  ColumnLayout {
    anchors.fill: parent
    spacing: 25

    Label {
      text: qsTr("Create Account")
      verticalAlignment: Text.AlignVCenter
      font.bold: true
      font.pixelSize: 24
      Layout.minimumHeight: implicitHeight + 100
      Layout.alignment: Qt.AlignHCenter      
    }

    TextField {
      id: passwordBox
      horizontalAlignment: Text.AlignHCenter
      placeholderText: qsTr("Password")
      echoMode: TextInput.Password
      Layout.alignment: Qt.AlignHCenter
      onTextChanged: mainController.errorMessage = ""
      Binding {
        target: mainController;
        property: "password";
        value: passwordBox.text
      }
      Keys.onReturnPressed: createAccountButton.clicked()
      Keys.onEnterPressed: createAccountButton.clicked()
    }

    TextField {
      id: confirmPasswordBox
      horizontalAlignment: Text.AlignHCenter
      placeholderText: qsTr("Confirm Password")
      echoMode: TextInput.Password
      onTextChanged: mainController.errorMessage = ""
      Layout.alignment: Qt.AlignHCenter
      Keys.onReturnPressed: createAccountButton.clicked()
      Keys.onEnterPressed: createAccountButton.clicked()
    }

    Button {
      id: createAccountButton
      text: qsTr("Create Account")
      isDefault: true
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      Layout.alignment: Qt.AlignHCenter
      onClicked: {
        if (passwordBox.text == confirmPasswordBox.text) {
          mainController.CreateAccount()
        } else {
          mainController.errorMessage = qsTr("Entries do not match")
        }
      }
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
