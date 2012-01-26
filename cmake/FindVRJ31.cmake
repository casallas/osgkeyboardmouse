# - try to find VR Juggler 3.1 core library
# Requires JCCL 1.5, Gadgeteer 2.1, VPR 2.3, and Sonix 1.5
# (thus FindJCCL15.cmake, FindGadgeteer21.cmake, FindVPR23.cmake,
# and FindSonix15.cmake)
# Requires X11 if not on Mac or Windows.
# Optionally uses Flagpoll and FindFlagpoll.cmake
#
# This library is a part of VR Juggler 3.1 - you probably want to use
# find_package(VRJuggler31) instead, for an easy interface to this and
# related scripts.  See FindVRJuggler31.cmake for more information.
#
#  VRJ31_LIBRARY_DIR, library search path
#  VRJ31_INCLUDE_DIR, include search path
#  VRJ31_LIBRARY, the library to link against
#  VRJ31_FOUND, If false, do not try to use this library.
#
# Plural versions refer to this library and its dependencies, and
# are recommended to be used instead, unless you have a good reason.
#
# Useful configuration variables you might want to add to your cache:
#  VRJ31_ROOT_DIR - A directory prefix to search
#                   (a path that contains include/ as a subdirectory)
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
#
# Copyright Iowa State University 2009-2012.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)


set(_HUMAN "VR Juggler 3.1 Core")
set(_RELEASE_NAMES vrj-3_1 libvrj-3_1_6 vrj-3_1_6)
set(_DEBUG_NAMES vrj_d-3_1 libvrj_d-3_1_6 vrj_d-3_1_6)
set(_DIR vrjuggler-3.1.6)
set(_HEADER vrj/Kernel/Kernel.h)
set(_FP_PKG_NAME vrjuggler)

include(SelectLibraryConfigurations)
include(CreateImportedTarget)
include(CleanLibraryList)
include(CleanDirectoryList)

if(VRJ31_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Try flagpoll.
find_package(Flagpoll QUIET)

if(FLAGPOLL)
	flagpoll_get_include_dirs(${_FP_PKG_NAME} NO_DEPS)
	flagpoll_get_library_dirs(${_FP_PKG_NAME} NO_DEPS)
	flagpoll_get_extra_libs(${_FP_PKG_NAME} NO_DEPS)
endif()

set(VRJ31_ROOT_DIR
	"${VRJ31_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for VRJ")
if(DEFINED VRJUGGLER31_ROOT_DIR)
	mark_as_advanced(VRJ31_ROOT_DIR)
endif()
if(NOT VRJ31_ROOT_DIR)
	set(VRJ31_ROOT_DIR "${VRJUGGLER31_ROOT_DIR}")
endif()

set(_ROOT_DIR "${VRJ31_ROOT_DIR}")

find_path(VRJ31_INCLUDE_DIR
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

find_library(VRJ31_LIBRARY_RELEASE
	NAMES
	${_RELEASE_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBSUFFIXES}
	DOC
	"${_HUMAN} release library full path")

find_library(VRJ31_LIBRARY_DEBUG
	NAMES
	${_DEBUG_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBDSUFFIXES}
	DOC
	"${_HUMAN} debug library full path")

select_library_configurations(VRJ31)

# Dependencies
if(NOT JCCL15_FOUND)
	find_package(JCCL15 ${_FIND_FLAGS})
endif()

if(NOT GADGETEER21_FOUND)
	find_package(Gadgeteer21 ${_FIND_FLAGS})
endif()

if(NOT VPR23_FOUND)
	find_package(VPR23 ${_FIND_FLAGS})
endif()

if(NOT SONIX15_FOUND)
	find_package(Sonix15 ${_FIND_FLAGS})
endif()

if(UNIX AND NOT APPLE AND NOT WIN32)
	if(NOT X11_FOUND)
		find_package(X11 ${_FIND_FLAGS})
	endif()
	set(_CHECK_EXTRAS
		X11_FOUND
		X11_X11_LIB
		X11_ICE_LIB
		X11_SM_LIB
		X11_INCLUDE_DIR)
endif()
if(UNIX AND NOT WIN32)
	find_library(VRJ31_libm_LIBRARY m)
	mark_as_advanced(VRJ31_libm_LIBRARY)
	list(APPEND _CHECK_EXTRAS VRJ31_libm_LIBRARY)
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRJ31
	DEFAULT_MSG
	VRJ31_LIBRARY
	VRJ31_INCLUDE_DIR
	JCCL15_FOUND
	JCCL15_LIBRARIES
	JCCL15_INCLUDE_DIR
	GADGETEER21_FOUND
	GADGETEER21_LIBRARIES
	GADGETEER21_INCLUDE_DIR
	VPR23_FOUND
	VPR23_LIBRARIES
	VPR23_INCLUDE_DIR
	SONIX15_FOUND
	SONIX15_LIBRARIES
	SONIX15_INCLUDE_DIR
	${_CHECK_EXTRAS})

if(VRJ31_FOUND)
	set(_DEPS
		${JCCL15_LIBRARIES}
		${GADGETEER21_LIBRARIES}
		${VPR23_LIBRARIES}
		${SONIX15_LIBRARIES})
	if(UNIX AND NOT APPLE AND NOT WIN32)
		list(APPEND _DEPS ${X11_X11_LIB} ${X11_ICE_LIB} ${X11_SM_LIB})
	endif()
	if(UNIX AND NOT WIN32)
		list(APPEND _DEPS ${VRJ31_libm_LIBRARY})
	endif()

	set(VRJ31_INCLUDE_DIRS ${VRJ31_INCLUDE_DIR})
	list(APPEND
		VRJ31_INCLUDE_DIRS
		${JCCL15_INCLUDE_DIRS}
		${GADGETEER21_INCLUDE_DIRS}
		${VPR23_INCLUDE_DIRS}
		${SONIX15_INCLUDE_DIRS})
	clean_directory_list(VRJ31_INCLUDE_DIRS)

	if(VRJUGGLER31_CREATE_IMPORTED_TARGETS)
		create_imported_target(VRJ31 ${_DEPS})
	else()
		clean_library_list(VRJ31_LIBRARIES ${_DEPS})
	endif()

	mark_as_advanced(VRJ31_ROOT_DIR)
endif()

mark_as_advanced(VRJ31_LIBRARY_RELEASE
	VRJ31_LIBRARY_DEBUG
	VRJ31_INCLUDE_DIR)
