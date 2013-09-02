import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("Within your SureFile drive create a new folder and name it.")
  tourImageUrl: ("../../images/tour_image_%1_02.png").arg(Qt.platform.os)
}
