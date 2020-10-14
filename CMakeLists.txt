cmake_minimum_required(VERSION 3.12...3.15)

set(nfd_SOVERSION 1)
set(nfd_VERSION_MAJOR 1)
set(nfd_VERSION_MINOR 0)
set(nfd_VERSION_PATCH 0)
set(nfd_VERSION ${nfd_VERSION_MAJOR}.${nfd_VERSION_MINOR}.${nfd_VERSION_PATCH})

project(
  nfd
  VERSION ${nfd_VERSION}
  LANGUAGES C)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
	  set(CMAKE_EXPORT_PACKAGE_REGISTRY ON)
endif()

include(GNUInstallDirs)
set(nfd_TARGET_NAME                ${PROJECT_NAME})
set(nfd_CONFIG_INSTALL_DIR         "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}" CACHE INTERNAL "")
set(nfd_INCLUDE_INSTALL_DIR        "${CMAKE_INSTALL_INCLUDEDIR}")
set(nfd_TARGETS_EXPORT_NAME        "${PROJECT_NAME}Targets")
set(nfd_CMAKE_CONFIG_TEMPLATE      "cmake/${PROJECT_NAME}Config.cmake.in")
set(nfd_CMAKE_CONFIG_DIR           "${CMAKE_CURRENT_BINARY_DIR}")
set(nfd_CMAKE_VERSION_CONFIG_FILE  "${nfd_CMAKE_CONFIG_DIR}/${PROJECT_NAME}ConfigVersion.cmake")
set(nfd_CMAKE_PROJECT_CONFIG_FILE  "${nfd_CMAKE_CONFIG_DIR}/${PROJECT_NAME}Config.cmake")
set(nfd_CMAKE_PROJECT_TARGETS_FILE "${nfd_CMAKE_CONFIG_DIR}/${PROJECT_NAME}Targets.cmake")
set(nfd_INCLUDE_BUILD_DIR		   "${PROJECT_SOURCE_DIR}/include/")

add_subdirectory(src)

if(UNIX)
	find_package(PkgConfig REQUIRED)
	pkg_check_modules(GTK3 IMPORTED_TARGET any-package)
endif()

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  ${nfd_CMAKE_VERSION_CONFIG_FILE}
  VERSION ${PACKAGE_VERSION}
  COMPATIBILITY SameMajorVersion)

configure_file(${nfd_CMAKE_CONFIG_TEMPLATE}
               ${nfd_CMAKE_PROJECT_CONFIG_FILE} @ONLY)
install(DIRECTORY ${nfd_INCLUDE_BUILD_DIR}
        DESTINATION ${nfd_INCLUDE_INSTALL_DIR})
install(
  FILES ${nfd_CMAKE_PROJECT_CONFIG_FILE} ${nfd_CMAKE_VERSION_CONFIG_FILE}
  DESTINATION ${nfd_CONFIG_INSTALL_DIR})

export(PACKAGE ${PROJECT_NAME})

install(
  EXPORT ${nfd_TARGETS_EXPORT_NAME}
  NAMESPACE ${PROJECT_NAME}::
  DESTINATION ${nfd_CONFIG_INSTALL_DIR})