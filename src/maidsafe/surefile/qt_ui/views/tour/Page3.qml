import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  property string progressMessage
  spacing: 15
  anchors.fill: parent

  Label {
    id: textLabel
    text: progressMessage
    font.bold: true
    font.pixelSize: 18
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
  }
  Item {
    Layout.preferredHeight: 5
  }
  Label {
    text:qsTr("You will now be asked to create a store path for this folder which is where your encrypted files will be stored.")
    wrapMode: TextEdit.WordWrap
    font.pixelSize: 14
    Layout.maximumWidth: parent.width
    horizontalAlignment: Qt.AlignHCenter
    Layout.alignment: Qt.AlignHCenter
    Layout.fillHeight: true
  }

  Item {
    Layout.preferredHeight: 5
  }
  Image {
    id: tourPicture3
    source: "../../images/tour_picture03.png"
    visible: true
    Layout.alignment: Qt.AlignHCenter
  }

  GridLayout {
    columns: 5
    Layout.alignment: Qt.AlignVCenter
    Label {
      text:qsTr("3 of 5")
      Layout.alignment: Qt.AlignLeft
    }
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 40
    }
    Button {
      text: qsTr("Back")
      Layout.alignment: Qt.AlignRight
    }
    Button {
      text: qsTr("Skip")
      Layout.alignment: Qt.AlignRight
    }
    Button {
      text: qsTr("Next")
      Layout.alignment: Qt.AlignRight
    }
  }
}
