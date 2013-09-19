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

class APIModel;
class ServiceList;
class SystemTrayIcon;

class MainController : public QObject {
  Q_OBJECT

 public:
  explicit MainController(QObject* parent = 0);
  ~MainController();
  Q_INVOKABLE void CreateAccount();
  Q_INVOKABLE void Login();
  Q_INVOKABLE void AddService(const QString& alias, const QString& path);
  Q_INVOKABLE void RemoveService(const QString& alias);

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
  std::unique_ptr<ServiceList> service_list_;
  std::unique_ptr<SystemTrayIcon> system_tray_;
  QFutureWatcher<bool> future_watcher_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_CONTROLLER_H_

