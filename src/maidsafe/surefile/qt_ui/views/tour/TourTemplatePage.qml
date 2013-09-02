import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
  property string tourText
  property string tourImageUrl
  spacing: 15
  anchors.fill: parent

  Label {
    text: tourText
    wrapMode: TextEdit.WordWrap
    font.pixelSize: 14
    Layout.maximumWidth: parent.width
    horizontalAlignment: Qt.AlignHCenter
    verticalAlignment: Qt.AlignVCenter
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    Layout.fillHeight: true
    Layout.fillWidth: true
  }

  Image {
    source: tourImageUrl
    Layout.alignment: Qt.AlignHCenter
  }
}
