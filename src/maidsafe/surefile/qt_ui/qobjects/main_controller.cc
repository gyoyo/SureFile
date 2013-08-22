/* Copyright 2012 MaidSafe.net limited

This MaidSafe Software is licensed under the MaidSafe.net Commercial License, version 1.0 or later,
and The General Public License (GPL), version 3. By contributing code to this project You agree to
the terms laid out in the MaidSafe Contributor Agreement, version 1.0, found in the root directory
of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also available at:

http://www.novinet.com/license

Unless required by applicable law or agreed to in writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing permissions and limitations under the
License.
*/

#include "maidsafe/surefile/qt_ui/qobjects/main_controller.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

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
      api_model_(new APIModel),
      system_tray_(new SystemTrayIcon),
      future_watcher_() {
  qmlRegisterType<PasswordBox>("SureFile", 1, 0, "PasswordBoxHandler");
  qmlRegisterType<APIModel>("SureFile", 1, 0, "APIModel");
  qmlRegisterType<StorePathConverter>("SureFile", 1, 0, "StorePathConverter");
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

void MainController::EventLoopStarted() {
  main_engine_ = new QQmlApplicationEngine(QUrl("qrc:/views/Main.qml"));
  auto root_context_ = main_engine_->rootContext();
  root_context_->setContextProperty(kMainController, this);
  root_context_->setContextProperty(kAPIModel, api_model_.get());
  main_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(0));
  if (!main_window_) {
    // TODO(Viv): Throw above warning as an app-exception and handle it gracefully
    QtLog("App Startup Failed");
    return;
  }

  main_window_->show();
  system_tray_->show();
}

void MainController::CreateAccountCompleted() {
  disconnect(&future_watcher_, SIGNAL(finished()), this, SLOT(CreateAccountCompleted()));
  LoginCompleted();
  system_tray_->showMessage(tr(""), tr("SureFile is running"));
  // Start procedure for first time tour from here
}

void MainController::LoginCompleted() {
  disconnect(&future_watcher_, SIGNAL(finished()), this, SLOT(LoginCompleted()));
  if (future_watcher_.isCanceled() || !future_watcher_.result())
    return;

  main_window_->hide();
  system_tray_->SetIsLoggedIn(true);
  qApp->setQuitOnLastWindowClosed(false);
}

MainController::~MainController() {
  future_watcher_.waitForFinished();
  delete main_window_;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
