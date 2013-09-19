import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("To begin using SureFile, first locate the SureFile icon from your tray menu as shown. Click to reveal the tray menu and choose Go to Drive")
  tourImageUrl: ("../../images/tour/%1/01.png").arg(Qt.platform.os)
}
