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

#include "maidsafe/surefile/qt_ui/qobjects/main_controller.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

#include "maidsafe/surefile/qt_ui/helpers/application.h"
#include "maidsafe/surefile/qt_ui/helpers/custom_message_box.h"
#include "maidsafe/surefile/qt_ui/helpers/qml_indexers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_log.h"
#include "maidsafe/surefile/qt_ui/qobjects/api_model.h"
#include "maidsafe/surefile/qt_ui/qobjects/service_list.h"
#include "maidsafe/surefile/qt_ui/qobjects/store_path_converter.h"
#include "maidsafe/surefile/qt_ui/qobjects/system_tray_icon.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

MainController::MainController(QObject* parent)
    : QObject(parent),
      root_objects_count_(0),
      main_engine_(),
      main_window_(),
      settings_window_(),
      tour_window_(),
      api_model_(),
      service_list_(new ServiceList),
      system_tray_(new SystemTrayIcon),
      future_watcher_() {
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

void MainController::RemoveService(const QString& alias) {
  QtConcurrent::run(api_model_.get(), &APIModel::RemoveService, alias);
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
  connect(api_model_.get(),     SIGNAL(OnParseConfigurationFileError()),
          this,                 SLOT(ParseConfigurationFileError()));
  connect(api_model_.get(),     SIGNAL(UnhandledException()),
          this,                 SLOT(UnhandledException()));
  connect(api_model_.get(),     SIGNAL(AddToServiceList(const SureFileService&)),
          service_list_.get(),  SLOT(AddService(const SureFileService&)));
  connect(api_model_.get(),     SIGNAL(RemoveFromServiceList(const QString&)),
          service_list_.get(),  SLOT(RemoveService(const QString&)));
  connect(api_model_.get(),     SIGNAL(ModifyItemInServiceList(const QString&, const QString&)),
          service_list_.get(),  SLOT(ModifyService(const QString&, const QString&)));
  connect(system_tray_.get(),   SIGNAL(OpenDriveRequested()),
          this,                 SLOT(OpenDrive()));
  connect(system_tray_.get(),   SIGNAL(OpenSettingsRequested()),
          this,                 SLOT(OpenSettings()));

  main_engine_ = new QQmlApplicationEngine();
  auto root_context_ = main_engine_->rootContext();
  root_context_->setContextProperty(kMainController, this);
  root_context_->setContextProperty(kAPIModel, api_model_.get());
  root_context_->setContextProperty(kServiceListModel, service_list_.get());
  main_engine_->load(QUrl("qrc:/views/MainView.qml"));
  main_engine_->load(QUrl("qrc:/views/Settings.qml"));
  main_engine_->load(QUrl("qrc:/views/Tour.qml"));
  main_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(root_objects_count_++));
  settings_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(root_objects_count_++));
  tour_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(root_objects_count_++));

  if (!main_window_ || !settings_window_ || !tour_window_) {
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
  tour_window_->show();
}

void MainController::LoginCompleted() {
  disconnect(&future_watcher_, SIGNAL(finished()), this, SLOT(LoginCompleted()));
  if (!InitialisePostLogin())
    return;
  api_model_->PopulateServiceList();
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

void MainController::OpenSettings() {
#ifdef MAIDSAFE_APPLE
  if (settings_window_)
    settings_window_->deleteLater();
  main_engine_->load(QUrl("qrc:/views/Settings.qml"));
  settings_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(root_objects_count_++));
#endif

  settings_window_->show();
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
  delete settings_window_;
  delete tour_window_;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
