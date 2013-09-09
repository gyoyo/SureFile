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

#include "maidsafe/surefile/qt_ui/qobjects/service_list.h"

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

ServiceList::ServiceList(QObject* parent)
    : QAbstractListModel(parent),
      services_() {
  qRegisterMetaType<maidsafe::surefile::qt_ui::SureFileService>("SureFileService");
}

int ServiceList::rowCount(const QModelIndex& /*parent*/) const {
  return services_.count();
}

QVariant ServiceList::data(const QModelIndex& index, int role) const {
  if (index.row() < 0 || index.row() >= services_.count())
    return QVariant();

  const SureFileService& service = services_[index.row()];
  switch (role) {
    case NameRole:
      return service.folder_name_;
    case PathRole:
      return service.folder_path_;
    default:
      return QVariant();
  }
}

QString ServiceList::GetName(int rowIndex) {
  if (rowIndex < 0 || rowIndex >= services_.count())
    return QString();
  return services_[rowIndex].folder_name_;
}

void ServiceList::AddService(const SureFileService& service) {
  beginInsertRows(QModelIndex(), rowCount(), rowCount());
  services_.append(service);
  endInsertRows();
}

void ServiceList::RemoveService(const QString& folder_name) {
  int index(GetServiceIndex(folder_name));
  if (index == -1)
    return;

  beginRemoveRows(QModelIndex(), index, index);
  services_.removeAt(index);
  endRemoveRows();
}

void ServiceList::ModifyService(const QString& old_folder_name, const QString& new_folder_name) {
  int index(GetServiceIndex(old_folder_name));
  if (index == -1)
    return;

  services_.replace(index, SureFileService(new_folder_name, services_.at(index).folder_path_));
  emit dataChanged(createIndex(index, 0), createIndex(index, 0));
}

QHash<int, QByteArray> ServiceList::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[NameRole] = "name";
  roles[PathRole] = "path";
  return roles;
}

int ServiceList::GetServiceIndex(const QString& folder_name) {
  for (int i = 0; i < services_.size(); ++i)
    if (services_[i].folder_name_ == folder_name)
      return i;
  return -1;
}

}  // namespace qt_ui

}  // namespace lifestuff

}  // namespace maidsafe
