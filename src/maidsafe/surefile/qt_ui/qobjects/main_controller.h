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

#ifndef MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_COINTROLLER_H_
#define MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_COINTROLLER_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

class PasswordBox;

class MainController : public QObject {
  Q_OBJECT

 public:
  MainController(QObject* parent = 0);
  ~MainController();

 private slots:
  void EventLoopStarted();

 private:
  MainController(const MainController&);
  MainController& operator=(const MainController&);

  QQmlApplicationEngine* main_engine_;
  QQuickWindow* main_window_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_MAIN_COINTROLLER_H_

