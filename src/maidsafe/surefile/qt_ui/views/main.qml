import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 350
  property int windowHeight : 450
  color: "white"

  Image {
    id: headerLogo
    source: "qrc:/images/app_header.svg"
    fillMode: Image.PreserveAspectFit
  }

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
    anchors.topMargin: headerLogo.height
  }

  ChooseStorePath {
    id: chooseStorepath
    Connections {
      target: apiModel
      onGetStorePath: {
        chooseStorepath.storeAlias = storeAlias
        chooseStorepath.show()
      }
    }
  }
}
