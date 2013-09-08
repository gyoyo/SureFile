/*  Copyright 2012 MaidSafe.net limited

    This MaidSafe Software is licensed to you under (1) the MaidSafe.net Commercial License,
    version 1.0 or later, or (2) The General Public License (GPL), version 3, depending on which
    licence you accepted on initial access to the Software (the "Licences").

    By contributing code to the MaidSafe Software, or to this project generally, you agree to be
    bound by the terms of the MaidSafe Contributor Agreement, version 1.0, found in the root
    directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also
    available at: http://www.novinet.com/license

    Unless required by applicable law or agreed to in writing, the MaidSafe Software distributed
    under the GPL Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
    OF ANY KIND, either express or implied.

    See the Licences for the specific language governing permissions and limitations relating to
    use of the MaidSafe Software.                                                                 */

#include "maidsafe/surefile/qt_ui/qobjects/main_controller.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

#include "maidsafe/surefile/qt_ui/helpers/application.h"
#include "maidsafe/surefile/qt_ui/helpers/custom_message_box.h"
#include "maidsafe/surefile/qt_ui/helpers/qml_indexers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_log.h"
#include "maidsafe/surefile/qt_ui/qobjects/api_model.h"
#include "maidsafe/surefile/qt_ui/qobjects/password_box.h"
#include "maidsafe/surefile/qt_ui/qobjects/store_path_converter.h"
#include "maidsafe/surefile/qt_ui/qobjects/system_tray_icon.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

MainController::MainController(QObject* parent)
    : QObject(parent),
      main_engine_(),
      main_window_(),
      api_model_(),
      system_tray_(new SystemTrayIcon),
      future_watcher_() {
  qmlRegisterType<PasswordBox>("SureFile", 1, 0, "PasswordBoxHandler");
  qmlRegisterType<APIModel>("SureFile", 1, 0, "APIModel");
  qmlRegisterType<StorePathConverter>("SureFile", 1, 0, "StorePathConverter");
  installEventFilter(this);
  QTimer::singleShot(0, this, SLOT(EventLoopStarted()));
}

void MainController::CreateAccount() {
  connect(&future_watcher_, SIGNAL(finished()), this, SLOT(CreateAccountCompleted()));
  future_watcher_.setFuture(QtConcurrent::run(api_model_.get(), &APIModel::CreateAccount));
}

void MainController::Login() {
  connect(&future_watcher_, SIGNAL(finished()), this, SLOT(LoginCompleted()));
  future_watcher_.setFuture(QtConcurrent::run(api_model_.get(), &APIModel::Login));
}

void MainController::AddService(const QString& alias, const QString& path) {
  api_model_->AddService(alias, path);
}

void MainController::RemoveService(const QString& path) {
  QtConcurrent::run(api_model_.get(), &APIModel::RemoveService, path);
}

void MainController::RenameService(const QString& /*oldAlias*/, const QString& /*newAlias*/) {
}

bool MainController::eventFilter(QObject* object, QEvent* event) {
  if (object == this && event->type() >= QEvent::User && event->type() <= QEvent::MaxUser) {
    UnhandledException();
    return true;
  }
  return QObject::eventFilter(object, event);
}

void MainController::EventLoopStarted() {
  api_model_.reset(new APIModel);
  connect(api_model_.get(),   SIGNAL(OnParseConfigurationFileError()),
          this,               SLOT(ParseConfigurationFileError()));
  connect(api_model_.get(),   SIGNAL(UnhandledException()),
          this,               SLOT(UnhandledException()));
  connect(system_tray_.get(), SIGNAL(OpenDriveRequested()),
          this,               SLOT(OpenDrive()));
  connect(system_tray_.get(), SIGNAL(OpenSettingsRequested()),
          this,               SIGNAL(showSettings()));

  main_engine_ = new QQmlApplicationEngine();
  auto root_context_ = main_engine_->rootContext();
  root_context_->setContextProperty(kMainController, this);
  root_context_->setContextProperty(kAPIModel, api_model_.get());
  main_engine_->load(QUrl("qrc:/views/MainView.qml"));
  main_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(0));
  if (!main_window_) {
    QtLog("App Startup Failed");
    throw new std::exception();
  }

  main_window_->show();
  system_tray_->show();
}

void MainController::CreateAccountCompleted() {
  disconnect(&future_watcher_, SIGNAL(finished()), this, SLOT(CreateAccountCompleted()));
  if (!InitialisePostLogin())
    return;
  system_tray_->showMessage(tr(""), tr("SureFile is running"));
  emit showTour();
}

void MainController::LoginCompleted() {
  disconnect(&future_watcher_, SIGNAL(finished()), this, SLOT(LoginCompleted()));
  InitialisePostLogin();
}

void MainController::ParseConfigurationFileError() {
  CustomMessageBox::Show(tr("SureFile is unable to locate all of your data"));
}

void MainController::UnhandledException() {
  CustomMessageBox::Show(
      tr("SureFile has encountered an unexpected error. Please relaunch SureFile"),
      QMessageBox::Critical);
  qApp->quit();
}

void MainController::OpenDrive() {
  QDesktopServices::openUrl(QUrl("file:///" + api_model_->MountPath()));
}

bool MainController::InitialisePostLogin() {
  if (future_watcher_.isCanceled() || !future_watcher_.result())
    return false;

  main_window_->hide();
  system_tray_->SetIsLoggedIn(true);
  qApp->setQuitOnLastWindowClosed(false);
  return true;
}

MainController::~MainController() {
  future_watcher_.waitForFinished();
  delete main_window_;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
