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

#include "maidsafe/surefile/qt_ui/helpers/application.h"

#include "maidsafe/surefile/qt_ui/qobjects/main_controller.h"
#include "maidsafe/surefile/qt_ui/helpers/qt_log.h"

namespace maidsafe {

namespace surefile {

namespace qt_ui {

ExceptionEvent::ExceptionEvent(const QString& exception_message, Type type)
    : QEvent(type),
      exception_message_(exception_message) {}

QString ExceptionEvent::ExceptionMessage() {
  return exception_message_;
}

Application::Application(int& argc, char** argv)
    : QApplication(argc, argv),
      handler_object_(),
      translators_(),
      current_translator_() {
  CreateTranslators();
  SwitchLanguage("en");
}

QStringList Application::AvailableTranslations() {
  return QStringList(translators_.keys());
}

void Application::SwitchLanguage(QString language) {
  if (current_translator_)
    removeTranslator(current_translator_);

  current_translator_ = translators_.value(language, nullptr);
  if (current_translator_)
    installTranslator(current_translator_);
}

bool Application::notify(QObject* receiver, QEvent* event) {
  try {
    return QApplication::notify(receiver, event);
  } catch(...) {
    if (handler_object_) {
      QApplication::instance()->postEvent(&(*handler_object_),
                                          new ExceptionEvent(tr("Unknown Exception")));
    } else {
      QApplication::quit();
    }
  }
  return false;
}

void Application::SetErrorHandler(boost::optional<MainController&> handler_object) {
  if (handler_object)
    handler_object_ = handler_object;
}

void Application::CreateTranslators() {
  if (!translators_.isEmpty())
    return;
  QStringList languages;
  languages << "en" << "ar" << "zh" << "fr" << "ja" << "ko" << "pt" << "es";
  foreach(QString language, languages) {
    QTranslator* translator = new QTranslator(instance());
    translator->load(language);
    translators_.insert(language, translator);
  }
}

}  // namespace qt_ui

}  // namespace surefile

}  // namespace maidsafe
