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

#include "maidsafe/surefile/qt_ui/qobjects/main_controller.h"

int main(int argc, char *argv[]) {
  QApplication application(argc, argv);
  application.setOrganizationDomain("http://www.maidsafe.net");
  application.setOrganizationName("MaidSafe.net Ltd.");
  application.setApplicationName("SureFile");
  application.setApplicationVersion("0.1");
  try {
    maidsafe::surefile::qt_ui::MainController main_controller;
    return application.exec();
  } catch(const std::exception &ex) {
    qWarning() << "STD Exception Caught: " << ex.what();
    return -1;
  } catch(...) {
    qWarning() << "Default Exception Caught";
    return -1;
  }
}

