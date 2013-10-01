import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

TourTemplatePage {
  tourText: qsTr("To access your encrypted files, simply open them from your SureFile drive which you can locate in the tray menu by selecting Open Drive.")
  tourImageUrl: ("../../images/tour/%1/04.png").arg(Qt.platform.os)
}
