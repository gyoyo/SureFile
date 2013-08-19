import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  title: "SureFile"
  minimumWidth: 340
  minimumHeight: 430
  maximumWidth: minimumWidth
  maximumHeight: minimumHeight

  Loader {
    anchors.fill: parent
    source: apiModel.CanCreateAccount() ? "CreateAccount.qml" : "Login.qml"
  }
}
