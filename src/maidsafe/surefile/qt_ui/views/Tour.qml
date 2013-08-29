import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 500
  property int windowHeight : 600

  id: rootWindow
  title: "SureFile"
  color: "white"
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight

  Image {
    id: tourHeaderLogo
    source: "qrc:/images/tour_header.svg"
    fillMode: Image.PreserveAspectFit
  }

  Loader {
    property int loaderMargin : 30

    id: tourLoader
    anchors.fill: parent
    source: "tour/Page1.qml"
    onItemChanged: {
      tourLoader.item.anchors.leftMargin = loaderMargin
      tourLoader.item.anchors.topMargin = loaderMargin + tourHeaderLogo.height + 60
      tourLoader.item.anchors.rightMargin = loaderMargin
      tourLoader.item.anchors.bottomMargin = loaderMargin
    }
  }
}
