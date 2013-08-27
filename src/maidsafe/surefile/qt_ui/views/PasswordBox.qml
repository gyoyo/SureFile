import QtQuick 2.1
import QtQuick.Controls 1.0

FocusScope {
  property bool hasError : false
  property double borderThickness : 2
  property color borderColor : "red"
  property alias text: internalTextField.text
  property alias echoMode: internalTextField.echoMode
  property alias placeholderText: internalTextField.placeholderText

  implicitHeight: internalTextField.implicitHeight + 2 * borderThickness
  implicitWidth: internalTextField.implicitWidth + 2 * borderThickness

  Rectangle {
    anchors.fill: parent
    visible: hasError
    color: borderColor
  }
  TextField {
    id: internalTextField
    horizontalAlignment: Qt.AlignHCenter
    anchors.fill: parent
    anchors.margins: borderThickness
    onTextChanged: hasError = false
  }
  Image {
    source: "../images/error.png"
    width: 12
    height: 12
    visible: hasError
    anchors {
      right: internalTextField.right
      margins: borderThickness
      verticalCenter: internalTextField.verticalCenter
    }
  }
}
