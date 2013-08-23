import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  property int windowWidth : 350
  property int windowHeight : 450
  property string storeAlias
  color: "white"

  Image {
    id: headerLogo
    source: "qrc:/images/app_header.svg"
    fillMode: Image.PreserveAspectFit
  }

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
    anchors.margins: 30
    anchors.topMargin: headerLogo.height +20
    Label {
      text: qsTr("Choose Store Path...")
      font.bold: true
      font.pixelSize: 18
      Layout.fillWidth: true
      verticalAlignment: Text.AlignTop
      Layout.alignment: Qt.AlignHCenter
      horizontalAlignment: Text.AlignHCenter
    }
    Label {
      text: (storeAlias)
      font.bold: true
      font.pixelSize: 18
      Layout.fillWidth: true
      verticalAlignment: Text.AlignTop
      Layout.alignment: Qt.AlignHCenter
      horizontalAlignment: Text.AlignHCenter
      color: Qt.rgba(0.35,0.59,0.84,1)
    }
    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignTop
      spacing: 20

      Label {
        text: storePathConverter.displayStorePath
        elide: Text.ElideMiddle
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        Layout.alignment: Qt.AlignHCenter
      }
      Button {
        text: qsTr("Edit Path")
        Layout.alignment: Qt.AlignHCenter
        onClicked: {
          // Setting folder uri does not seem to work on Windows-8
          // Might be related to QTBUG-29814
          fileDialog.folder = storePathConverter.actualStorePath
          fileDialog.open()
        }
      }
    }
    RowLayout {
      Layout.alignment: Qt.AlignHCenter
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
        Layout.column: 1
        onClicked: {
          chooseStorepath.hide()
          apiModel.DeleteAlias(storeAlias)
        }
      }
    }
  }
}
