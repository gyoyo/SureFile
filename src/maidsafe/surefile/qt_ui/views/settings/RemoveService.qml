import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  spacing: 20
  anchors.fill: parent

  // Following bugs seem to occur in debug builds(Win-8) very frequently
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32494
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32860
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32558
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32821

  Item {
    Layout.fillHeight: true
  }

  GridLayout {
    columns: 3
    Layout.fillWidth: true

    Label {
      text: "Path: "
      Layout.column: 0
      Layout.row: 1
      font.weight: Font.Bold
    }
    Label {
      id: pathField
      text: storePathConverter.displayStorePath.length == 0 ? "Choose Path" : storePathConverter.displayStorePath
      elide: Text.ElideMiddle
      Layout.column: 1
      Layout.row: 1
      Layout.fillWidth: true
    }
    Button {
      text: qsTr("Choose")
      enabled: !settingsWindow.isBusy
      Layout.column: 2
      Layout.row: 1
      onClicked: {
        // Setting folder uri does not seem to work on Windows-8
        // Might be related to QTBUG-29814
        fileDialog.folder = storePathConverter.actualStorePath
        fileDialog.open()
      }
    }
  }

  Label {
    id: errorMessageLabel
    color: "crimson"
    opacity: 0
    Layout.alignment: Qt.AlignHCenter
    Connections {
      target: apiModel
      onRemoveServiceErrorRaised: {
        settingsWindow.isBusy = false
        errorMessageLabel.opacity = 1
        errorMessageLabel.text = errorMessage
      }
    }
  }

  Image {
    source: "../../images/loading.png"
    opacity: settingsWindow.isBusy ? 1 : 0
    Layout.alignment: Qt.AlignHCenter
    NumberAnimation on rotation {
      from: 0
      to: 360
      running: settingsWindow.isBusy ? 1 : 0
      loops: Animation.Infinite
      duration: 900
    }
  }

  Item {
    Layout.fillHeight: true
  }

  Button {
    text: qsTr("Remove")
    enabled: !settingsWindow.isBusy
    Layout.alignment: Qt.AlignHCenter
    onClicked: {
      settingsWindow.isBusy = true
      //mainController.RemoveService(storePathConverter.displayStorePath)
      mainLoader.source = "settings/AddService.qml"
    }
  }
}
