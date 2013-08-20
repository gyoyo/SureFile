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

  FileDialog {
      id: fileDialog
      selectFolder: true
      onAccepted: storePathController.actualStorePath = fileUrl
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 15
    Label {
      text: qsTr("Choose Store Path for: %1").arg(Qt.platform.os)
      font.bold: true
      font.pixelSize: 20
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    }
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Label {
        id: chosenPath
        text: storePathController.displayStorePath
        elide: Text.ElideMiddle
        Layout.fillWidth: true
      }
      Button {
        text: qsTr("Change")
        onClicked: {
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
      }
      Button {
        text: qsTr("Cancel")
        Layout.column: Qt.platform.os === "windows" ? 1 : 0
      }
    }
  }
}
