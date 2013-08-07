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

#include "maidsafe/surefile/qt_ui/models/surefile_api.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

namespace args = std::placeholders;

SureFileAPIModel::SureFileAPIModel(QObject* parent)
    : QObject(parent),
      surefile_api_(),
      api_progress_callback_() {
  qRegisterMetaType<maidsafe::surefile::qt_ui::AppReturnCode>("AppReturnCode");
  api_progress_callback_ =
      std::bind(&SureFileAPIModel::NewAPIActionProgress, this, args::_1, args::_2);
}

void SureFileAPIModel::Initialise() {
  if (surefile_api_)
    return;
  try {
    backend::Slots callback_slots;
    callback_slots.network_health =
        std::bind(&SureFileAPIModel::ConnectionStrengthChanged, this, args::_1);
    callback_slots.operations_pending =
        std::bind(&SureFileAPIModel::UpdateNetworkPendingOperations, this, args::_1);
    callback_slots.update_available =
        std::bind(&SureFileAPIModel::NewUpdateCallback, this, args::_1);
    surefile_api_ = std::unique_ptr<backend::SureFile>(new backend::SureFile(callback_slots));
    emit InitialiseComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit InitialiseComplete(AppReturnCode::kError);
  }
}

void SureFileAPIModel::Login() {
  try {
    surefile_api_->LogIn("Needs Backend API Updated to not ask for Mount-Path on Login",
                         api_progress_callback_);
    emit LoginComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit LoginComplete(AppReturnCode::kError);
  }
}

void SureFileAPIModel::CreateUser(const QString& vault_path) {
  try {
    surefile_api_->CreateUser(ConvertToUTF8Array(vault_path), api_progress_callback_);
    emit CreateUserComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit CreateUserComplete(AppReturnCode::kError);
  }
}

void SureFileAPIModel::EditPIN() {
  try {
    // TODO(Viv): Uncomment Progress Delegate when implemented in LifeStuff API
    surefile_api_->ChangePin(api_progress_callback_);
    emit EditPINComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit EditPINComplete(AppReturnCode::kError);
  }
}

void SureFileAPIModel::EditKeyword() {
  try {
    // TODO(Viv): Uncomment Progress Delegate when implemented in LifeStuff API
    surefile_api_->ChangeKeyword(api_progress_callback_);
    emit EditKeywordComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit EditKeywordComplete(AppReturnCode::kError);
  }
}

void SureFileAPIModel::EditPassword() {
  try {
    // TODO(Viv): Uncomment Progress Delegate when implemented in LifeStuff API
    surefile_api_->ChangePassword(api_progress_callback_);
    emit EditPasswordComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit EditPasswordComplete(AppReturnCode::kError);
  }
}

void SureFileAPIModel::Logout() {
  try {
    surefile_api_->LogOut();
    emit LogoutComplete(AppReturnCode::kSuccess);
  } catch(std::exception&) {
    // TODO(Viv) switch above catch to specific managable exceptions and let the rest bubble up.
    emit LogoutComplete(AppReturnCode::kError);
  }
}

bool SureFileAPIModel::IsLoggedIn() {
  return surefile_api_->logged_in();
}

QString SureFileAPIModel::MyStuffPath() {
  return ConvertFromUTF8Array(surefile_api_->owner_path());
}

void SureFileAPIModel::InsertIntoCredential(backend::InputField type,
                                            int position,
                                            QString utf8_character) {
  surefile_api_->InsertUserInput(position, ConvertToUTF8Array(utf8_character), type);
}

void SureFileAPIModel::RemoveFromCredential(backend::InputField type, int position, int length) {
  surefile_api_->RemoveUserInput(position, length, type);
}

void SureFileAPIModel::ClearCredential(backend::InputField type) {
  surefile_api_->ClearUserInput(type);
}

bool SureFileAPIModel::IsCredentialValid(backend::InputField type) {
  return surefile_api_->ConfirmUserInput(type);
}

// API - Callbacks
void SureFileAPIModel::ConnectionStrengthChanged(int new_strength) {
  emit ConnectionStrengthChangeReceived(new_strength);
}

void SureFileAPIModel::UpdateNetworkPendingOperations(bool has_pending_operations) {
  emit UpdateNetworkPendingOperationsReceived(has_pending_operations);
}

void SureFileAPIModel::NewUpdateCallback(std::string updater_path) {
  emit NewUpdateReceived(ConvertFromUTF8Array(updater_path));
}

void SureFileAPIModel::NewAPIActionProgress(backend::Action api_action,
                                            backend::ProgressCode progress_code) {
  emit NewAPIActionProgressReceived(api_action, progress_code);
}

std::string SureFileAPIModel::ConvertToUTF8Array(const QString& input_string) {
  QByteArray string_array(input_string.toUtf8());
  return std::string(string_array.data(), string_array.size());
}

QString SureFileAPIModel::ConvertFromUTF8Array(const std::string& input_string) {
  return QString::fromUtf8(input_string.data(), static_cast<int>(input_string.size()));
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
