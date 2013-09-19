/*  Copyright 2012 MaidSafe.net limited

    This MaidSafe Software is licensed to you under (1) the MaidSafe.net Commercial License,
    version 1.0 or later, or (2) The General Public License (GPL), version 3, depending on which
    licence you accepted on initial access to the Software (the "Licences").

    By contributing code to the MaidSafe Software, or to this project generally, you agree to be
    bound by the terms of the MaidSafe Contributor Agreement, version 1.0, found in the root
    directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also
    available at: http://www.maidsafe.net/licenses

    Unless required by applicable law or agreed to in writing, the MaidSafe Software distributed
    under the GPL Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
    OF ANY KIND, either express or implied.

    See the Licences for the specific language governing permissions and limitations relating to
    use of the MaidSafe Software.                                                                 */

#include "maidsafe/surefile/qt_ui/qobjects/system_tray_icon.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

SystemTrayIcon::SystemTrayIcon()
  : menu_(new QMenu),
    seperator_(),
    open_drive_(),
    open_settings_(),
    is_logged_in_() {
  setIcon(QIcon(":/images/surefile_app_mac.png"));
  setToolTip("SureFile");
  open_drive_ = menu_->addAction(tr("Open Drive"), this, SIGNAL(OpenDriveRequested()));
  open_drive_->setVisible(false);
  open_settings_ = menu_->addAction(tr("Settings"), this, SIGNAL(OpenSettingsRequested()));
  open_settings_->setVisible(false);
  seperator_ = menu_->addSeparator();
  seperator_->setVisible(false);
  menu_->addAction(tr("Quit"), this, SLOT(QuitApplication()));
  connect(this,
          SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
          this,
          SLOT(OnSystrayActivate(QSystemTrayIcon::ActivationReason)));
  setContextMenu(menu_);
}

void SystemTrayIcon::SetIsLoggedIn(bool is_logged_in) {
  is_logged_in_ = is_logged_in;
  open_drive_->setVisible(is_logged_in_);
  open_settings_->setVisible(is_logged_in_);
  seperator_->setVisible(is_logged_in_);
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
