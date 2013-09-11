import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {  
  spacing: 10
  anchors.fill: parent

  Label {
    text: qsTr("Manage Store Paths")
    font.weight: Font.Bold
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  Item {
    Layout.preferredHeight: 2
  }

  TableView {
    id: serviceTableView
    model: serviceListModel
    enabled: !settingsWindow.isBusy
    Layout.fillWidth: true
    Layout.fillHeight: true

    TableViewColumn {
      role: "name"
      title: qsTr("Name")
      width: 120
    }

    TableViewColumn {
      role: "path"
      title: qsTr("Path")
    }

    onSectionChanged: errorMessageLabel.opacity = 0
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
        errorMessageLabel.text = errorMessage
        errorMessageLabel.opacity = 1
        settingsWindow.show()
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
      running: settingsWindow.isBusy
      loops: Animation.Infinite
      duration: 900
    }
  }

  Item {
    Layout.fillHeight: true
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    Button {
      text: qsTr("Add")
      enabled: !settingsWindow.isBusy
      Layout.alignment: Qt.AlignHCenter
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      onClicked: {
        errorMessageLabel.opacity = 0
        mainLoader.source = "AddService.qml"
      }
    }
    Button {
      text: qsTr("Remove")
      enabled: !settingsWindow.isBusy && serviceTableView.currentRow > -1
      Layout.alignment: Qt.AlignHCenter
      onClicked: {
        errorMessageLabel.opacity = 0
        mainLoader.source = "RemoveServiceWarning.qml"
        mainLoader.item.folderName = serviceListModel.GetName(serviceTableView.currentRow)
      }
    }
  }
}
