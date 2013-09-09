/*  Copyright 2012 MaidSafe.net limited

    This MaidSafe Software is licensed to you under (1) the MaidSafe.net Commercial License,
    version 1.0 or later, or (2) The General Public License (GPL), version 3, depending on which
    licence you accepted on initial access to the Software (the "Licences").

    By contributing code to the MaidSafe Software, or to this project generally, you agree to be
    bound by the terms of the MaidSafe Contributor Agreement, version 1.0, found in the root
    directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also
    available at: http://www.novinet.com/license

    Unless required by applicable law or agreed to in writing, the MaidSafe Software distributed
    under the GPL Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
    OF ANY KIND, either express or implied.

    See the Licences for the specific language governing permissions and limitations relating to
    use of the MaidSafe Software.                                                                 */

#include "maidsafe/surefile/qt_ui/qobjects/store_path_converter.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

StorePathConverter::StorePathConverter(QObject* parent)
    : QObject(parent),
      display_store_path_(),
      actual_store_path_() {
  setActualStorePath(QUrl::fromLocalFile(QDir::homePath()).toString());
}

QString StorePathConverter::displayStorePath() const {
  return display_store_path_;
}

void StorePathConverter::setDisplayStorePath(const QString& storePath) {
  if (display_store_path_ == storePath)
    return;

  display_store_path_ = storePath;
  emit displayStorePathChanged();
}

QString StorePathConverter::actualStorePath() const {
  return actual_store_path_;
}

void StorePathConverter::setActualStorePath(const QString& storePathUrl) {
  if (actual_store_path_ == storePathUrl)
    return;

  if (storePathUrl.isEmpty()) {
    setDisplayStorePath(QString());
    emit actualStorePathChanged();
    return;
  }

  QDir dir(QUrl(storePathUrl).toLocalFile());
  dir.mkdir("SureFile");
  dir.cd("SureFile");
  actual_store_path_ = QUrl::fromLocalFile(dir.absolutePath()).toString();

  setDisplayStorePath(QDir::toNativeSeparators(QUrl(actual_store_path_).toLocalFile()));
  emit actualStorePathChanged();
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
