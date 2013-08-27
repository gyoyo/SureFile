import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0
import "create_account"

Loader {
  anchors.fill: parent
  sourceComponent: apiModel.operationState == APIModel.Progress ? progressView : createAccountView

  Component {
    id: createAccountView

    ColumnLayout {
      anchors.fill: parent
      spacing: 15

      Loader {
        id: createAccountLoader
        Layout.alignment: Qt.AlignHCenter
        Layout.fillHeight: true
        Layout.fillWidth: true
        source: "create_account/Warning.qml"
      }

      Button {
        id: createAccountButton
        text: createAccountLoader.item.objectName == "credentialPage" ? qsTr("Create") : qsTr("Next")
        isDefault: true
        enabled: apiModel.operationState != APIModel.Progress
        Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
        Layout.alignment: Qt.AlignHCenter
        onClicked: {
          if (createAccountLoader.item.objectName == "credentialPage") {
            mainController.CreateAccount()
          } else {
            createAccountLoader.source = "create_account/Credential.qml"
            createAccountLoader.item.objectName = "credentialPage"
          }
        }
      }
    }
  }

  Component {
    id: progressView

    Progress {
      progressMessage: qsTr("Creating Account...")
    }
  }
}




