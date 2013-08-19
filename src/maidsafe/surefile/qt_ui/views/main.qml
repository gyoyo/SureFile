import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
  title: qsTr("Some App")
  ColumnLayout {
    Rectangle {
      color: "Blue"
      width: 50
      height: 50
      focus: true
      Keys.priority: Keys.BeforeItem
      Keys.onPressed: res.text = res.text == "" ? "Rect" : "";
    }
    TextField {
      Keys.onReleased: {
        event.accepted = true;
      }
    }
    TextField {
      id:res
      text: "0"
    }
  }
}
