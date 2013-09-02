import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("To access your encrypted files again, simply open them from this same location. They will be unreadable from the store path, ensuring only you can open them.")
  tourImageUrl: ("../../images/tour_image_%1_04.png").arg(Qt.platform.os)
}
