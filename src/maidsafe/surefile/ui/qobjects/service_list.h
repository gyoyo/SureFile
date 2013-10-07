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

#ifndef MAIDSAFE_SUREFILE_UI_QOBJECTS_SERVICE_LIST_H_
#define MAIDSAFE_SUREFILE_UI_QOBJECTS_SERVICE_LIST_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace ui {

struct SureFileService {
  SureFileService(QString folder_name, QString folder_path)
    : folder_name_(folder_name),
      folder_path_(folder_path) {}

  SureFileService()  // DO NOT USE - USED FOR TYPE REGISTRATION
    : folder_name_(),
      folder_path_() {}

  QString folder_name_;
  QString folder_path_;
};

class ServiceList : public QAbstractListModel {
  Q_OBJECT

 public:
  enum ServiceRoles {
      NameRole = Qt::UserRole + 1,
      PathRole
  };

  explicit ServiceList(QObject* parent = 0);
  ~ServiceList() {}
  int rowCount(const QModelIndex& parent = QModelIndex()) const;
  QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
  Q_INVOKABLE QString GetName(int rowIndex);

 public slots:  // NOLINT - Viv
  void AddService(const SureFileService& service);
  void RemoveService(const QString& folder_name);
  void ModifyService(const QString& old_folder_name, const QString& new_folder_name);

 protected:
  QHash<int, QByteArray> roleNames() const;

 private:
  ServiceList(const ServiceList&);
  ServiceList& operator=(const ServiceList&);
  int GetServiceIndex(const QString& folder_name);

  QList<SureFileService> services_;
};

}  // namespace ui

}  // namespace surefile

}  // namespace maidsafe

Q_DECLARE_METATYPE(maidsafe::surefile::ui::SureFileService)

#endif  // MAIDSAFE_SUREFILE_UI_QOBJECTS_SERVICE_LIST_H_

