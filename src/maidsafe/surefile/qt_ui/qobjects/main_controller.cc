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
#include "maidsafe/surefile/qt_ui/qobjects/api_model.h"
#include "maidsafe/surefile/qt_ui/qobjects/password_box.h"
#include "maidsafe/surefile/qt_ui/qobjects/system_tray_icon.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

MainController::MainController(QObject* parent)
    : QObject(parent),
      main_window_(),
      main_engine_(),
      api_model_(new APIModel),
      system_tray_(new SystemTrayIcon),
      void_qfuture_(),
      is_busy_(false),
      error_message_() {
  qmlRegisterType<PasswordBox>("SureFile", 1, 0, "PasswordBoxHandler");
  InitSignals();
  QTimer::singleShot(0, this, SLOT(EventLoopStarted()));
}

bool MainController::isBusy() const {
  return is_busy_;
}

void MainController::setIsBusy(const bool& isBusy) {
  if (is_busy_ == isBusy)
    return;

  is_busy_ = isBusy;
  emit isBusyChanged();
}

QString MainController::errorMessage() const {
  return error_message_;
}

void MainController::setErrorMessage(const QString& errorMessage) {
  if (error_message_ == errorMessage)
    return;

  error_message_ = errorMessage;
  emit errorMessageChanged();
}

void MainController::CreateAccount() {
  setErrorMessage(QString());
  setIsBusy(true);
  void_qfuture_ = QtConcurrent::run(api_model_.get(), &APIModel::CreateAccount);
}

void MainController::Login() {
  setErrorMessage(QString());
  setIsBusy(true);
  void_qfuture_ = QtConcurrent::run(api_model_.get(), &APIModel::Login);
}

void MainController::EventLoopStarted() {
  main_engine_ = new QQmlApplicationEngine(QUrl("qrc:/views/Main.qml"));
  auto root_context_ = main_engine_->rootContext();
  root_context_->setContextProperty(kMainController, this);
  root_context_->setContextProperty(kAPIModel, api_model_.get());
  main_window_ = qobject_cast<QQuickWindow*>(main_engine_->rootObjects().value(0));
  if (!main_window_) {
    qWarning() << "Root Item not Window";
    // TODO(Viv): Throw above warning as an app-exception and handle it gracefully
    return;
  }
  main_window_->show();
  system_tray_->show();
}

void MainController::CreateAccountCompleted(const QString& error_message) {
  setIsBusy(false);
  if (!error_message.isEmpty()) {
    setErrorMessage(error_message);
    return;
  }
  main_window_->hide();
  system_tray_->SetIsLoggedIn(true);
  // Start procedure for first time tour from here
}

void MainController::LoginCompleted(const QString& error_message) {
  setIsBusy(false);
  if (!error_message.isEmpty()) {
    setErrorMessage(error_message);
    return;
  }
  main_window_->hide();
  system_tray_->SetIsLoggedIn(true);
  // Start procedure for first time tour from here
}

void MainController::InitSignals() {
  connect(api_model_.get(), SIGNAL(CreateAccountCompleted(const QString&)),
          this,             SLOT(CreateAccountCompleted(const QString&)));
  connect(api_model_.get(), SIGNAL(LoginCompleted(const QString&)),
          this,             SLOT(LoginCompleted(const QString&)));
}

MainController::~MainController() {
  void_qfuture_.waitForFinished();
  delete main_window_;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
