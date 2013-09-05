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
    text: apiModel.password
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    horizontalAlignment: Qt.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: passwordBox.implicitWidth * 1.5
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Binding {
      target: apiModel
      property: "password"
      value: passwordBox.text
    }
  }
  Item {
    Layout.preferredHeight: 5
  }
  TextField {
    id: confirmPasswordBox
    placeholderText: qsTr("Confirm Password")
    text: apiModel.confirmPassword
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    horizontalAlignment: Qt.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: confirmPasswordBox.implicitWidth * 1.5
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Binding {
      target: apiModel
      property: "confirmPassword"
      value: confirmPasswordBox.text
    }
  }
  Item {
    Layout.preferredHeight: 15
  }
  Label {
    id: errorMessageLabel
    color: "crimson"
    horizontalAlignment: Qt.AlignHCenter
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    opacity: apiModel.operationState == APIModel.Error ? 1 : 0
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    Connections {
      target: apiModel
      onCreateAccountErrorRaised: {
        errorMessageLabel.text = errorMessage
      }
    }
  }
  Item {
    Layout.fillHeight: true
  }
}
