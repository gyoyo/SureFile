import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
//import LifeStuff 1.0

Rectangle {
    color: "red"
gradient: Gradient {
    GradientStop {
        position: 0.00;
        color: "#ff0000";
    }
    GradientStop {
        position: 0.99;
        color: "#ffffff";
    }
    GradientStop {
        position: 1.00;
        color: "#ffffff";
    }
}
    height: root.width
    width: root.width
}
