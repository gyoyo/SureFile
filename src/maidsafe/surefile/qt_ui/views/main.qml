import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.0
import SureFile 1.0

ApplicationWindow {
  title: qsTr("SureFile")

  ColumnLayout {
    TextField {
      text: "Hello"
      onTextChanged: passwordHandler.Test()
    }
  }
}
