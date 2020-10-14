file(GLOB_RECURSE HEADER_LIST CONFIGURE_DEPENDS ${nfd_SOURCE_DIR}/include/*.h)

add_library(nfd nfd_common.c ${HEADER_LIST})
set_target_properties(nfd PROPERTIES POSITION_INDEPENDENT_CODE 1)
set_target_properties(nfd PROPERTIES SOVERSION ${nfd_SOVERSION})
add_library(nfd::nfd ALIAS nfd)

target_include_directories(
  nfd
  PUBLIC $<BUILD_INTERFACE:${nfd_INCLUDE_BUILD_DIR}>
		 $<INSTALL_INTERFACE:include>)

if(UNIX AND NOT APPLE)
	if(GTK3_FOUND)
		target_link_libraries(nfd PUBLIC PkgConfig::GTK3)
		target_sources(nfd PRIVATE nfd_gtk.c)
	else()
		target_sources(nfd PRIVATE nfd_zenity.c)
	endif()
elseif(APPLE)
	target_sources(nfd PRIVATE nfd_cocoa.m)
elseif(WIN32)
	enable_language(CXX)
	target_sources(nfd PRIVATE nfd_win.cpp)
endif()

export(
  TARGETS ${nfd_TARGET_NAME}
  NAMESPACE ${PROJECT_NAME}::
  FILE ${nfd_CMAKE_PROJECT_TARGETS_FILE})
install(
  TARGETS ${nfd_TARGET_NAME}
  EXPORT ${nfd_TARGETS_EXPORT_NAME}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${nfd_INCLUDE_INSTALL_DIR})
