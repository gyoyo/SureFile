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

  Item {
    Layout.fillHeight: true
  }

  GridLayout {
    columns: 3
    Layout.fillWidth: true

    Label {
      text: "Name"
      Layout.column: 0
    }
    TextField {
      id: aliasBox
      placeholderText: qsTr("Folder Name")
      Layout.column: 1
      Layout.columnSpan: 2
      Layout.fillWidth: true
      onTextChanged: errorMessageLabel.opacity = 0
    }
    Label {
      text: "Path"
      Layout.column: 0
      Layout.row: 1
    }
    Label {
      id: pathField
      text: storePathConverter.displayStorePath
      elide: Text.ElideMiddle
      Layout.column: 1
      Layout.row: 1
      Layout.fillWidth: true
    }
    Button {
      text: qsTr("Edit")
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
      onAddServiceErrorRaised: {
        errorMessageLabel.opacity = 1
        errorMessageLabel.text = errorMessage
      }
    }
  }

  Item {
    Layout.fillHeight: true
  }

  Button {
    text: qsTr("Create")
    Layout.alignment: Qt.AlignHCenter
    onClicked: mainController.AddService(aliasBox.text, storePathConverter.displayStorePath)
  }
}
