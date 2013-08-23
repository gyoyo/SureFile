import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0
import "create_account"

ColumnLayout {
  property int spacingUsed : 25
  anchors.fill: parent
  spacing: spacingUsed

  Loader {
    id: createAccountLoader
    Layout.alignment: Qt.AlignHCenter
    Layout.minimumHeight: parent.height - (spacingUsed * 2) - createAccountButton.implicitHeight - statusInfo.heightRequired
    Layout.maximumHeight: parent.height - (spacingUsed * 2) - createAccountButton.implicitHeight - statusInfo.heightRequired
    source: "create_account/LicenseAgreement.qml"
  }

  Button {
    id: createAccountButton
    text: createAccountLoader.item.objectName == "credentialPage" ? qsTr("Create Account") : qsTr("Agree")
    //text: some.height
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
  Item {
    Layout.minimumHeight: statusInfo.heightRequired
    Layout.maximumHeight: statusInfo.heightRequired
    Layout.alignment: Qt.AlignHCenter
    Layout.fillWidth: true
    StatusInfo {
      id: statusInfo
      visible: apiModel.operationState != APIModel.Ready
      progressMessage: qsTr("Creating Account")
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }
}

