import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 350
  property int windowHeight : 450

  id: rootWindow
  title: "SureFile"
  color: "white"
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight

  onClosing: {
    if (mainLoader.item.objectName == "chooseStorePath")
      apiModel.DeleteAlias(mainLoader.item.storeAlias)
  }

  Image {
    id: headerLogo
    source: "qrc:/images/app_header.svg"
    fillMode: Image.PreserveAspectFit
  }

  Loader {
   property int loaderMargin : 30

    id: mainLoader
    anchors.fill: parent
    source: apiModel.CanCreateAccount() ? "CreateAccount.qml" : "Login.qml"
    Connections {
      target: apiModel
      onGetStorePath: {
        mainLoader.source = "ChooseStorePath.qml"
        mainLoader.item.objectName = "chooseStorePath"
        mainLoader.item.storeAlias = storeAlias
        rootWindow.show()
      }
    }
    onItemChanged: {
      mainLoader.item.anchors.leftMargin = loaderMargin
      mainLoader.item.anchors.topMargin = loaderMargin + headerLogo.height
      mainLoader.item.anchors.rightMargin = loaderMargin
      mainLoader.item.anchors.bottomMargin = loaderMargin
    }
  }
}
