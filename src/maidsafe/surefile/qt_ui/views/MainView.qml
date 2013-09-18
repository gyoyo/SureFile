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

  Image {
    id: headerLogo
    source: "qrc:/images/app_header.svg"
    fillMode: Image.PreserveAspectFit
  }

  Loader {
    property int loaderMargin : 30

    id: mainLoader
    anchors.fill: parent
    anchors.topMargin: loaderMargin + headerLogo.height + 20
    anchors.bottomMargin: loaderMargin
    anchors.leftMargin: loaderMargin
    anchors.rightMargin: loaderMargin
    source: apiModel.CanCreateAccount() ? "CreateAccount.qml" : "Login.qml"
  }
}
