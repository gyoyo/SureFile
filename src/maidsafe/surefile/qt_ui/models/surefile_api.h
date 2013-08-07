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

#ifndef MAIDSAFE_SUREFILE_QT_UI_MODELS_SUREFILE_API_H_
#define MAIDSAFE_SUREFILE_QT_UI_MODELS_SUREFILE_API_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

#include "maidsafe/lifestuff/surefile_api.h"

#include "maidsafe/surefile/qt_ui/helpers/app_return_code.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

namespace backend = maidsafe::lifestuff;

class SureFileAPIModel : public QObject {
  Q_OBJECT

 public:
  explicit SureFileAPIModel(QObject* parent = 0);
  ~SureFileAPIModel() {}
  void Initialise();
  void Login();
  void CreateUser(const QString& vault_path);
  void EditPIN();
  void EditKeyword();
  void EditPassword();
  void Logout();
  bool IsLoggedIn();
  QString MyStuffPath();
  void InsertIntoCredential(backend::InputField type, int position, QString utf8_character);
  void RemoveFromCredential(backend::InputField type, int position, int length);
  void ClearCredential(backend::InputField type);
  bool IsCredentialValid(backend::InputField type);

  // API - Callbacks
  void ConnectionStrengthChanged(int new_strength);
  void UpdateNetworkPendingOperations(bool has_pending_operations);
  void NewUpdateCallback(std::string updater_path);
  void NewAPIActionProgress(backend::Action api_action, backend::ProgressCode progress_code);

 signals:
  void InitialiseComplete(AppReturnCode return_code);
  void LoginComplete(AppReturnCode return_code);
  void CreateUserComplete(AppReturnCode return_code);
  void EditPINComplete(AppReturnCode return_code);
  void EditKeywordComplete(AppReturnCode return_code);
  void EditPasswordComplete(AppReturnCode return_code);
  void LogoutComplete(AppReturnCode return_code);
  void ConnectionStrengthChangeReceived(int new_strength);
  void UpdateNetworkPendingOperationsReceived(bool has_pending_operations);
  void NewUpdateReceived(const QString& updater_path);
  void NewAPIActionProgressReceived(backend::Action api_action,
                                    backend::ProgressCode progress_code);

 private:
  SureFileAPIModel(const SureFileAPIModel&);
  SureFileAPIModel& operator=(const SureFileAPIModel&);
  std::string ConvertToUTF8Array(const QString& input_string);
  QString ConvertFromUTF8Array(const std::string& input_string);

  std::unique_ptr<backend::SureFile> surefile_api_;
  backend::ReportProgressFunction api_progress_callback_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_MODELS_SUREFILE_API_H_

