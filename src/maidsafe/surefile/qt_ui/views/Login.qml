import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

Loader {
  anchors.fill: parent
  sourceComponent: apiModel.operationState == APIModel.Progress ? progressView : loginView

  Component {
    id: loginView

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
        echoMode: TextInput.Password
        enabled: apiModel.operationState != APIModel.Progress
        onTextChanged: apiModel.operationState = APIModel.Ready
        Keys.onReturnPressed: loginButton.clicked()
        Keys.onEnterPressed: loginButton.clicked()
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: passwordBox.implicitWidth * 2
        Binding {
          target: apiModel;
          property: "password";
          value: passwordBox.text
        }
      }

      Label {
        text: apiModel.errorMessage
        color: "red"
        visible: apiModel.operationState == APIModel.Error
        Layout.alignment: Qt.AlignHCenter
      }

      Item {
        Layout.fillHeight: true
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
  }

  Component {
    id: progressView

    Progress {
      progressMessage: qsTr("Logging in...")
    }
  }
}
