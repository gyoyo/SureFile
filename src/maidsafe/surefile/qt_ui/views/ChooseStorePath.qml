import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 400
  property int windowHeight : 150
  property string storeAlias

  id: chooseStorepath
  title: "SureFile"
  flags: Qt.Window
  width: windowWidth
  height: windowHeight
  minimumWidth: windowWidth
  minimumHeight: windowHeight
  maximumWidth: windowWidth
  maximumHeight: windowHeight
  onClosing: apiModel.DeleteAlias(storeAlias)

  StorePathConverter {
    id: storePathConverter
  }

  // Following bugs seem to occur in debug builds(Win-8) very frequently
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32494
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32860
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32558
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32821
  FileDialog {
      id: fileDialog
      selectFolder: true
      onAccepted: storePathConverter.actualStorePath = fileUrl
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 15
    Label {
      text: qsTr("Choose Store Path for: %1").arg(storeAlias)
      font.bold: true
      font.pixelSize: 20
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    }
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Label {
        text: storePathConverter.displayStorePath
        elide: Text.ElideMiddle
        Layout.fillWidth: true
      }
      Button {
        text: qsTr("Change")
        onClicked: {
          // Setting folder uri does not seem to work on Windows-8
          // Might be related to QTBUG-29814
          fileDialog.folder = storePathConverter.actualStorePath
          fileDialog.open()
        }
      }
    }
    GridLayout {
      Layout.alignment: Qt.AlignRight | Qt.AlignBottom
      columns: 3
      Button {
        text: qsTr("OK")
        Layout.column: Qt.platform.os === "windows" ? 0 : 2
        onClicked: {
          chooseStorepath.hide()
          apiModel.SetStorePathForAlias(storeAlias, storePathConverter.displayStorePath)
        }
      }
      Button {
        text: qsTr("Cancel")
        tooltip: qsTr("Cancelling this will remove the folder from your SureFile drive")
        onClicked: {
          chooseStorepath.hide()
          apiModel.DeleteAlias(storeAlias)
        }
      }
    }
  }
}
