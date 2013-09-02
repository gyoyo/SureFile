import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("You will now be asked to create a store path for this folder which is where your encrypted files will be stored.")
  tourImageUrl: ("../../images/tour_image_%1_03.png").arg(Qt.platform.os)
}
