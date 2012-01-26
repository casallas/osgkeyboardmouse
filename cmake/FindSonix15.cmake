# - try to find Sonix 1.5 library
# Requires VPR 2.3 and GMTL (thus FindVPR23.cmake and FindGMTL.cmake)
# Optionally uses Flagpoll and FindFlagpoll.cmake
#
# This library is a part of VR Juggler 3.1 - you probably want to use
# find_package(VRJuggler3.1) instead, for an easy interface to this and
# related scripts.  See FindVRJuggler31.cmake for more information.
#
#  SONIX15_LIBRARY_DIR, library search path
#  SONIX15_INCLUDE_DIR, include search path
#  SONIX15_LIBRARY, the library to link against
#  SONIX15_FOUND, If false, do not try to use this library.
#
# Plural versions refer to this library and its dependencies, and
# are recommended to be used instead, unless you have a good reason.
#
# Useful configuration variables you might want to add to your cache:
#  SONIX15_ROOT_DIR - A directory prefix to search
#                     (a path that contains include/ as a subdirectory)
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
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
# Updated for VR Juggler 3.0 by:
# Brandon Newendorp <brandon@newendorp.com>
# Updated for VR Juggler 3.1 by:
# Juan Sebastian Casallas <casallas@iastate.edu>


set(_HUMAN "Sonix 1.5")
set(_RELEASE_NAMES sonix-1_5 libsonix-1_5_1 sonix-1_5_1)
set(_DEBUG_NAMES sonix_d-1_5 libsonix_d-1_5_1 sonix_d-1_5_1)
set(_DIR sonix-1.5.1)
set(_HEADER snx/sonix.h)
set(_FP_PKG_NAME sonix)

include(SelectLibraryConfigurations)
include(CreateImportedTarget)
include(CleanLibraryList)
include(CleanDirectoryList)

if(SONIX15_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Try flagpoll.
find_package(Flagpoll QUIET)

if(FLAGPOLL)
	flagpoll_get_include_dirs(${_FP_PKG_NAME} NO_DEPS)
	flagpoll_get_library_dirs(${_FP_PKG_NAME} NO_DEPS)
endif()

set(SONIX15_ROOT_DIR
	"${SONIX15_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for Sonix")
if(DEFINED VRJUGGLER31_ROOT_DIR)
	mark_as_advanced(SONIX15_ROOT_DIR)
endif()
if(NOT SONIX15_ROOT_DIR)
	set(SONIX15_ROOT_DIR "${VRJUGGLER31_ROOT_DIR}")
endif()

set(_ROOT_DIR "${SONIX15_ROOT_DIR}")

find_path(SONIX15_INCLUDE_DIR
	${_HEADER}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_INCLUDE_DIRS}
	PATH_SUFFIXES
	${_DIR}
	include/${_DIR}
	include/
	DOC
	"Path to ${_HUMAN} includes root")

find_library(SONIX15_LIBRARY_RELEASE
	NAMES
	${_RELEASE_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBSUFFIXES}
	DOC
	"${_HUMAN} release library full path")

find_library(SONIX15_LIBRARY_DEBUG
	NAMES
	${_DEBUG_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBDSUFFIXES}
	DOC
	"${_HUMAN} debug library full path")

select_library_configurations(SONIX15)

# Dependencies
if(NOT VPR23_FOUND)
	find_package(VPR23 ${_FIND_FLAGS})
endif()

if(NOT GMTL_FOUND)
	find_package(GMTL ${_FIND_FLAGS})
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SONIX15
	DEFAULT_MSG
	SONIX15_LIBRARY
	SONIX15_INCLUDE_DIR
	VPR23_FOUND
	VPR23_LIBRARIES
	VPR23_INCLUDE_DIR
	GMTL_FOUND
	GMTL_INCLUDE_DIR)

if(SONIX15_FOUND)
	set(_DEPS ${VPR23_LIBRARIES})

	set(SONIX15_INCLUDE_DIRS ${SONIX15_INCLUDE_DIR})
	list(APPEND
		SONIX15_INCLUDE_DIRS
		${VPR23_INCLUDE_DIRS}
		${GMTL_INCLUDE_DIRS})

	clean_directory_list(SONIX15_INCLUDE_DIRS)

	if(VRJUGGLER31_CREATE_IMPORTED_TARGETS)
		create_imported_target(SONIX15 ${_DEPS})
	else()
		clean_library_list(SONIX15_LIBRARIES ${_DEPS})
	endif()

	mark_as_advanced(SONIX15_ROOT_DIR)
endif()

mark_as_advanced(SONIX15_LIBRARY_RELEASE
	SONIX15_LIBRARY_DEBUG
	SONIX15_INCLUDE_DIR)
