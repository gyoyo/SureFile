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
#include "maidsafe/surefile/qt_ui/qobjects/password_box.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

MainController::MainController(QObject* parent)
    : QObject(parent),
      main_window_(),
      main_engine_() {
  qmlRegisterType<PasswordBox>("SureFile", 1, 0, "PasswordBoxHandler");
  QTimer::singleShot(0, this, SLOT(EventLoopStarted()));
}

void MainController::EventLoopStarted() {
  main_engine_ = new QQmlApplicationEngine(QUrl("qrc:/views/main.qml"));
  // auto root_context_ = main_engine_->rootContext();
  // root_context_->setContextProperty(kPasswordBoxHandler, password_box_handler_.get());
  main_window_ = qobject_cast<QQuickWindow *>(main_engine_->rootObjects().value(0));
  if (!main_window_) {
    qWarning() << "Root Item not Window";
    // TODO(Viv): Throw above warning as an app-exception and handle it gracefully
    return;
  }
  main_window_->show();
}

MainController::~MainController() {
  delete main_window_;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
