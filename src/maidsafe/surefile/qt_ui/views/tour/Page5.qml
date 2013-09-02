import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("That's you ready to go!<br>If you need any more help <a href=\"http://google.com\"><strong>click here</strong></a> or select Help from the Tray menu.")
  tourImageUrl: ("../../images/tour_image_%1_01.png").arg(Qt.platform.os)
}
