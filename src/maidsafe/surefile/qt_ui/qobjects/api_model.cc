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

namespace maidsafe {

namespace surefile {

namespace qt_ui {

APIModel::APIModel(QObject* parent)
    : QObject(parent),
      password_() {
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

bool APIModel::CanCreateAccount() {
  return false;
}

void APIModel::CreateAccount() {
  // Mock - Replace with API call
  // qDebug() <<
  //    QString("Creating Account with Pass: %1 and Conf Pass: %2").arg(password())
  //                                                               .arg(confirmPassword());
  if (password() != confirmPassword()) {
    emit CreateAccountCompleted(QString("Entries do not Match"));
    return;
  }
  QThread::sleep(3);
  emit CreateAccountCompleted(password().isEmpty() ? QString("Some Error") : QString());
}

void APIModel::Login() {
  // Mock - Replace with API call
  // qDebug() << QString("Logging In with Pass: %1").arg(password());
  QThread::sleep(3);
  emit LoginCompleted(password().isEmpty() ? QString("Some Error") : QString());
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
