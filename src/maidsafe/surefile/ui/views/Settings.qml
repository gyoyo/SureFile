import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property bool isBusy : false
  property int windowWidth : 350
  property int windowHeight : 450
  property int leftRightMargin : 30

  onClosing: mainLoader.source = "settings/ServiceOptions.qml"

  id: settingsWindow
  title: "SureFile"
  color: "white"
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: Qt.platform.os == "linux" ? windowHeight + 1 : windowHeight

  Connections {
    target: mainController
    onShowAddServiceSettings: {
      mainLoader.source = "settings/AddService.qml"
    }
  }

  GridLayout {
    rows: 2
    columns: 3

    Image {
      id: headerLogo
      source: "qrc:/images/app_header.svg"
      fillMode: Image.PreserveAspectFit
      Layout.row: 0
      Layout.column: 0
      Layout.columnSpan: 3
    }
    Item {
      Layout.row: 1
      Layout.column: 0
      Layout.fillHeight: true
      Layout.preferredWidth: leftRightMargin
    }

    Loader {
      id: mainLoader
      source: "settings/ServiceOptions.qml"
      Layout.row: 1
      Layout.column: 1
      Layout.fillHeight: true
      Layout.fillWidth: true
      Connections {
        target: apiModel
        onServiceOperationSuccess: {
          settingsWindow.isBusy = false
          mainLoader.source = "settings/ServiceOptions.qml"
        }
      }
    }

    Item {
      Layout.row: 1
      Layout.column: 2
      Layout.fillHeight: true
      Layout.preferredWidth: leftRightMargin
    }
  }
}
