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

#include "maidsafe/surefile/qt_ui/qobjects/api_model.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_log.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

APIModel::APIModel(QObject* parent)
    : QObject(parent),
      password_(),
      confirm_password_(),
      store_alias_() {
}

QString APIModel::password() const {
  return password_;
}

void APIModel::setPassword(const QString& password) {
  if (password_ == password)
    return;

  password_ = password;
  emit passwordChanged();
}

QString APIModel::confirmPassword() const {
  return confirm_password_;
}

void APIModel::setConfirmPassword(const QString& confirmPassword) {
  if (confirm_password_ == confirmPassword)
    return;

  confirm_password_ = confirmPassword;
  emit passwordChanged();
}

QString APIModel::storeAlias() const {
  return store_alias_;
}

void APIModel::setStoreAlias(const QString& storeAlias) {
  if (store_alias_ == storeAlias)
    return;

  store_alias_ = storeAlias;
  emit storeAliasChanged();
}

bool APIModel::CanCreateAccount() {
  return false;
}

void APIModel::SetStorePathForAlias(const QString& alias, const QString& path) {
  setStoreAlias(QString());
  // Invoke to set store path for alias from backend api
  QtLog(QString("Alias: %1 Path: %2").arg(alias).arg(path));
}

void APIModel::DeleteAlias(const QString& alias) {
  setStoreAlias(QString());
  // Invoke to delete alias from backend api
  QtLog(QString("Deleting Alias: %1").arg(alias));
}

void APIModel::StorePathRequested(const std::string& alias) {
  setStoreAlias(QString::fromStdString(alias));
}

void APIModel::CreateAccount() {
  // Mock - Replace with API call
  QtLog(QString("Creating Account with Pass: %1 and Conf Pass: %2").arg(password())
                                                                   .arg(confirmPassword()));
  if (password() != confirmPassword()) {
    emit CreateAccountCompleted(QString("Entries do not Match"));
    return;
  }
  QThread::sleep(3);
  emit CreateAccountCompleted(password().isEmpty() ? QString("Some Error") : QString());
  StorePathRequested("Dropbox");
}

void APIModel::Login() {
  // Mock - Replace with API call
  QtLog(QString("Logging In with Pass: %1").arg(password()));
  QThread::sleep(3);
  emit LoginCompleted(password().isEmpty() ? QString("Some Error") : QString());
  StorePathRequested("Dropbox");
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
