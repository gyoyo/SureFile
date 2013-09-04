import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 350
  property int windowHeight : 450

  title: "SureFile"
  color: "white"
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight
  onClosing: mainLoader.source = "settings/ServiceOptions.qml"

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
    onItemChanged: {
      mainLoader.item.anchors.leftMargin = loaderMargin
      mainLoader.item.anchors.topMargin = loaderMargin + headerLogo.height + 20
      mainLoader.item.anchors.rightMargin = loaderMargin
      mainLoader.item.anchors.bottomMargin = loaderMargin
    }
  }
}
