import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

RowLayout {
  property string progressMessage

  id: progressItem
  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.margins: 15
  spacing: 15
  Image {
    source: "../images/loading.png"
    visible: progressItem.visible
    NumberAnimation on rotation {
       from: 0;
       to: 360;
       running: progressItem.visible == true;
       loops: Animation.Infinite;
       duration: 900
    }
  }

  Label {
    text: progressMessage
    visible: progressItem.visible
  }
}
