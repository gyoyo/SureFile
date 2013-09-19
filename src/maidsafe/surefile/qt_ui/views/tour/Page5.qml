import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("Ok, you're ready to go!")
  tourImageUrl: ("../../images/tour/%1/01.png").arg(Qt.platform.os)
}
