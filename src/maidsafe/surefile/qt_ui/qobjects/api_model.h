/*  Copyright 2012 MaidSafe.net limited

    This MaidSafe Software is licensed to you under (1) the MaidSafe.net Commercial License,
    version 1.0 or later, or (2) The General Public License (GPL), version 3, depending on which
    licence you accepted on initial access to the Software (the "Licences").

    By contributing code to the MaidSafe Software, or to this project generally, you agree to be
    bound by the terms of the MaidSafe Contributor Agreement, version 1.0, found in the root
    directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also
    available at: http://www.maidsafe.net/licenses

    Unless required by applicable law or agreed to in writing, the MaidSafe Software distributed
    under the GPL Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
    OF ANY KIND, either express or implied.

    See the Licences for the specific language governing permissions and limitations relating to
    use of the MaidSafe Software.                                                                 */

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

struct SureFileService;

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

  // NPC Helper Functions
  OperationState operationState() const;
  void setOperationState(const OperationState& operationState);
  QString password() const;
  void setPassword(const QString& password);
  QString confirmPassword() const;
  void setConfirmPassword(const QString& confirmPassword);

  // QML invokable functions
  Q_INVOKABLE bool CanCreateAccount();

  // SureFile-Lib Slots
  void ParseConfigurationFileError();
  void BackEndAddServiceRequested();
  void BackEndRemoveServiceRequested(const std::string& folder_name);
  void BackEndRenameServiceRequested(const std::string& old_name, const std::string& new_name);

  // MainController invokable functions
  bool CreateAccount();
  bool Login();
  void AddService(const QString& alias, const QString& path);
  void RemoveService(const QString& alias);
  QString MountPath();
  void PopulateServiceList();

 signals:
  // NPC Signals
  void operationStateChanged();
  void passwordChanged();
  void confirmPasswordChanged();

  // To QML
  void showAddServiceSettings();
  void addServiceErrorRaised(const QString& errorMessage);
  void removeServiceErrorRaised(const QString& errorMessage);
  void serviceOperationSuccess();
  void loginErrorRaised(const QString& errorMessage);
  void createAccountErrorRaised(const QString& errorMessage);

  // To Main Controller
  void OnParseConfigurationFileError();
  void UnhandledException();

  // To ServiceList
  void AddToServiceList(const SureFileService& service);
  void RemoveFromServiceList(const QString& folder_name);
  void ModifyItemInServiceList(const QString& old_folder_name,
                               const QString& new_folder_name);

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

