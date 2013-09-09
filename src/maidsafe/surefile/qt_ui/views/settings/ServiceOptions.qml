import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {  
  spacing: 20
  anchors.fill: parent

  StorePathConverter {
    id: storePathConverter
    isRemoveService: true
    Component.onCompleted: storePathConverter.actualStorePath = ""
  }

  // Following bugs seem to occur in debug builds(Win-8) very frequently
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32494
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32860
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32558
  // QtBug: https://bugreports.qt-project.org/browse/QTBUG-32821
  FileDialog {
    id: fileDialog
    selectFolder: true
    onAccepted: {
      errorMessageLabel.opacity = 0
      storePathConverter.actualStorePath = fileUrl
    }
  }
  Label {
    text: "Manage Store Paths"
    font.weight: Font.Bold
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }
  ListModel {
      id: storePathList
      Component.onCompleted: {
          for (var i=0 ; i< 500 ; ++i)
              storePathList.append({"name":"Path name "+i , "path": Math.round(Math.random()*100)})
      }
  }
  TableView {
      model: storePathList
      Layout.fillWidth: true
      Layout.fillHeight: true

      TableViewColumn {
          role: "name"
          title: "Name"
          width: 120
      }
      TableViewColumn {
          role: "path"
          title: "Path"
          width: 120
      }
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    Button {
      text: qsTr("Add")
      Layout.alignment: Qt.AlignHCenter
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      onClicked: mainLoader.source = "AddService.qml"
    }
    Button {
      text: qsTr("Remove")
      enabled: !settingsWindow.isBusy
      Layout.alignment: Qt.AlignHCenter
      onClicked: {
        settingsWindow.isBusy = true
        mainController.RemoveService(storePathConverter.displayStorePath)
      }
    }
  }
}
