#==================================================================================================#
#                                                                                                  #
#  Copyright 2012 MaidSafe.net limited                                                             #
#                                                                                                  #
#  This MaidSafe Software is licensed to you under (1) the MaidSafe.net Commercial License,        #
#  version 1.0 or later, or (2) The General Public License (GPL), version 3, depending on which    #
#  licence you accepted on initial access to the Software (the "Licences").                        #
#                                                                                                  #
#  By contributing code to the MaidSafe Software, or to this project generally, you agree to be    #
#  bound by the terms of the MaidSafe Contributor Agreement, version 1.0, found in the root        #
#  directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also available   #
#  at: http://www.maidsafe.net/licenses                                                            #
#                                                                                                  #
#  Unless required by applicable law or agreed to in writing, the MaidSafe Software distributed    #
#  under the GPL Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF   #
#  ANY KIND, either express or implied.                                                            #
#                                                                                                  #
#  See the Licences for the specific language governing permissions and limitations relating to    #
#  use of the MaidSafe Software.                                                                   #
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
  file(TO_CMAKE_PATH ${MAIDSAFE_BINARY_DIR} MAIDSAFE_BINARY_DIR)
endif()

include(${MaidSafeExport})


#==================================================================================================#
#  Define Application Version.                                                                     #
#==================================================================================================#
remove_definitions(-DAPPLICATION_VERSION_MAJOR=${ApplicationVersionMajor}
                   -DAPPLICATION_VERSION_MINOR=${ApplicationVersionMinor}
                   -DAPPLICATION_VERSION_PATCH=${ApplicationVersionPatch})
set(ApplicationVersionMajor 0)
set(ApplicationVersionMinor 1)
set(ApplicationVersionPatch 002)

math(EXPR MaidsafeTesting ${ApplicationVersionMinor}%2)


#==================================================================================================#
#  Standard Setup.                                                                                 #
#==================================================================================================#
include(CTest)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include(check_licenses)
include(utils)
check_licenses()
get_target_platform()
get_target_architecture()

include(maidsafe_find_openmp)

if(WIN32)
  set(CBFS_KEY "${MAIDSAFE_BINARY_DIR}/MaidSafe-Drive-Private/eldos_licence_key.txt")
  include(maidsafe_find_cbfs)
endif()

# Set Application Version
set(CPACK_PACKAGE_VERSION_MAJOR ${ApplicationVersionMajor})
set(CPACK_PACKAGE_VERSION_MINOR ${ApplicationVersionMinor})
set(CPACK_PACKAGE_VERSION_PATCH ${ApplicationVersionPatch})

set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

#==================================================================================================#
# Qt library search                                                                                #
#==================================================================================================#
set(Qt5Required ON)
include(maidsafe_find_qt5)


#==================================================================================================#
# Set up SureFile files as GLOBs                                                                   #
#==================================================================================================#
set(SRC_SUREFILE ${PROJECT_SOURCE_DIR}/src/maidsafe/surefile)
set(SRC_SUREFILE_UI ${PROJECT_SOURCE_DIR}/src/maidsafe/surefile/ui)

# Library Files

file(GLOB SOURCE_FILES_SUREFILE_DIR "${SRC_SUREFILE}/*.cc")
file(GLOB HEADER_FILES_SUREFILE_DIR "${SRC_SUREFILE}/*.h")

include(add_protoc_command)
string(REPLACE "${CMAKE_SOURCE_DIR}/src" "" ProtoRelativeDir "${SRC_SUREFILE}")
add_protoc_command(Root "${CMAKE_SOURCE_DIR}/src" "${ProtoRelativeDir}")
source_group("Proto Files" FILES "${SRC_SUREFILE}/credentials.proto")
source_group("Auto Compiled\\Proto Files\\Header Files" FILES "${CMAKE_CURRENT_BINARY_DIR}/GeneratedProtoFiles${ProtoRelativeDir}/credentials.pb.h")
source_group("Auto Compiled\\Proto Files\\Source Files" FILES "${CMAKE_CURRENT_BINARY_DIR}/GeneratedProtoFiles${ProtoRelativeDir}/credentials.pb.cc")

set(TestFiles ${SRC_SUREFILE}/tests/surefile_test.cc)
source_group("Auto Compiled\\Qt MOC Files" FILES "${CMAKE_CURRENT_BINARY_DIR}/maidsafe_surefile_automoc.cpp")

# UI Files
set(UI_MAIN_CC ${SRC_SUREFILE_UI}/main.cc)
source_group("Auto Compiled\\Qt MOC Files" FILES "${CMAKE_CURRENT_BINARY_DIR}/surefile_automoc.cpp")

file(GLOB SOURCE_FILES_SUREFILE_UI_HELPERS_DIR ${SRC_SUREFILE_UI}/helpers/*.cc)
file(GLOB HEADER_FILES_SUREFILE_UI_HELPERS_DIR ${SRC_SUREFILE_UI}/helpers/*.h)
source_group("Helpers\\Source Files" FILES ${SOURCE_FILES_SUREFILE_UI_HELPERS_DIR})
source_group("Helpers\\Header Files" FILES ${HEADER_FILES_SUREFILE_UI_HELPERS_DIR})

set(QT_PCH_HEADER ${SRC_SUREFILE_UI}/helpers/qt_push_headers.h)
if(NOT WIN32)
  list(REMOVE_ITEM SOURCE_FILES_SUREFILE_UI_HELPERS_DIR ${SRC_SUREFILE_UI}/helpers/qt_push_headers.cc)
endif()

file(GLOB SOURCE_FILES_SUREFILE_UI_QOBJECTS_DIR "${SRC_SUREFILE_UI}/qobjects/*.cc")
file(GLOB HEADER_FILES_SUREFILE_UI_QOBJECTS_DIR "${SRC_SUREFILE_UI}/qobjects/*.h")
source_group("QObjects\\Source Files" FILES ${SOURCE_FILES_SUREFILE_UI_QOBJECTS_DIR})
source_group("QObjects\\Header Files" FILES ${HEADER_FILES_SUREFILE_UI_QOBJECTS_DIR})

QT5_ADD_RESOURCES(RESOURCE_FILES_SUREFILE_UI_RESOURCES_DIR ${SRC_SUREFILE_UI}/main_resource.qrc)
source_group("Auto Compiled\\Resource Files" FILES ${RESOURCE_FILES_SUREFILE_UI_RESOURCES_DIR})

file(GLOB UI_FILES_SUREFILE_UI_VIEWS_DIR ${SRC_SUREFILE_UI}/views/*.*
                                         ${SRC_SUREFILE_UI}/views/create_account/*.*
                                         ${SRC_SUREFILE_UI}/views/settings/*.*
                                         ${SRC_SUREFILE_UI}/views/tour/*.*)
source_group("Views" FILES ${UI_FILES_SUREFILE_UI_VIEWS_DIR})

set(ALL_SUREFILE_UI_SOURCE_FILES
      ${SOURCE_FILES_SUREFILE_UI_HELPERS_DIR}
      ${SOURCE_FILES_SUREFILE_UI_QOBJECTS_DIR})
set(ALL_SUREFILE_UI_HEADER_FILES
      ${HEADER_FILES_SUREFILE_UI_HELPERS_DIR}
      ${HEADER_FILES_SUREFILE_UI_QOBJECTS_DIR})

#==================================================================================================#
# Define localisation files                                                                        #
#==================================================================================================#
file(GLOB COMPILED_LOCALISATION_FILES ${SRC_SUREFILE_UI}/resources/translations/*.ts)
if(UPDATE_LOCALISATION_RESOURCES)
  SET(LOCALISATION_LANGUAGES en fr es)
  SET(LOCALISATION_SOURCES
        ${SOURCE_FILES_SUREFILE_UI_HELPERS_DIR}
        ${SOURCE_FILES_SUREFILE_UI_QOBJECTS_DIR}
        ${UI_FILES_SUREFILE_UI_VIEWS_DIR})
  SET(LOCALISATION_TS_FILES)
  execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/Translation_Sources)
  file(COPY ${COMPILED_LOCALISATION_FILES} DESTINATION ${CMAKE_BINARY_DIR}/Translation_Sources)
  foreach(LANGUAGE ${LOCALISATION_LANGUAGES})
    SET(LOCALISATION_TS_FILES ${LOCALISATION_TS_FILES} ${CMAKE_BINARY_DIR}/Translation_Sources/${LANGUAGE}.ts)
  endforeach()
  QT5_CREATE_TRANSLATION(LOCALISATION_QM_FILES ${LOCALISATION_SOURCES} ${LOCALISATION_TS_FILES})
  message(STATUS "NOTE: Translation Source Update Configured")
  message(STATUS "      Make Sure to Post-Build Transfer ${CMAKE_BINARY_DIR}/Translation_Sources")
  message(STATUS "                                  -->  ${SRC_SUREFILE_UI}/resources/translations")
  message(STATUS "      Do not do a Clean Build with UPDATE_LOCALISATION_RESOURCES=ON")
else()
  QT5_ADD_TRANSLATION(LOCALISATION_QM_FILES ${COMPILED_LOCALISATION_FILES})
endif()
unset(UPDATE_LOCALISATION_RESOURCES CACHE)
source_group("Auto Compiled\\Localisation Files" FILES ${LOCALISATION_QM_FILES})

#####    Set Application Icon    ####
if(WIN32)
  set(SUREFILE_UI_APP_ICON_RESOURCE ${SRC_SUREFILE_UI}/app_icon.rc)
  source_group("Auto Compiled\\App Icon File" FILES ${SUREFILE_UI_APP_ICON_RESOURCE})
endif()


#==================================================================================================#
# Define executable                                                                                #
#==================================================================================================#
include_directories("${PROJECT_SOURCE_DIR}/src")

add_library(maidsafe_surefile STATIC ${SOURCE_FILES_SUREFILE_DIR} ${HEADER_FILES_SUREFILE_DIR} ${RootProtos})
target_link_libraries(maidsafe_surefile maidsafe_drive ${BoostLocaleLibs})
set_target_properties(maidsafe_surefile PROPERTIES FOLDER "Library")

if(MaidsafeTesting)
  add_executable(test_surefile ${TestFiles})
  target_link_libraries(test_surefile maidsafe_surefile)
  set_target_properties(test_surefile PROPERTIES FOLDER "Tests")
endif()

add_executable(surefile ${UI_MAIN_CC}
                        ${ALL_SUREFILE_UI_SOURCE_FILES}
                        ${ALL_SUREFILE_UI_HEADER_FILES}
                        ${UI_FILES_SUREFILE_UI_VIEWS_DIR}
                        ${RESOURCE_FILES_SUREFILE_UI_RESOURCES_DIR}
                        ${SUREFILE_UI_APP_ICON_RESOURCE})

target_link_libraries(surefile Qt5::Core Qt5::Gui Qt5::Widgets Qt5::Quick Qt5::Qml maidsafe_surefile)

if(WIN32)
  set_target_properties(surefile PROPERTIES WIN32_EXECUTABLE TRUE)
elseif(APPLE)
  set_target_properties(surefile PROPERTIES MACOSX_BUNDLE TRUE FOLDER "Executables")

  execute_process(COMMAND mkdir -p ${CMAKE_BINARY_DIR}/SureFile.app/Contents/Resources)
  execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/installer/shared/icons/osx/app_icon.icns ${CMAKE_BINARY_DIR}/SureFile.app/Contents/Resources/)
  execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/installer/shared/eula.txt ${CMAKE_BINARY_DIR}/SureFile.app/Contents/Resources/)

  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_BUNDLE_NAME SureFile)
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_GUI_IDENTIFIER "SureFile")
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_ICON_FILE app_icon.icns)
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_INFO_STRING "${CPACK_PACKAGE_VERSION}, Copyright 2013 MaidSafe")
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_SHORT_VERSION_STRING "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}")
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_LONG_VERSION_STRING "${CPACK_PACKAGE_VERSION}")
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_BUNDLE_VERSION "${CPACK_PACKAGE_VERSION}")
  set_target_properties(surefile PROPERTIES  MACOSX_BUNDLE_COPYRIGHT "(C) 2013 MaidSafe")
endif()

rename_outdated_built_exes()


#==================================================================================================#
# Set compiler and linker flags                                                                    #
#==================================================================================================#
include(standard_flags)
remove_definitions(-DAPPLICATION_NAME=LifeStuff)
add_definitions(-DAPPLICATION_NAME=SureFile
                -DAPPLICATION_VERSION_MAJOR=${ApplicationVersionMajor}
                -DAPPLICATION_VERSION_MINOR=${ApplicationVersionMinor}
                -DAPPLICATION_VERSION_PATCH=${ApplicationVersionPatch})
if(Cbfs_FOUND)
  add_definitions(-DCBFS_KEY=${Cbfs_KEY} -DHAVE_CBFS)
endif()

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DQT_NO_DEBUG_OUTPUT -DQT_NO_WARNING_OUTPUT -DQT_NO_DEBUG_STREAM")

if(WIN32)
  string(REGEX REPLACE "/Zm[0-9]+ " "/Zm500 " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  set_source_files_properties(${ALL_SUREFILE_UI_SOURCE_FILES} PROPERTIES
                              COMPILE_FLAGS "/Yu\"${QT_PCH_HEADER}\" /FI\"${QT_PCH_HEADER}\"")
  set_source_files_properties("${SRC_SUREFILE_UI}/helpers/qt_push_headers.cc" PROPERTIES
                              COMPILE_FLAGS "/Yc\"${QT_PCH_HEADER}\" /FI\"${QT_PCH_HEADER}\"")
else(UNIX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-stack-protector")
endif()


#==================================================================================================#
# Generate Qt .pro file                                                                            #
#==================================================================================================#

set(QtPROHelper ${CMAKE_BINARY_DIR}/surefile.pro)
file(WRITE ${QtPROHelper} "#This File is Auto-Generated. Do Not Edit Manually.")
file(APPEND ${QtPROHelper} "\nQT += qml quick widgets")
file(APPEND ${QtPROHelper} "\nTARGET = surefile")

file(APPEND ${QtPROHelper} "\n\nSOURCES += ")
set(SOURCE_FILES_COLLECTION ${UI_MAIN_CC} ${ALL_SUREFILE_UI_SOURCE_FILES})
foreach(SOURCE_FILE ${SOURCE_FILES_COLLECTION})
  file(APPEND ${QtPROHelper} "$$quote(${SOURCE_FILE}) ")
endforeach()

file(APPEND ${QtPROHelper} "\n\nHEADERS += ")
foreach(HEADER_FILE ${ALL_SUREFILE_UI_HEADER_FILES})
  file(APPEND ${QtPROHelper} "$$quote(${HEADER_FILE}) ")
endforeach()

file(APPEND ${QtPROHelper} "\n\nRESOURCES += $$quote(${SRC_SUREFILE_UI}/main_resource.qrc)")

if(WIN32)
  get_dependencies(maidsafe_surefile OptimizedDependencies DebugDependencies ON)
  get_target_property(ReleaseLocation maidsafe_surefile LOCATION_RELEASE)
  get_target_property(DebugLocation maidsafe_surefile LOCATION_DEBUG)
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
endif()

file(APPEND ${QtPROHelper} "\n\nINCLUDEPATH += $$quote(${PROJECT_SOURCE_DIR}/src)")

file(APPEND ${QtPROHelper} "\n\nOTHER_FILES += ")
foreach(VIEW_FILE ${UI_FILES_SUREFILE_UI_VIEWS_DIR})
  file(APPEND ${QtPROHelper} "$$quote(${VIEW_FILE}) ")
endforeach()


#==================================================================================================#
# Tests                                                                                            #
#==================================================================================================#
if(MaidsafeTesting)
  add_style_test()
  include(add_catch_tests)
  add_catch_tests(test_surefile)
  test_summary_output()
endif()


###################################################################################################
# Installer                                                                                       #
###################################################################################################
if(${PACKAGE_BUILD})
  set(CBFS_APPLICATION_KEY "MaidSafe-SureFile")
  add_definitions(-DCBFS_APPLICATION_KEY=${CBFS_APPLICATION_KEY})
  include(surefile_package.cmake)
  include(CPack)
endif()
