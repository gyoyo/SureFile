import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 500
  property int windowHeight : 600

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
    anchors.fill: parent
    spacing: 15
    anchors.topMargin: tourHeaderLogo.height - 40
    anchors.rightMargin: 30
    anchors.bottomMargin: 30
    anchors.leftMargin: 30

    Loader {
      id: tourLoader
      anchors.fill: parent
      source: "tour/Page1.qml"
      Layout.fillHeight: true
      Layout.fillWidth: true
    }
    RowLayout {
      Label {
        id:pageNumber
        text:qsTr("1 of 5")
        Layout.alignment: Qt.AlignLeft
      }
      Item {
        Layout.fillWidth: true
      }
      Button {
        text: qsTr("Skip")
        Layout.alignment: Qt.AlignRight
      }
      Button {
        text: qsTr("Back")
        Layout.alignment: Qt.AlignRight
      }
      Button {
        text: qsTr("Next")
        Layout.alignment: Qt.AlignRight
        onClicked: incrementValue()
      }
    }
  }
}
