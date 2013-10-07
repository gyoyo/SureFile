import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("When you add a new path you'll be asked to give it a name and choose a location for your encrypted files to be stored.")
  tourImageUrl: ("../../images/tour/%1/03.png").arg(Qt.platform.os)
}
