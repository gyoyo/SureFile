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

#include "maidsafe/surefile/qt_ui/qobjects/system_tray_icon.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

SystemTrayIcon::SystemTrayIcon()
  : menu_(new QMenu),
    is_logged_in_() {
  setIcon(QIcon(":/images/error.png"));
  setToolTip("SureFile");
  open_drive_ = menu_->addAction(tr("Open Drive"), this, SIGNAL(OpenDriveRequested()));
  open_drive_->setEnabled(false);
  menu_->addSeparator();
  menu_->addAction(tr("Quit"), this, SLOT(QuitApplication()));
  connect(this,
          SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
          this,
          SLOT(OnSystrayActivate(QSystemTrayIcon::ActivationReason)));
  setContextMenu(menu_);
}

void SystemTrayIcon::SetIsLoggedIn(bool is_logged_in) {
  is_logged_in_ = is_logged_in;
  open_drive_->setEnabled(is_logged_in_);
}

void SystemTrayIcon::QuitApplication() {
  qApp->quit();
}

void SystemTrayIcon::OnSystrayActivate(QSystemTrayIcon::ActivationReason reason) {
  if (reason == QSystemTrayIcon::DoubleClick && is_logged_in_)
    emit OpenDriveRequested();
}

SystemTrayIcon::~SystemTrayIcon() {
  setVisible(false);
  delete menu_;
  menu_ = nullptr;
}

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe
