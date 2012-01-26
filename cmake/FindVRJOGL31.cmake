# - try to find VRJuggler 3.1 OpenGL library
# Requires VRJ core 3.1 (thus FindVRJ31.cmake)
# Requires OpenGL.
# Optionally uses Flagpoll and FindFlagpoll.cmake
#
# This library is a part of VR Juggler 3.1 - you probably want to use
# find_package(VRJuggler31) instead, for an easy interface to this and
# related scripts.  See FindVRJuggler31.cmake for more information.
#
#  VRJOGL31_LIBRARY_DIR, library search path
#  VRJOGL31_INCLUDE_DIRS, include search path for dependencies
#  VRJOGL31_LIBRARY, the library to link against
#  VRJOGL31_FOUND, If false, do not try to use this library.
#
# Plural versions refer to this library and its dependencies, and
# are recommended to be used instead, unless you have a good reason.
#
# Useful configuration variables you might want to add to your cache:
#  VRJOGL31_ROOT_DIR - A directory prefix to search
#                      (a path that contains include/ as a subdirectory)
#
# This script will use Flagpoll, if found, to provide hints to the location
# of this library, but does not use the compiler flags returned by Flagpoll
# directly.
#
# The VJ_BASE_DIR environment variable is also searched (preferentially)
# when searching for this component, so most sane build environments should
# "just work."  Note that you need to manually re-run CMake if you change
# this environment variable, because it cannot auto-detect this change
# and trigger an automatic re-run.
#
# Original Author:
# 2009-2012 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
# Updated for VR Juggler 3.0 by:
# Brandon Newendorp <brandon@newendorp.com>
# Updated for VR Juggler 3.1 by:
# Juan Sebastian Casallas <casallas@iastate.edu>


set(_HUMAN "VR Juggler 3.1 OpenGL Core")
set(_RELEASE_NAMES vrj_ogl-3_1 libvrj_ogl-3_1 vrj_ogl-3_1_6)
set(_DEBUG_NAMES vrj_ogl_d-3_1 libvrj_ogl_d-3_1 vrj_ogl_d-3_1_6)
set(_DIR vrjuggler-3.1)
set(_FP_PKG_NAME vrjuggler-opengl)

include(SelectLibraryConfigurations)
include(CreateImportedTarget)
include(CleanLibraryList)
include(CleanDirectoryList)

if(VRJOGL31_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Try flagpoll.
find_package(Flagpoll QUIET)

if(FLAGPOLL)
	flagpoll_get_library_dirs(${_FP_PKG_NAME} NO_DEPS)
	flagpoll_get_library_names(${_FP_PKG_NAME} NO_DEPS)
endif()

set(VRJOGL31_ROOT_DIR
	"${VRJOGL31_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for VRJOGL")
if(DEFINED VRJUGGLER31_ROOT_DIR)
	mark_as_advanced(VRJOGL31_ROOT_DIR)
endif()
if(NOT VRJOGL31_ROOT_DIR)
	set(VRJOGL31_ROOT_DIR "${VRJUGGLER31_ROOT_DIR}")
endif()

set(_ROOT_DIR "${VRJOGL31_ROOT_DIR}")

find_library(VRJOGL31_LIBRARY_RELEASE
	NAMES
	${_RELEASE_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBSUFFIXES}
	DOC
	"${_HUMAN} release library full path")

find_library(VRJOGL31_LIBRARY_DEBUG
	NAMES
	${_DEBUG_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBDSUFFIXES}
	DOC
	"${_HUMAN} debug library full path")

select_library_configurations(VRJOGL31)

# Dependency
if(NOT VRJ31_FOUND)
	find_package(VRJ31 ${_FIND_FLAGS})
endif()

if(NOT OPENGL_FOUND)
	find_package(OpenGL ${_FIND_FLAGS})
endif()

if(APPLE)
	set(VRJOGL31_AppKit_LIBRARY
		"-framework AppKit"
		CACHE
		STRING
		"AppKit framework for OSX")
	set(VRJOGL31_Cocoa_LIBRARY
		"-framework Cocoa"
		CACHE
		STRING
		"Cocoa framework for OSX")
	mark_as_advanced(VRJOGL31_AppKit_LIBRARY VRJOGL31_Cocoa_LIBRARY)
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRJOGL31
	DEFAULT_MSG
	VRJOGL31_LIBRARY
	VRJ31_FOUND
	VRJ31_LIBRARIES
	VRJ31_INCLUDE_DIRS
	OPENGL_FOUND
	OPENGL_LIBRARIES)

if(VRJOGL31_FOUND)
	set(_DEPS ${VRJ31_LIBRARIES} ${OPENGL_LIBRARIES})
	if(APPLE)
		list(APPEND
			_DEPS
			${VRJOGL31_AppKit_LIBRARY}
			${VRJOGL31_Cocoa_LIBRARY})
	endif()

	set(VRJOGL31_INCLUDE_DIRS ${VRJ31_INCLUDE_DIRS} ${OPENGL_INCLUDE_DIRS})

	if(VRJUGGLER31_CREATE_IMPORTED_TARGETS)
		create_imported_target(VRJOGL31 ${_DEPS})
	else()
		clean_library_list(VRJOGL31_LIBRARIES ${_DEPS})
	endif()

	mark_as_advanced(VRJOGL31_ROOT_DIR)
endif()

mark_as_advanced(VRJOGL31_LIBRARY_RELEASE VRJOGL31_LIBRARY_DEBUG)
