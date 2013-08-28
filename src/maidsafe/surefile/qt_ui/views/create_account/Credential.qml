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
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: passwordBox.implicitWidth * 1.5
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Component.onCompleted: {
      passwordBox.text = apiModel.password
      passwordBox.textChanged.connect(onTextChangedSlot)
    }
    Component.onDestruction: {
      passwordBox.textChanged.disconnect(onTextChangedSlot)
    }
    function onTextChangedSlot() {
      apiModel.operationState = APIModel.Ready
      apiModel.password = passwordBox.text
    }
  }
  Item {
    Layout.preferredHeight: 5
  }
  TextField {
    id: confirmPasswordBox
    placeholderText: qsTr("Confirm Password")
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    horizontalAlignment: Qt.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: confirmPasswordBox.implicitWidth * 1.5
    Keys.onReturnPressed: createAccountButton.clicked()
    Keys.onEnterPressed: createAccountButton.clicked()
    Component.onCompleted: {
      confirmPasswordBox.text = apiModel.confirmPassword
      confirmPasswordBox.textChanged.connect(onTextChangedSlot)
    }
    Component.onDestruction: {
      confirmPasswordBox.textChanged.disconnect(onTextChangedSlot)
    }
    function onTextChangedSlot() {
      apiModel.operationState = APIModel.Ready
      apiModel.confirmPassword = confirmPasswordBox.text
    }
  }
  Item {
    Layout.preferredHeight: 15
  }
  Label {
    text: apiModel.errorMessage
    color: "crimson"
    horizontalAlignment: Qt.AlignHCenter
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    visible: apiModel.operationState == APIModel.Error
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.fillHeight: true
  }
}
