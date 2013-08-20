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

#include "maidsafe/surefile/qt_ui/qobjects/store_path_controller.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

StorePathController::StorePathController(QObject* parent)
    : QObject(parent),
      display_store_path_(),
      actual_store_path_() {
  setActualStorePath(QUrl::fromLocalFile(QDir::homePath()).toString());
}

QString StorePathController::displayStorePath() const {
  return display_store_path_;
}

void StorePathController::setDisplayStorePath(const QString& storePath) {
  if (display_store_path_ == storePath)
    return;

  display_store_path_ = storePath;
  emit displayStorePathChanged();
}

QString StorePathController::actualStorePath() const {
  return actual_store_path_;
}

void StorePathController::setActualStorePath(const QString& storePathUrl) {
  if (actual_store_path_ == storePathUrl)
    return;

  actual_store_path_ = storePathUrl;
  setDisplayStorePath(QDir::toNativeSeparators(QUrl(actual_store_path_).toLocalFile()));
  emit actualStorePathChanged();
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
