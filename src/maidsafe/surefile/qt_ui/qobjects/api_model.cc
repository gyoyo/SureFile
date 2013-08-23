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
      operation_state_(APIModel::Ready),
      error_message_(),
      password_(),
      confirm_password_() {
  emit errorMessageChanged();
}

APIModel::OperationState APIModel::operationState() const {
  return operation_state_;
}

void APIModel::setOperationState(const APIModel::OperationState& operationState) {
  if (operation_state_ == operationState)
    return;

  operation_state_ = operationState;
  emit operationStateChanged();
}

QString APIModel::errorMessage() const {
  return error_message_;
}

void APIModel::setErrorMessage(const QString& errorMessage) {
  if (error_message_ == errorMessage)
    return;

  error_message_ = errorMessage;
  emit errorMessageChanged();
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
  return true;
}

void APIModel::SetStorePathForAlias(const QString& alias, const QString& path) {
  // Invoke to set store path for alias from backend api
  QtLog(QString("Alias: %1 Path: %2").arg(alias).arg(path));
}

void APIModel::DeleteAlias(const QString& alias) {
  // Invoke to delete alias from backend api
  QtLog(QString("Deleting Alias: %1").arg(alias));
}

void APIModel::StorePathRequested(const std::string& alias) {
  // setStoreAlias(QString::fromStdString(alias));
  emit getStorePath(QString::fromStdString(alias));
}

bool APIModel::CreateAccount() {
  setOperationState(APIModel::Progress);

  // Mock - Start
  QtLog(QString("Creating Account with Pass: %1 and Conf Pass: %2").arg(password())
                                                                   .arg(confirmPassword()));
  QThread::sleep(3);
  if (password() != confirmPassword()) {
    setErrorMessage(QString("Entries do not Match"));
    setOperationState(APIModel::Error);
    return false;
  }

  if (password().isEmpty()) {
    setErrorMessage(QString("Some Error Message"));
    setOperationState(APIModel::Error);
    return false;
  }
  // Mock - End

  setOperationState(APIModel::Ready);
  return true;
}

bool APIModel::Login() {
  setOperationState(APIModel::Progress);

  // Mock - Start
  QtLog(QString("Logging In with Pass: %1").arg(password()));
  QThread::sleep(3);

  if (password().isEmpty()) {
    setErrorMessage(QString("Some Error Message"));
    setOperationState(APIModel::Error);
    return false;
  }
  // Mock - End

  setOperationState(APIModel::Ready);
  return true;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
