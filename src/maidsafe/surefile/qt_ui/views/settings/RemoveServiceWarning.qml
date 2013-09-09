import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  property string folderName : ""

  spacing: 20
  anchors.fill: parent

  Label {
    text: qsTr("You are about to delete")
    Layout.alignment: Qt.AlignHCenter
  }

  Label {
    text: folderName
    Layout.alignment: Qt.AlignHCenter
  }

  Label {
    text: qsTr("All of the data stored in this location will be permanently deleted")
    wrapMode: TextEdit.WordWrap
    Layout.maximumWidth: parent.width
    horizontalAlignment: Qt.AlignHCenter
  }

  Label {
    text: qsTr("Are you sure you want to delete this store path?")
    wrapMode: TextEdit.WordWrap
    Layout.maximumWidth: parent.width
    horizontalAlignment: Qt.AlignHCenter
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    Button {
      text: qsTr("Yes")
      Layout.alignment: Qt.AlignHCenter
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      onClicked: {
        settingsWindow.isBusy = true
        mainLoader.source = "ServiceOptions.qml"
        mainController.RemoveService(folderName)
      }
    }
    Button {
      text: qsTr("No")
      Layout.alignment: Qt.AlignHCenter
      onClicked: {
        mainLoader.source = "ServiceOptions.qml"
      }
    }
  }
}
