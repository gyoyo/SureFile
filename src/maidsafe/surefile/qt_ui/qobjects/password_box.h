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

#ifndef MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_PASSWORD_BOX_H_
#define MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_PASSWORD_BOX_H_

// std
#include <memory>
#include <string>

#include "maidsafe/surefile/qt_ui/helpers/qt_push_headers.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

class PasswordBox : public QObject {
  Q_OBJECT

 public:
  explicit PasswordBox(QObject* parent = 0);
  ~PasswordBox() {}

 private:
  PasswordBox(const PasswordBox&);
  PasswordBox& operator=(const PasswordBox&);
};

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe

#endif  // MAIDSAFE_SUREFILE_QT_UI_QOBJECTS_PASSWORD_BOX_H_

