import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("Ok, you're ready to go!")
  tourImageUrl: ("../../images/tour_image_%1_01.png").arg(Qt.platform.os)
}
