import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  property bool isValid : true
  spacing: 10
  Label {
    text: qsTr("Create Account")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.preferredHeight: 15
  }
  TextField {
    id: passwordBox
    placeholderText: qsTr("Password")
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    horizontalAlignment: Qt.AlignHCenter
    onTextChanged: apiModel.operationState = APIModel.Ready
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: passwordBox.implicitWidth * 2
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Binding {
      target: apiModel;
      property: "password";
      value: passwordBox.text
    }
  }
  Label {
    text: apiModel.errorMessage
    color: "red"
    opacity: apiModel.operationState == APIModel.Error ? 1 : 0
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 15
  }
  TextField {
    id: confirmPasswordBox
    placeholderText: qsTr("Confirm Password")
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    horizontalAlignment: Qt.AlignHCenter
    onTextChanged: apiModel.operationState = APIModel.Ready
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: confirmPasswordBox.implicitWidth * 2
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Binding {
      target: apiModel;
      property: "confirmPassword";
      value: confirmPasswordBox.text
    }
  }
  Label {
    text: apiModel.errorMessage
    color: "red"
    opacity: apiModel.operationState == APIModel.Error
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.fillHeight: true
  }
}
