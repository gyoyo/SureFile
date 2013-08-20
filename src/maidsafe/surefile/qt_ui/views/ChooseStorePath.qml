import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

Window {
  property int windowWidth : 400
  property int windowHeight : 150

  title: "SureFile"
  flags: Qt.Window
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight

  StorePathController {
    id: storePathController
  }

  // Following bugs seem to occur in debug builds(Win-8) very frequently
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32494
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32860
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32558
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32821
  FileDialog {
      id: fileDialog
      selectFolder: true
      onAccepted: storePathController.actualStorePath = fileUrl
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 15
    Label {
      text: qsTr("Choose Store Path for: %1").arg(apiModel.storeAlias)
      font.bold: true
      font.pixelSize: 20
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    }
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Label {
        text: storePathController.displayStorePath
        elide: Text.ElideMiddle
        Layout.fillWidth: true
      }
      Button {
        text: qsTr("Change")
        onClicked: {
          // Setting folder uri does not seem to work on Windows-8
          // Might be related to QTBUG-29814
          fileDialog.folder = storePathController.actualStorePath
          fileDialog.open()
        }
      }
    }
    GridLayout {
      Layout.alignment: Qt.AlignRight | Qt.AlignBottom
      columns: 2
      Button {
        text: qsTr("OK")
        Layout.column: Qt.platform.os === "windows" ? 0 : 1
        onClicked: apiModel.SetStorePathForAlias(apiModel.storeAlias, storePathController.displayStorePath)
      }
      Button {
        text: qsTr("Cancel")
        tooltip: qsTr("Cancelling this will remove the folder from your SureFile drive")
        Layout.column: Qt.platform.os === "windows" ? 1 : 0
        onClicked: apiModel.DeleteAlias(apiModel.storeAlias)
      }
    }
  }
}
