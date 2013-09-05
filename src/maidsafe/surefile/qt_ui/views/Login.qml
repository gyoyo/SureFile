import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  spacing: 15
  anchors.fill: parent

  Label {
    text: qsTr("Log In")
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 10
  }

  TextField {
    id: passwordBox
    placeholderText: qsTr("Password")
    text: apiModel.password
    echoMode: TextInput.Password
    enabled: apiModel.operationState != APIModel.Progress
    horizontalAlignment: Qt.AlignHCenter
    Keys.onReturnPressed: loginButton.clicked()
    Keys.onEnterPressed: loginButton.clicked()
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: passwordBox.implicitWidth * 1.5
    Binding {
      target: apiModel
      property: "password"
      value: passwordBox.text
    }
  }

  Label {
    id: errorMessageLabel
    color: "crimson"
    opacity: apiModel.operationState == APIModel.Error ? 1 : 0
    Layout.alignment: Qt.AlignHCenter
    Connections {
      target: apiModel
      onLoginErrorRaised: {
        errorMessageLabel.text = errorMessage
      }
    }
  }

  Item {
    Layout.fillHeight: true
  }

  Image {
    source: "../images/loading.png"
    opacity: apiModel.operationState == APIModel.Progress ? 1 : 0
    Layout.alignment: Qt.AlignHCenter
    NumberAnimation on rotation {
      from: 0
      to: 360
      running: apiModel.operationState == APIModel.Progress
      loops: Animation.Infinite
      duration: 900
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
}
