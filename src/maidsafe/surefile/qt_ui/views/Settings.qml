import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property bool isBusy : false
  property int windowWidth : 350
  property int windowHeight : 450

  id: settingsWindow
  title: "SureFile"
  color: "white"
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight
  onClosing: isBusy ? close.accepted = false : mainLoader.source = "settings/ServiceOptions.qml"

  Image {
    id: headerLogo
    source: "qrc:/images/app_header.svg"
    fillMode: Image.PreserveAspectFit
  }

  Loader {
    property int loaderMargin : 30

    id: mainLoader
    source: "settings/ServiceOptions.qml"
    anchors.fill: parent
    anchors.topMargin: loaderMargin + headerLogo.height
    anchors.bottomMargin: loaderMargin
    anchors.leftMargin: loaderMargin
    anchors.rightMargin: loaderMargin
    Connections {
      target: apiModel
      onShowAddServiceSettings: {
        mainLoader.source = "settings/AddService.qml"
        settingsWindow.show()
      }
      onServiceOperationSuccess: {
        settingsWindow.isBusy = false
        mainLoader.source = "settings/ServiceSuccess.qml"
        mainLoader.item.successMessage = message
      }
    }
  }
}
