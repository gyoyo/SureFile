import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ColumnLayout {
  property string progressMessage
  spacing: 15
  anchors.fill: parent
  //anchors.topMargin: 20

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
  Image {
    id: progressIcon
    source: "../images/loading.png"
    visible: apiModel.operationState == APIModel.Progress
    Layout.alignment: Qt.AlignHCenter
    NumberAnimation on rotation {
      from: 0;
      to: 360;
      running: progressIcon.visible;
      loops: Animation.Infinite;
      duration: 900
    }
  }
  Item {
    Layout.fillHeight: true
  }
}
