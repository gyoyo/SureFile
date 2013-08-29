import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0
import "create_account"

ColumnLayout {
  anchors.fill: parent
  spacing: 15

  Loader {
    id: createAccountLoader
    Layout.alignment: Qt.AlignHCenter
    Layout.fillHeight: true
    Layout.fillWidth: true
    Component.onCompleted: {
      if (apiModel.operationState == APIModel.Error) {
        createAccountLoader.source = "create_account/Credential.qml"
        createAccountLoader.item.objectName = "credentialPage"
      } else {
        createAccountLoader.source = "create_account/LicenseAgreement.qml"
      }
    }
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
    id: createAccountButton
    text: createAccountLoader.item.objectName == "credentialPage" ? qsTr("Create") : qsTr("Next")
    isDefault: true
    visible: createAccountLoader.item.isValid
    enabled: apiModel.operationState != APIModel.Progress
    Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
    Layout.alignment: Qt.AlignHCenter
    onClicked: {
      if (createAccountLoader.item.objectName == "credentialPage") {
        mainController.CreateAccount()
      } else if (createAccountLoader.item.objectName == "passwordWarningPage") {
        createAccountLoader.source = "create_account/Credential.qml"
        createAccountLoader.item.objectName = "credentialPage"
      } else {
        createAccountLoader.source = "create_account/PasswordWarning.qml"
        createAccountLoader.item.objectName = "passwordWarningPage"
      }
    }
  }
}



