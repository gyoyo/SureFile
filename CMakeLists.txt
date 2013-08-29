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
#  Brings SureFile library into scope as CMake target.                                             #
#==================================================================================================#
find_file(SureFileLibExport NAMES surefile_export.cmake
                         PATHS ${SUREFILE_LIB_BINARY_DIR} ../build ../../build
                         NO_DEFAULT_PATH)

if(NOT SureFileLibExport)
  set(ErrorMessage "\n\nCan't find surefile_export.cmake in SUREFILE_LIB_BINARY_DIR.  ")
  set(ErrorMessage "${ErrorMessage}Currently SUREFILE_LIB_BINARY_DIR is set to ")
  set(ErrorMessage "${ErrorMessage}\"${SUREFILE_LIB_BINARY_DIR}\"  It must be set to the ")
  set(ErrorMessage "${ErrorMessage}SureFile-Lib's build root.\nTo set it, run:\n")
  set(ErrorMessage "${ErrorMessage}    cmake . -SUREFILE_LIB_BINARY_DIR=\"<path to build root>\"\n\n")
  message(FATAL_ERROR "${ErrorMessage}")
else()
  get_filename_component(SureFileLibExportDir "${SureFileLibExport}" PATH)
  get_filename_component(SUREFILE_LIB_BINARY_DIR "${SureFileLibExportDir}" PATH CACHE)
endif()

include(${SureFileLibExport})


#==================================================================================================#
#  Standard Setup.                                                                                 #
#==================================================================================================#
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include(utils)
get_target_platform()
get_target_architecture()

if(WIN32)
  set(CBFS_KEY "${MAIDSAFE_BINARY_DIR}/MaidSafe-Drive-Private/eldos_licence_key.txt")
  include(maidsafe_find_cbfs)
endif()

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

file(GLOB SOURCE_FILES_SUREFILE_QT_UI_QOBJECT_DIR "${SRC_MAIDSAFE}/qobjects/*.cc")
file(GLOB HEADER_FILES_SUREFILE_QT_UI_QOBJECT_DIR "${SRC_MAIDSAFE}/qobjects/*.h")
source_group("QObjects\\Source Files" FILES ${SOURCE_FILES_SUREFILE_QT_UI_QOBJECT_DIR})
source_group("QObjects\\Header Files" FILES ${HEADER_FILES_SUREFILE_QT_UI_QOBJECT_DIR})

QT5_ADD_RESOURCES(RESOURCE_FILES_SUREFILE_QT_UI_RESOURCES_DIR ${SRC_MAIDSAFE}/main_resource.qrc)
source_group("Auto Compiled\\Resource Files" FILES ${RESOURCE_FILES_SUREFILE_QT_UI_RESOURCES_DIR})

file(GLOB UI_FILES_SUREFILE_QT_UI_VIEWS_DIR ${SRC_MAIDSAFE}/views/*.* ${SRC_MAIDSAFE}/views/create_account/*.* ${SRC_MAIDSAFE}/views/tour/*.*)
source_group("Views" FILES ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR})

set(ALL_SUREFILE_QT_UI_SOURCE_FILES
      ${SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR}
      ${SOURCE_FILES_SUREFILE_QT_UI_QOBJECT_DIR})
set(ALL_SUREFILE_QT_UI_HEADER_FILES
      ${HEADER_FILES_SUREFILE_QT_UI_HELPERS_DIR}
      ${HEADER_FILES_SUREFILE_QT_UI_QOBJECT_DIR})

#####    Setup Localisation Sources    ####
file(GLOB COMPILED_LOCALISATION_FILES ${SRC_MAIDSAFE}/resources/translations/*.ts)
if(UPDATE_LOCALISATION_RESOURCES)
  SET(LOCALISATION_LANGUAGES en fr es)
  SET(LOCALISATION_SOURCES
        ${SOURCE_FILES_SUREFILE_QT_UI_HELPERS_DIR}
        ${SOURCE_FILES_SUREFILE_QT_UI_QOBJECT_DIR}
        ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR})
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

#####    Set Application Icon    ####
# if(WIN32)
  # set(SUREFILE_UI_QT_APP_ICON_RESOURCE ${SRC_MAIDSAFE}/resources/app_icon.rc)
  # source_group("Auto Compiled\\App Icon File" FILES ${SRC_MAIDSAFE}/resources/app_icon.rc)
# endif()


#==================================================================================================#
# Define executable                                                                                #
#==================================================================================================#
include_directories("${PROJECT_SOURCE_DIR}/src")
add_executable(surefile
                  ${UI_QT_MAIN_CC}
                  ${ALL_SUREFILE_QT_UI_SOURCE_FILES}
                  ${ALL_SUREFILE_QT_UI_HEADER_FILES}
                  ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR}
                  ${RESOURCE_FILES_SUREFILE_QT_UI_RESOURCES_DIR})

# Temp - Removing backend API to bypass build errors in maidsafe_lifestuff
target_link_libraries(surefile Qt5::Core Qt5::Gui Qt5::Widgets Qt5::Quick Qt5::Qml maidsafe_surefile)
# target_link_libraries(surefile Qt5::Core Qt5::Gui Qt5::Widgets Qt5::Quick Qt5::Qml maidsafe_lifestuff maidsafe_lifestuff_manager)

if(WIN32)
  set_target_properties(surefile PROPERTIES WIN32_EXECUTABLE TRUE)
endif()

rename_outdated_built_exes()


#==================================================================================================#
# Set compiler and linker flags                                                                    #
#==================================================================================================#
include(standard_flags)
if(Cbfs_FOUND)
  add_definitions(-DCBFS_KEY=${Cbfs_KEY} -DHAVE_CBFS)
endif()

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DQT_NO_DEBUG_OUTPUT -DQT_NO_WARNING_OUTPUT -DQT_NO_DEBUG_STREAM")

if(WIN32)
  string(REGEX REPLACE "/Zm[0-9]+ " "/Zm500 " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  set_source_files_properties(${ALL_SUREFILE_QT_UI_SOURCE_FILES} PROPERTIES
                              COMPILE_FLAGS "/Yu\"${QT_PCH_HEADER}\" /FI\"${QT_PCH_HEADER}\"")
  set_source_files_properties("${SRC_MAIDSAFE}/helpers/qt_push_headers.cc" PROPERTIES
                              COMPILE_FLAGS "/Yc\"${QT_PCH_HEADER}\" /FI\"${QT_PCH_HEADER}\"")
else(UNIX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-stack-protector")
endif()

# Set Application Version
set(CPACK_PACKAGE_VERSION_MAJOR ${ApplicationVersionMajor})
set(CPACK_PACKAGE_VERSION_MINOR ${ApplicationVersionMinor})
set(CPACK_PACKAGE_VERSION_PATCH ${ApplicationVersionPatch})

set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

#==================================================================================================#
# Generate Qt .pro file                                                                            #
#==================================================================================================#

set(QtPROHelper ${CMAKE_BINARY_DIR}/surefile.pro)
file(WRITE ${QtPROHelper} "#This File is Auto-Generated. Do Not Edit Manually.")
file(APPEND ${QtPROHelper} "\nQT += qml quick widgets")
file(APPEND ${QtPROHelper} "\nTARGET = surefile")

file(APPEND ${QtPROHelper} "\n\nSOURCES += ")
set(SOURCE_FILES_COLLECTION ${UI_QT_MAIN_CC} ${ALL_SUREFILE_QT_UI_SOURCE_FILES})
foreach(SOURCE_FILE ${SOURCE_FILES_COLLECTION})
  file(APPEND ${QtPROHelper} "$$quote(${SOURCE_FILE}) ")
endforeach()

file(APPEND ${QtPROHelper} "\n\nHEADERS += ")
foreach(HEADER_FILE ${ALL_SUREFILE_QT_UI_HEADER_FILES})
  file(APPEND ${QtPROHelper} "$$quote(${HEADER_FILE}) ")
endforeach()

file(APPEND ${QtPROHelper} "\n\nRESOURCES += $$quote(${SRC_MAIDSAFE}/main_resource.qrc)")

if(WIN32)
  get_dependencies(maidsafe_lifestuff OptimizedDependencies DebugDependencies ON)
  get_target_property(ReleaseLocation maidsafe_lifestuff LOCATION_RELEASE)
  get_target_property(DebugLocation maidsafe_lifestuff LOCATION_DEBUG)
  list(INSERT OptimizedDependencies 0 "\"${ReleaseLocation}\"")
  list(INSERT DebugDependencies 0 "\"${DebugLocation}\"")
  file(APPEND ${QtPROHelper} "\n\n*:CONFIG(release, debug|release): LIBS += ")
  foreach(OptimizedDependency ${OptimizedDependencies})
    file(APPEND ${QtPROHelper} "$$quote(${OptimizedDependency}) ")
  endforeach()
  file(APPEND ${QtPROHelper} "\nelse:*:CONFIG(debug, debug|release): LIBS += ")
  foreach(DebugDependency ${DebugDependencies})
    file(APPEND ${QtPROHelper} "$$quote(${DebugDependency}) ")
  endforeach()
  file(APPEND ${QtPROHelper} "\n\nINCLUDEPATH += $$quote(${maidsafe_SOURCE_DIR}/src/lifestuff/include)")
endif()

file(APPEND ${QtPROHelper} "\n\nINCLUDEPATH += $$quote(${PROJECT_SOURCE_DIR}/src)")

file(APPEND ${QtPROHelper} "\n\nOTHER_FILES += ")
foreach(VIEW_FILE ${UI_FILES_SUREFILE_QT_UI_VIEWS_DIR})
  file(APPEND ${QtPROHelper} "$$quote(${VIEW_FILE}) ")
endforeach()


#==================================================================================================#
# Tests                                                                                            #
#==================================================================================================#
if(MaidsafeTesting)
  add_style_test()
endif()
