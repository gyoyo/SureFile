import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

RowLayout {
  property string errorMessage

  id: errorItem
  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.margins: 15
  spacing: 15
  Image {
    source: "../images/error.png"
    visible: errorItem.visible
  }

  Label {
    text: errorMessage
    visible: errorItem.visible
  }
}
