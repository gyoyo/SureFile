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

void APIModel::AddService(const QString& alias, const QString& path) {
  try {
    surefile_api_->AddService(path.toStdString(), alias.toStdString());
  } catch(const surefile_error& error_code) {
    if (error_code.code() == make_error_code(SureFileErrors::invalid_service)) {
      emit addServiceErrorRaised(tr("Invalid Name or Path"));
    } else if (error_code.code() == make_error_code(SureFileErrors::duplicate_service)) {
      emit addServiceErrorRaised(tr("Duplicate Name or Path"));
    }
    return;
  } catch(...) {
    emit addServiceErrorRaised(tr("SureFile cannot store data in this chosen location"));
    return;
  }
  emit serviceOperationSuccess(tr("Service successfully added"));
}

void APIModel::RemoveService(const QString& path) {
  try {
    if (surefile_api_->RemoveService(QDir(path).dirName().toStdString()))
      emit serviceOperationSuccess(tr("Service successfully removed"));
    else
      emit removeServiceErrorRaised(tr("Unable to remove service"));
  } catch(...) {
    emit UnhandledException();
    QtLog("Unknown Exception");
  }
}

void APIModel::RenameService(const QString& oldAlias, const QString& newAlias) {
  try {
    // Invoke rename service here
    if (oldAlias.isEmpty() || newAlias.isEmpty())
      return;
  } catch(const surefile_error&) {
    emit renameServiceErrorRaised(tr("Unable to change folder name"));
  }
}

void APIModel::ParseConfigurationFileError() {
  emit OnParseConfigurationFileError();
}

void APIModel::AddServiceRequested() {
  emit showAddServiceSettings();
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
