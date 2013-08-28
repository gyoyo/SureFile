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

namespace surefile_api_imports = maidsafe::lifestuff;

APIModel::APIModel(QObject* parent)
    : QObject(parent),
      operation_state_(APIModel::Ready),
      password_(),
      confirm_password_(),
      error_message_(),
      surefile_api_() {
  emit errorMessageChanged();
  surefile_api_imports::Slots surefile_slots;
  surefile_slots.on_service_added = std::bind(&APIModel::StorePathRequested,
                                              this,
                                              std::placeholders::_1);
  surefile_slots.configuration_error = std::bind(&APIModel::APIConfigurationError, this);
  surefile_api_.reset(new SureFile(surefile_slots));
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
  return surefile_api_->CanCreateUser();
}

void APIModel::SetStorePathForAlias(const QString& alias, const QString& path) {
  surefile_api_->AddService(path.toStdString(), alias.toStdString());
}

void APIModel::DeleteAlias(const QString& alias) {
  surefile_api_->AddServiceFailed(alias.toStdString());
}

void APIModel::APIConfigurationError() {
  // Don't Care
}

void APIModel::StorePathRequested(const std::string& alias) {
  emit getStorePath(QString::fromStdString(alias));
}

bool APIModel::CreateAccount() {
  setOperationState(APIModel::Progress);
  try {
    // Key credential into shitty api
    int i = 0;
    foreach(QString character, password()) {
      surefile_api_->InsertInput(i++, character.toStdString(), surefile_api_imports::kPassword);
    }

    i = 0;
    foreach(QString character, confirmPassword()) {
      surefile_api_->InsertInput(i++,
                                 character.toStdString(),
                                 surefile_api_imports::kConfirmationPassword);
    }
    surefile_api_->CreateUser();
  } catch(const surefile_error& error_code) {
    setOperationState(APIModel::Error);
    if (error_code.code() == make_error_code(SureFileErrors::invalid_password)) {
      setErrorMessage(tr("Invalid Password"));
    } else if (error_code.code() == make_error_code(SureFileErrors::password_confirmation_failed)) {
      setErrorMessage(tr("Entries do not match"));
    }
    return false;
  } catch(...) {
    emit APICrashed();
    QtLog("Unknown Exception");
    return false;
  }

  setPassword(QString());
  setConfirmPassword(QString());
  setOperationState(APIModel::Ready);
  return true;
}

bool APIModel::Login() {
  setOperationState(APIModel::Progress);

    try {
    surefile_api_->LogIn();
  } catch(...) {
  }

  setOperationState(APIModel::Ready);
  return true;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
