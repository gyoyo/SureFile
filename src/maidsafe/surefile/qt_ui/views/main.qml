import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 340
  property int windowHeight : 430

  id: root
  title: "SureFile"
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight

  Loader {
    anchors.fill: parent
    source: apiModel.CanCreateAccount() ? "CreateAccount.qml" : "Login.qml"
  }

  ChooseStorePath {
    visible: apiModel.storeAlias.length > 0
  }
}
