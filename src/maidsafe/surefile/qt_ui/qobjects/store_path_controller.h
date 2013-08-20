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

#ifndef MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_STORE_PATH_CONTROLLER_H_
#define MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_STORE_PATH_CONTROLLER_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

class StorePathController : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString displayStorePath READ displayStorePath
                                      WRITE setDisplayStorePath
                                      NOTIFY displayStorePathChanged)
  Q_PROPERTY(QString actualStorePath READ actualStorePath
                                      WRITE setActualStorePath
                                      NOTIFY actualStorePathChanged)

 public:
  explicit StorePathController(QObject* parent = 0);
  ~StorePathController() {}
  QString displayStorePath() const;
  void setDisplayStorePath(const QString& storePath);
  QString actualStorePath() const;
  void setActualStorePath(const QString& storePathUrl);

 signals:
  void displayStorePathChanged();
  void actualStorePathChanged();

 private:
  StorePathController(const StorePathController&);
  StorePathController& operator=(const StorePathController&);

  QString display_store_path_;
  QString actual_store_path_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_STORE_PATH_CONTROLLER_H_

