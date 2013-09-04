/*
 * copyright maidsafe.net limited 2008
 * The following source code is property of maidsafe.net limited and
 * is not meant for external use. The use of this code is governed
 * by the license file LICENSE.TXT found in the root of this directory and also
 * on www.maidsafe.net.
 *
 * You are not free to copy, amend or otherwise use this source code without
 * explicit written permission of the board of directors of maidsafe.net
 *
 *  Created on: Mar 26, 2009
 *      Author: Team
 */

#ifndef MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_SYSTEM_TRAY_ICON_H_
#define MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_SYSTEM_TRAY_ICON_H_

#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

class QMenu;
class QAction;

namespace maidsafe {

namespace surefile {

namespace qt_ui {

class SystemTrayIcon : public QSystemTrayIcon {
  Q_OBJECT

 public:
  SystemTrayIcon();
  ~SystemTrayIcon();
  void SetIsLoggedIn(bool is_logged_in);

 signals:  // NOLINT (Viv)
  void OpenDriveRequested();
  void OpenSettingsRequested();

 private slots:  // NOLINT - Viv
  void QuitApplication();
  void OnSystrayActivate(QSystemTrayIcon::ActivationReason reason);

 private:
  SystemTrayIcon(const SystemTrayIcon&);
  SystemTrayIcon& operator=(const SystemTrayIcon&);

  QMenu* menu_;
  QAction* seperator_;
  QAction* open_drive_;
  QAction* open_settings_;
  bool is_logged_in_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_SYSTEM_TRAY_ICON_H_
