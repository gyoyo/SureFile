import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  spacing: 25
  anchors.fill: parent

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
    enabled: apiModel.operationState != APIModel.Progress
    onTextChanged: apiModel.operationState = APIModel.Ready
    Layout.alignment: Qt.AlignHCenter
    Layout.minimumWidth: loginButton.Layout.minimumWidth + 20
    Keys.onReturnPressed: loginButton.clicked()
    Keys.onEnterPressed: loginButton.clicked()
    Binding {
      target: apiModel;
      property: "password";
      value: passwordBox.text
    }
  }

  Button {
    id: loginButton
    text: qsTr("Log In")
    isDefault: true
    enabled: apiModel.operationState != APIModel.Progress
    Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
    Layout.alignment: Qt.AlignHCenter
    onClicked: mainController.Login()
  }

  Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    StatusInfo {
      visible: apiModel.operationState != APIModel.Ready
      progressMessage: qsTr("Logging in")
    }
  }
}
