#==================================================================================================#
#                                                                                                  #
#  Copyright 2012 MaidSafe.net limited                                                             #
#                                                                                                  #
#  This MaidSafe Software is licensed under the MaidSafe.net Commercial License, version 1.0 or    #
#  later, and The General Public License (GPL), version 3. By contributing code to this project    #
#  You agree to the terms laid out in the MaidSafe Contributor Agreement, version 1.0, found in    #
#  the root directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also    #
#  available at:                                                                                   #
#                                                                                                  #
#    http://www.novinet.com/license                                                                #
#                                                                                                  #
#  Unless required by applicable law or agreed to in writing, software distributed under the       #
#  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,       #
#  either express or implied. See the License for the specific language governing permissions      #
#  and limitations under the License.                                                              #
#                                                                                                  #
#==================================================================================================#


set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
project(surefile)


#==================================================================================================#
#  Brings all the MaidSafe libraries into scope as CMake targets.                                  #
#==================================================================================================#
find_file(MaidSafeExport NAMES maidsafe_export.cmake
                         PATHS ${MAIDSAFE_BINARY_DIR} ../build ../../build
                         NO_DEFAULT_PATH)

if(NOT MaidSafeExport)
  set(ErrorMessage "\n\nCan't find maidsafe_export.cmake in MAIDSAFE_BINARY_DIR.  ")
  set(ErrorMessage "${ErrorMessage}Currently MAIDSAFE_BINARY_DIR is set to ")
  set(ErrorMessage "${ErrorMessage}\"${MAIDSAFE_BINARY_DIR}\"  It must be set to the MaidSafe ")
  set(ErrorMessage "${ErrorMessage}super-project's build root.\nTo set it, run:\n")
  set(ErrorMessage "${ErrorMessage}    cmake . -DMAIDSAFE_BINARY_DIR=\"<path to build root>\"\n\n")
  message(FATAL_ERROR "${ErrorMessage}")
else()
  get_filename_component(ExportDir "${MaidSafeExport}" PATH)
  get_filename_component(MAIDSAFE_BINARY_DIR "${ExportDir}" PATH CACHE)
endif()

include(${MaidSafeExport})


#==================================================================================================#
#  Standard Setup.                                                                                 #
#==================================================================================================#
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include(utils)
get_target_platform()
get_target_architecture()


#==================================================================================================#
# Qt library search                                                                                #
#==================================================================================================#
set(Qt5Required ON)
include(maidsafe_find_qt5)


#==================================================================================================#
# Set up SUREFILE UI files as GLOBs                                                               #
#==================================================================================================#
set(SRC_MAIDSAFE ${PROJECT_SOURCE_DIR}/src/maidsafe/surefile/qt_ui)
####    CODE    ####
set(UI_QT_MAIN_CC ${SRC_MAIDSAFE}/main.cc)
source_group("Auto Compiled\\QObject Files" FILES "${CMAKE_CURRENT_BINARY_DIR}/surefile_automoc.cpp")

file(GLOB SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR ${SRC_MAIDSAFE}/helpers/*.cc)
file(GLOB HEADER_FILES_SUREFILE_QT_UI_HELPERS_DIR ${SRC_MAIDSAFE}/helpers/*.h)
source_group("Helpers\\Source Files" FILES ${SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR})
source_group("Helpers\\Header Files" FILES ${HEADER_FILES_SUREFILE_QT_UI_HELPERS_DIR})

set(QT_PCH_HEADER ${SRC_MAIDSAFE}/helpers/qt_push_headers.h)
if(NOT WIN32)
  list(REMOVE_ITEM SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR ${SRC_MAIDSAFE}/helpers/qt_push_headers.cc)
endif()

file(GLOB SOURCE_FILES_SUREFILE_QT_UI_MODELS_DIR "${SRC_MAIDSAFE}/models/*.cc")
file(GLOB HEADER_FILES_SUREFILE_QT_UI_MODELS_DIR "${SRC_MAIDSAFE}/models/*.h")
source_group("Models\\Source Files" FILES ${SOURCE_FILES_SUREFILE_QT_UI_MODELS_DIR})
source_group("Models\\Header Files" FILES ${HEADER_FILES_SUREFILE_QT_UI_MODELS_DIR})

file(GLOB SOURCE_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR "${SRC_MAIDSAFE}/controllers/*.cc")
file(GLOB HEADER_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR "${SRC_MAIDSAFE}/controllers/*.h")
source_group("Controllers\\Source Files" FILES ${SOURCE_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR})
source_group("Controllers\\Header Files" FILES ${HEADER_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR})

QT5_ADD_RESOURCES(RESOURCE_FILES_SUREFILE_QT_UI_RESOURCES_DIR ${SRC_MAIDSAFE}/resources/resources.qrc)
source_group("Auto Compiled\\Resource Files" FILES ${RESOURCE_FILES_SUREFILE_QT_UI_RESOURCES_DIR})

file(GLOB UI_FILES_SUREFILE_QT_UI_VIEWS_DIR ${SRC_MAIDSAFE}/views/*.ui)
QT5_WRAP_UI(UIC_FILES_SUREFILE_QT_UI_VIEWS_DIR ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR})
source_group("Views\\UI" FILES ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR})
source_group("Auto Compiled\\View Compiled Files" FILES ${UIC_FILES_SUREFILE_QT_UI_VIEWS_DIR})

set(ALL_SUREFILE_QT_UI_SOURCE_FILES
      ${SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR}
      ${SOURCE_FILES_SUREFILE_QT_UI_MODELS_DIR}
      ${SOURCE_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR}
      ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR}
      ${UIC_FILES_SUREFILE_QT_UI_VIEWS_DIR})
set(ALL_SUREFILE_QT_UI_HEADER_FILES
      ${HEADER_FILES_SUREFILE_QT_UI_HELPERS_DIR}
      ${HEADER_FILES_SUREFILE_QT_UI_MODELS_DIR}
      ${HEADER_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR})

#####    Setup Localisation Sources    ####
file(GLOB COMPILED_LOCALISATION_FILES ${SRC_MAIDSAFE}/resources/translations/*.ts)
if(UPDATE_LOCALISATION_RESOURCES)
  SET(LOCALISATION_LANGUAGES en fr es zh ja pt kr ar)
  SET(LOCALISATION_SOURCES
        ${SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR}
        ${SOURCE_FILES_SUREFILE_QT_UI_MODELS_DIR}
        ${SOURCE_FILES_SUREFILE_QT_UI_CONTROLLERS_DIR}
        ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR}
        ${QML_FILES_SUREFILE_QT_UI_DIR})
  SET(LOCALISATION_TS_FILES)
  execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/Translation_Sources)
  file(COPY ${COMPILED_LOCALISATION_FILES} DESTINATION ${CMAKE_BINARY_DIR}/Translation_Sources)
  foreach(LANGUAGE ${LOCALISATION_LANGUAGES})
    SET(LOCALISATION_TS_FILES ${LOCALISATION_TS_FILES} ${CMAKE_BINARY_DIR}/Translation_Sources/${LANGUAGE}.ts)
  endforeach()
  QT5_CREATE_TRANSLATION(LOCALISATION_QM_FILES ${LOCALISATION_SOURCES} ${LOCALISATION_TS_FILES})
  message(STATUS "NOTE: Translation Source Update Configured")
  message(STATUS "      Make Sure to Post-Build Transfer ${CMAKE_BINARY_DIR}/Translation_Sources")
  message(STATUS "                                  -->  ${SRC_MAIDSAFE}/resources/translations")
  message(STATUS "      Do not do a Clean Build with UPDATE_LOCALISATION_RESOURCES=ON")
else()
  QT5_ADD_TRANSLATION(LOCALISATION_QM_FILES ${COMPILED_LOCALISATION_FILES})
endif()
unset(UPDATE_LOCALISATION_RESOURCES CACHE)
source_group("Auto Compiled\\Localisation Files" FILES ${LOCALISATION_QM_FILES})

####    Set Source Resource File Groups    ####
file(GLOB RESOURCE_FILES_ROOT_DIR ${SRC_MAIDSAFE}/resources/*.*)

source_group("Resource Files" FILES ${RESOURCE_FILES_ROOT_DIR})

file(GLOB RESOURCE_FILES_ANIMATIONS_DIR ${SRC_MAIDSAFE}/resources/animations/*.*)
source_group("Resource Files\\Animations" FILES ${RESOURCE_FILES_ANIMATIONS_DIR})

file(GLOB RESOURCE_FILES_ICONS_DIR ${SRC_MAIDSAFE}/resources/icons/*.*)
source_group("Resource Files\\Icons" FILES ${RESOURCE_FILES_ICONS_DIR})

file(GLOB RESOURCE_FILES_QML_DIR ${SRC_MAIDSAFE}/resources/qml/*.*)
source_group("Views\\QML" FILES ${RESOURCE_FILES_QML_DIR})

file(GLOB RESOURCE_FILES_STYLES_DIR ${SRC_MAIDSAFE}/resources/styles/*.*)
source_group("Resource Files\\Styles" FILES ${RESOURCE_FILES_STYLES_DIR})

file(GLOB RESOURCE_FILES_TRANSLATIONS_DIR ${SRC_MAIDSAFE}/resources/translations/*.*)
source_group("Resource Files\\Translations" FILES ${RESOURCE_FILES_TRANSLATIONS_DIR})

set(ALL_SUREFILE_QT_UI_RESOURCE_SOURCE_FILES
      ${RESOURCE_FILES_ANIMATIONS_DIR}
      ${RESOURCE_FILES_ICONS_DIR}
      ${RESOURCE_FILES_QML_DIR}
      ${RESOURCE_FILES_STYLES_DIR}
      ${RESOURCE_FILES_TRANSLATIONS_DIR})

#####    Set Application Icon    ####
if(WIN32)
  set(SUREFILE_UI_QT_APP_ICON_RESOURCE ${SRC_MAIDSAFE}/resources/app_icon.rc)
  source_group("Auto Compiled\\App Icon File" FILES ${SRC_MAIDSAFE}/resources/app_icon.rc)
endif()


#==================================================================================================#
# Define executable                                                                                #
#==================================================================================================#
include_directories("${PROJECT_SOURCE_DIR}/src")
add_executable(surefile
                  ${UI_QT_MAIN_CC}
                  ${ALL_SUREFILE_QT_UI_SOURCE_FILES}
                  ${ALL_SUREFILE_QT_UI_HEADER_FILES}
                  ${RESOURCE_FILES_SUREFILE_QT_UI_RESOURCES_DIR}
                  ${ALL_SUREFILE_QT_UI_RESOURCE_SOURCE_FILES})
target_link_libraries(surefile Qt5::Core Qt5::Gui Qt5::Widgets Qt5::Quick Qt5::Qml maidsafe_lifestuff maidsafe_lifestuff_manager)

if(WIN32)
  set_target_properties(surefile PROPERTIES WIN32_EXECUTABLE TRUE)
elseif(APPLE)
  set_target_properties(surefile PROPERTIES MACOSX_BUNDLE TRUE)

  execute_process(COMMAND mkdir -p ${CMAKE_BINARY_DIR}/surefile.app/Contents/Resources)
  execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/installer/mac/icons/mac_bundle.icns ${CMAKE_BINARY_DIR}/surefile.app/Contents/Resources/)
  execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/installer/text/surefile/eula.txt ${CMAKE_BINARY_DIR}/surefile.app/Contents/Resources/)

  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_BUNDLE_NAME surefile )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_GUI_IDENTIFIER "surefile" )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_ICON_FILE mac_bundle.icns )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_INFO_STRING "0.2.0, Copyright 2012 MaidSafe team" )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_SHORT_VERSION_STRING "0.2" )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_LONG_VERSION_STRING "0.2.0" )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_BUNDLE_VERSION "0.2.0" )
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_COPYRIGHT "(C) 2012 MaidSafe" )
endif()

rename_outdated_built_exes()


#==================================================================================================#
# Set compiler and linker flags                                                                    #
#==================================================================================================#
include(standard_flags)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DQT_NO_DEBUG_OUTPUT -DQT_NO_WARNING_OUTPUT -DQT_NO_DEBUG_STREAM")

if(WIN32)
  string(REGEX REPLACE "/Zm[0-9]+ " "/Zm500 " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  set_source_files_properties(${ALL_SUREFILE_QT_UI_SOURCE_FILES} PROPERTIES
                              COMPILE_FLAGS "/Yu\"${QT_PCH_HEADER}\" /FI\"${QT_PCH_HEADER}\"")
  set_source_files_properties("${SRC_MAIDSAFE}/helpers/qt_push_headers.cc" PROPERTIES
                              COMPILE_FLAGS "/Yc\"${QT_PCH_HEADER}\" /FI\"${QT_PCH_HEADER}\"")
else(UNIX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-stack-protector")
  # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error")
endif()

# Set Application Version
set(CPACK_PACKAGE_VERSION_MAJOR ${ApplicationVersionMajor})
set(CPACK_PACKAGE_VERSION_MINOR ${ApplicationVersionMinor})
set(CPACK_PACKAGE_VERSION_PATCH ${ApplicationVersionPatch})

set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")


#==================================================================================================#
# Tests                                                                                            #
#==================================================================================================#
if(MaidsafeTesting)
  add_style_test()
endif()
