import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import SureFile 1.0

RowLayout {
  property string progressMessage
  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.margins: 15
  spacing: 15
  Image {
    id: progressIcon
    source: "../images/loading.png"
    visible: apiModel.operationState == APIModel.Progress
    NumberAnimation on rotation {
       from: 0;
       to: 360;
       running: progressIcon.visible;
       loops: Animation.Infinite;
       duration: 900
    }
  }

  Image {
    visible: apiModel.operationState == APIModel.Error
    source: "../images/error.png"
  }

  Label {
    text: apiModel.operationState == APIModel.Error ? apiModel.errorMessage : progressMessage
    Layout.alignment: Qt.AlignVCenter
  }
}
