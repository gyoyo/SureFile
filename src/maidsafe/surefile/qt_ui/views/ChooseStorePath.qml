import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  property string storeAlias

  spacing: 10
  anchors.fill: parent
  anchors.topMargin: 20


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

  Label {
    text: qsTr("Choose Store Path...")
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignTop
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }
  Item {
    Layout.preferredHeight: 10
  }
  Label {
    text: (storeAlias)
    verticalAlignment: Text.AlignTop
    horizontalAlignment: Text.AlignHCenter
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
    color: "royalblue"
  }
  Label {
    text: storePathConverter.displayStorePath
    elide: Text.ElideMiddle
    horizontalAlignment: Text.AlignHCenter
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    Layout.minimumWidth: implicitWidth + 20
  }
  Item {
    Layout.preferredHeight: 5
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
  Item {
    Layout.fillHeight: true
  }
  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    Button {
      text: qsTr("OK")
      Layout.column: Qt.platform.os == "windows" ? 0 : 2
      onClicked: {
        rootWindow.hide()
        apiModel.SetStorePathForAlias(storeAlias, storePathConverter.displayStorePath)
      }
    }
    Button {
      text: qsTr("Cancel")
      tooltip: qsTr("Cancelling this will remove the folder from your SureFile drive")
      Layout.column: 1
      onClicked: {
        rootWindow.hide()
        apiModel.DeleteAlias(storeAlias)
      }
    }
  }
}
