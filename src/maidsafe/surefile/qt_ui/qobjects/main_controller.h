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
class SystemTrayIcon;

class MainController : public QObject {
  Q_OBJECT

 public:
  explicit MainController(QObject* parent = 0);
  ~MainController();
  Q_INVOKABLE void CreateAccount();
  Q_INVOKABLE void Login();
  Q_INVOKABLE void AddService(const QString& alias, const QString& path);
  Q_INVOKABLE void RemoveService(const QString& path);
  Q_INVOKABLE void RenameService(const QString& oldAlias, const QString& newAlias);

 protected:
  bool eventFilter(QObject* object, QEvent* event);

 signals:
  void showTour();
  void showSettings();

 private slots:  // NOLINT - Viv
  void EventLoopStarted();
  void CreateAccountCompleted();
  void LoginCompleted();
  void ParseConfigurationFileError();
  void UnhandledException();
  void OpenDrive();

 private:
  MainController(const MainController&);
  MainController& operator=(const MainController&);
  bool InitialisePostLogin();

  QQmlApplicationEngine* main_engine_;
  QQuickWindow* main_window_;
  std::unique_ptr<APIModel> api_model_;
  std::unique_ptr<SystemTrayIcon> system_tray_;
  QFutureWatcher<bool> future_watcher_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_CONTROLLER_H_

