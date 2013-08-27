import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
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
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: passwordBox.implicitWidth * 2
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    //hasError: apiModel.operationState == APIModel.Error
    onTextChanged: apiModel.operationState = APIModel.Ready
    Keys.onReturnPressed: loginButton.clicked()
    Keys.onEnterPressed: loginButton.clicked()
    Binding {
      target: apiModel;
      property: "password";
      value: passwordBox.text
    }
  }
  Label {
    text: qsTr("Some Error")
    color: "red"
    visible: apiModel.operationState == APIModel.Error
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 15
  }
  TextField {
    id: passwordBox2
    placeholderText: qsTr("Confirm Password")
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: passwordBox.implicitWidth * 2
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    onTextChanged: apiModel.operationState = APIModel.Ready
    Keys.onReturnPressed: loginButton.clicked()
    Keys.onEnterPressed: loginButton.clicked()
    Binding {
      target: apiModel;
      property: "password";
      value: passwordBox.text
    }
  }
  Label {
    text: qsTr("Some Error")
    color: "red"
    visible: apiModel.operationState == APIModel.Error
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.fillHeight: true
  }
}
