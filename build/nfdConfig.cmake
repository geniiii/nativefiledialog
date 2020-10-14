include(CMakeFindDependencyMacro)

include(FindPackageHandleStandardArgs)
set(${CMAKE_FIND_PACKAGE_NAME}_CONFIG ${CMAKE_CURRENT_LIST_FILE})
find_package_handle_standard_args(nfd CONFIG_MODE)

if(NOT TARGET nfd::nfd)
    include("${CMAKE_CURRENT_LIST_DIR}/nfdTargets.cmake")
    if(NOT TARGET nfd)
        add_library(nfd IMPORTED)
        set_target_properties(nfd PROPERTIES
            INTERFACE_LINK_LIBRARIES nfd::nfd
        )
    endif()
endif()
