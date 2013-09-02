import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 500
  property int windowHeight : 600
  property int pageIndex: 1

  id: tourWindow
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
  ColumnLayout {
    spacing: 20
    anchors.fill: parent
    anchors.topMargin: tourHeaderLogo.height - 40
    anchors.rightMargin: 30
    anchors.bottomMargin: 30
    anchors.leftMargin: 30

    Loader {
      id: tourLoader
      source: ("tour/Page%1.qml").arg(tourWindow.pageIndex)
      Layout.fillHeight: true
      Layout.fillWidth: true
    }
    GridLayout {
      columns: 6
      Label {
        text: qsTr("%1 of 5").arg(tourWindow.pageIndex)
        Layout.alignment: Qt.AlignLeft
        Layout.column: 0
      }
      Item {
        Layout.fillWidth: true
        Layout.column: 1
      }
      Button {
        text: qsTr("Skip")
        enabled: tourWindow.pageIndex != 5
        onClicked: tourWindow.hide();
        Layout.alignment: Qt.AlignRight
        Layout.column: Qt.platform.os == "windows" ? 5 : 2
      }
      Button {
        text: qsTr("Back")
        enabled: tourWindow.pageIndex != 1
        onClicked: tourWindow.pageIndex--
        Layout.alignment: Qt.AlignRight
        Layout.column: 3
      }
      Button {
        text: tourWindow.pageIndex != 5 ? qsTr("Next") : qsTr("Finish")
        isDefault: true
        focus: true
        onClicked: tourWindow.pageIndex == 5 ? tourWindow.hide() : tourWindow.pageIndex++
        Layout.alignment: Qt.AlignRight
        Layout.column: 4
      }
    }
  }
}
