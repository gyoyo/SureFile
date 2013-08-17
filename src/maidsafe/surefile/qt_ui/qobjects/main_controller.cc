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

namespace maidsafe {

namespace surefile {

namespace qt_ui {

MainController::MainController(QObject* parent)
    : QObject(parent),
      main_component_(),
      main_engine_() {
  QTimer::singleShot(0, this, SLOT(EventLoopStarted()));
}

void MainController::EventLoopStarted() {
  main_component_ = new QQmlComponent(&main_engine_, QUrl("qrc:/views/MainView.qml"));
  QObject::connect(&main_engine_, SIGNAL(quit()), qApp, SLOT(quit()));
  if (!main_component_->isReady() )
    throw new std::exception(main_component_->errorString().toLatin1());

  QQuickWindow* window = qobject_cast<QQuickWindow*>(main_component_->create());
  window->setFormat(window->requestedFormat());
  window->show();
}

MainController::~MainController() {
  delete main_component_;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
