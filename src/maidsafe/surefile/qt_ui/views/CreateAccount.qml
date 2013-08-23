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
      text: qsTr("Create Account")
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
      onTextChanged: mainController.errorMessage = ""
      Layout.alignment: Qt.AlignHCenter
      Layout.minimumWidth: implicitWidth *2
      Binding {
        target: apiModel;
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
      Layout.minimumWidth: implicitWidth *2
      Binding {
        target: apiModel;
        property: "confirmPassword";
        value: confirmPasswordBox.text
      }
      Keys.onReturnPressed: createAccountButton.clicked()
      Keys.onEnterPressed: createAccountButton.clicked()
    }

    Button {
      id: createAccountButton
      text: qsTr("Create Account")
      isDefault: true
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      Layout.alignment: Qt.AlignHCenter
      onClicked: mainController.CreateAccount()
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
