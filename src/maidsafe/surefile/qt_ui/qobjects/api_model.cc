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
      password_(),
      confirm_password_(),
      surefile_api_() {
  Slots surefile_slots;
  surefile_slots.on_service_added = std::bind(&APIModel::AddServiceRequested, this);
  surefile_slots.on_service_removed = std::bind(&APIModel::RemoveServiceRequested,
                                                this,
                                                std::placeholders::_1);
  surefile_slots.configuration_error = std::bind(&APIModel::ParseConfigurationFileError, this);
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
  emit confirmPasswordChanged();
}

bool APIModel::CanCreateAccount() {
  return surefile_api_->CanCreateUser();
}

void APIModel::SetStorePathForAlias(const QString& alias, const QString& path) {
  try {
    surefile_api_->AddService(path.toStdString(), alias.toStdString());
  } catch(const surefile_error&) {
    emit InvalidStoreLocationError();
  }
}

void APIModel::DeleteAlias(const QString& /*alias*/) {
  // surefile_api_->AddServiceFailed(alias.toStdString());
}

void APIModel::ParseConfigurationFileError() {
  emit OnParseConfigurationFileError();
}

void APIModel::AddServiceRequested() {
  emit showAddServiceSettings();
}

void APIModel::RemoveServiceRequested(const std::string& folder_name) {
  emit showRemoveServiceSettings(QString::fromStdString(folder_name));
}

bool APIModel::CreateAccount() {
  setOperationState(APIModel::Progress);
  try {
    int i = 0;
    foreach(QString character, password()) {
      surefile_api_->InsertInput(i++, character.toStdString(), kPassword);
    }

    i = 0;
    foreach(QString character, confirmPassword()) {
      surefile_api_->InsertInput(i++,
                                 character.toStdString(),
                                 kConfirmationPassword);
    }

    surefile_api_->CreateUser();
  } catch(const surefile_error& error_code) {
    setPassword(QString());
    setConfirmPassword(QString());
    setOperationState(APIModel::Error);
    if (error_code.code() == make_error_code(SureFileErrors::invalid_password)) {
      emit createAccountErrorRaised(tr("Invalid Password"));
    } else if (error_code.code() == make_error_code(SureFileErrors::password_confirmation_failed)) {
      emit createAccountErrorRaised(tr("Entries do not match"));
    }
    return false;
  } catch(...) {
    emit UnhandledException();
    QtLog("Unknown Exception");
    return false;
  }

  setOperationState(APIModel::Ready);
  return true;
}

bool APIModel::Login() {
    setOperationState(APIModel::Progress);
  try {
    int i = 0;
    foreach(QString character, password()) {
      surefile_api_->InsertInput(i++, character.toStdString(), kPassword);
    }

    surefile_api_->Login();
  } catch(const surefile_error&) {
    setPassword(QString());
    setOperationState(APIModel::Error);
    emit loginErrorRaised(tr("Invalid Password"));
    return false;
  } catch(...) {
    emit UnhandledException();
    QtLog("Unknown Exception");
    return false;
  }

  setOperationState(APIModel::Ready);
  return true;
}

QString APIModel::MountPath() {
  return QString::fromStdString(surefile_api_->mount_path());
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
