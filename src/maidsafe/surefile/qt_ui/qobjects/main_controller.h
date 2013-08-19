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

#ifndef MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_CONTROLLER_H_
#define MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_CONTROLLER_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

class PasswordBox;
class APIModel;

class MainController : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool isBusy READ isBusy WRITE setIsBusy NOTIFY isBusyChanged)
  Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
  Q_PROPERTY(QString errorMessage READ errorMessage
                                  WRITE setErrorMessage
                                  NOTIFY errorMessageChanged)

 public:
  explicit MainController(QObject* parent = 0);
  ~MainController();
  bool isBusy() const;
  void setIsBusy(const bool& isBusy);
  QString password() const;
  void setPassword(const QString& password);
  QString errorMessage() const;
  void setErrorMessage(const QString& errorMessage);
  Q_INVOKABLE void CreateAccount();
  Q_INVOKABLE void Login();

 signals:
  void isBusyChanged();
  void passwordChanged();
  void errorMessageChanged();

 private slots:  // NOLINT - Viv
  void EventLoopStarted();
  void CreateAccountCompleted(const QString& error_message);
  void LoginCompleted(const QString& error_message);

 private:
  MainController(const MainController&);
  MainController& operator=(const MainController&);
  void InitSignals();

  QQmlApplicationEngine* main_engine_;
  QQuickWindow* main_window_;
  std::unique_ptr<APIModel> api_model_;
  QFuture<void> void_qfuture_;
  bool is_busy_;
  QString password_;
  QString error_message_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_CONTROLLER_H_

