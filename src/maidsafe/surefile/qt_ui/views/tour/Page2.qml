import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("This is where your store paths will be displayed. Here you can add or remove paths.")
  tourImageUrl: ("../../images/tour/%1/02.png").arg(Qt.platform.os)
}
