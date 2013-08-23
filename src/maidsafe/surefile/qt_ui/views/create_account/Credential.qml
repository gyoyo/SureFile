import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  spacing: 25

  Label {
    text: qsTr("Create Account")
    verticalAlignment: Text.AlignBottom
    Layout.alignment: Qt.AlignHCenter
    font.bold: true
    font.pixelSize: 18
  }

  TextField {
    id: passwordBox
    horizontalAlignment: Text.AlignHCenter
    placeholderText: qsTr("Password")
    echoMode: TextInput.Password
    onTextChanged: apiModel.operationState = APIModel.Ready
    enabled: apiModel.operationState != APIModel.Progress
    Layout.alignment: Qt.AlignHCenter
    Layout.minimumWidth: createAccountButton.Layout.minimumWidth + 20
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Binding {
      target: apiModel;
      property: "password";
      value: passwordBox.text
    }
  }

  TextField {
    id: confirmPasswordBox
    horizontalAlignment: Text.AlignHCenter
    placeholderText: qsTr("Confirm Password")
    echoMode: TextInput.Password
    onTextChanged: apiModel.operationState = APIModel.Ready
    enabled: apiModel.operationState != APIModel.Progress
    Layout.alignment: Qt.AlignHCenter
    Layout.minimumWidth: createAccountButton.Layout.minimumWidth + 20
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Binding {
      target: apiModel;
      property: "confirmPassword";
      value: confirmPasswordBox.text
    }
  }
}
