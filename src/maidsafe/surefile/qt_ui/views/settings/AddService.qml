import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  spacing: 30
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
  Label {
    text: qsTr("Name your Store Path")
    font.weight: Font.Bold
    font.pixelSize: 18
    Layout.alignment: Qt.AlignHCenter
  }

  ColumnLayout {
    spacing: 30
    Layout.fillWidth: true

    TextField {
      id: aliasBox
      placeholderText: qsTr("Name your Store Path")
      onTextChanged: errorMessageLabel.opacity = 0
      horizontalAlignment: Qt.AlignHCenter
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: aliasBox.implicitWidth * 2
    }
    Label {
      id: pathField
      text: storePathConverter.displayStorePath
      elide: Text.ElideMiddle
      Layout.fillWidth: true
      horizontalAlignment: Qt.AlignHCenter
    }
    Button {
      text: qsTr("Change")
      Layout.minimumWidth: implicitWidth > 75 ? implicitWidth + 20 : implicitWidth
      Layout.alignment: Qt.AlignHCenter
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
