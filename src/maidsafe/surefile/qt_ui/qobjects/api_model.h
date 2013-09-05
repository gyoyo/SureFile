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

#ifndef MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_API_MODEL_H_
#define MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_API_MODEL_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

#include "maidsafe/surefile/surefile.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

class APIModel : public QObject {
  Q_OBJECT
  Q_ENUMS(OperationState)
  Q_PROPERTY(OperationState operationState READ operationState
                                           WRITE setOperationState
                                           NOTIFY operationStateChanged)
  Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
  Q_PROPERTY(QString confirmPassword READ confirmPassword
                                     WRITE setConfirmPassword
                                     NOTIFY confirmPasswordChanged)

 public:
  enum OperationState {
    Ready,
    Progress,
    Error
  };

  explicit APIModel(QObject* parent = 0);
  ~APIModel() {}

  OperationState operationState() const;
  void setOperationState(const OperationState& operationState);
  QString password() const;
  void setPassword(const QString& password);
  QString confirmPassword() const;
  void setConfirmPassword(const QString& confirmPassword);

  Q_INVOKABLE bool CanCreateAccount();
  void AddService(const QString& alias, const QString& path);
  void RemoveService(const QString& path);
  void RenameService(const QString& oldAlias, const QString& newAlias);

  void ParseConfigurationFileError();
  void AddServiceRequested();
  void StorePathRemove();
  bool CreateAccount();
  bool Login();
  QString MountPath();

 signals:
  // NPC Signals
  void operationStateChanged();
  void passwordChanged();
  void confirmPasswordChanged();

  // To QML
  void showAddServiceSettings();
  void addServiceErrorRaised(const QString& errorMessage);
  void removeServiceErrorRaised(const QString& errorMessage);
  void renameServiceErrorRaised(const QString& errorMessage);
  void serviceOperationSuccess(const QString& message);
  void loginErrorRaised(const QString& errorMessage);
  void createAccountErrorRaised(const QString& errorMessage);

  // To Main Controller
  void OnParseConfigurationFileError();
  void UnhandledException();

 private:
  APIModel(const APIModel&);
  APIModel& operator=(const APIModel&);
  OperationState operation_state_;
  QString password_;
  QString confirm_password_;
  std::unique_ptr<SureFile> surefile_api_;
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_API_MODEL_H_

