import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("To begin using SureFile, first locate the SureFile icon from your tray menu as shown. Right click to reveal the tray menu and choose Manage Store Paths.")
  tourImageUrl: ("../../images/tour/%1/01.png").arg(Qt.platform.os)
}
