import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

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
      onTextChanged: apiModel.operationState = APIModel.Ready
      enabled: apiModel.operationState != APIModel.Progress
      Layout.alignment: Qt.AlignHCenter
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
      onTextChanged: apiModel.operationState = APIModel.Ready
      enabled: apiModel.operationState != APIModel.Progress
      Layout.alignment: Qt.AlignHCenter
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
      enabled: apiModel.operationState != APIModel.Progress
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      Layout.alignment: Qt.AlignHCenter
      onClicked: mainController.CreateAccount()
    }

    Item {
      Layout.fillHeight: true
      Layout.fillWidth: true

      StatusInfo {
        visible: apiModel.operationState != APIModel.Ready
        progressMessage: qsTr("Creating Account")
      }
    }
  }
}
