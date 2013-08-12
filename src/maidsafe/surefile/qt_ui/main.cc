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

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

int main(int argc, char *argv[]) {
  QApplication application(argc, argv);
  application.setOrganizationDomain("http://www.maidsafe.net");
  application.setOrganizationName("MaidSafe.net Ltd.");
  application.setApplicationName("SureFile");
  application.setApplicationVersion("0.1");

    try {
      int rc = 0;
      QQmlEngine engine;
      QQmlComponent* component = new QQmlComponent(&engine);
      QObject::connect(&engine, SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));
      component->loadUrl(QUrl("qrc:/views/MainView.qml"));
      if (!component->isReady() ) {
          qWarning("%s", qPrintable(component->errorString()));
          return -1;
      }

      QObject* topLevel = component->create();
      QQuickWindow* window = qobject_cast<QQuickWindow *>(topLevel);
      QSurfaceFormat surfaceFormat = window->requestedFormat();
      window->setFormat(surfaceFormat);
      window->show();

      rc = application.exec();
      delete component;
      return rc;
    } catch(const std::exception &ex) {
      qWarning() << "STD Exception Caught: " << ex.what();
      return -1;
    } catch(...) {
      qWarning() << "Default Exception Caught";
      return -1;
    }
}

