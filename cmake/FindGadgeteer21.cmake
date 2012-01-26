# - try to find Gadgeteer 2.1 library
# Requires JCCL 1.5 and VPR 2.3 (thus FindJCCL15.cmake and FindVPR23.cmake)
# Requires X11 if not on Mac or Windows.
# Optionally uses Flagpoll and FindFlagpoll.cmake
#
# This library is a part of VR Juggler 3.1 - you probably want to use
# find_package(VRJuggler31) instead, for an easy interface to this and
# related scripts.  See FindVRJuggler31.cmake for more information.
#
#  GADGETEER21_LIBRARY_DIR, library search path
#  GADGETEER21_INCLUDE_DIR, include search path
#  GADGETEER21_LIBRARY, the library to link against
#  GADGETEER21_FOUND, If false, do not try to use this library.
#
# Plural versions refer to this library and its dependencies, and
# are recommended to be used instead, unless you have a good reason.
#
# Useful configuration variables you might want to add to your cache:
#  GADGETEER21_ROOT_DIR - A directory prefix to search
#                         (a path that contains include/ as a subdirectory)
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

set(_HUMAN "Gadgeteer 2.1")
set(_RELEASE_NAMES gadget-2_1 libgadget-2_1_27 gadget-2_1_27)
set(_DEBUG_NAMES gadget_d-2_1 libgadget_d-2_1_27 gadget_d-2_1_27)
set(_DIR gadgeteer-2.1.27)
set(_HEADER gadget/gadgetConfig.h)
set(_FP_PKG_NAME gadgeteer)

include(SelectLibraryConfigurations)
include(CreateImportedTarget)
include(CleanLibraryList)
include(CleanDirectoryList)

if(GADGETEER21_FIND_QUIETLY)
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

set(GADGETEER21_ROOT_DIR
	"${GADGETEER21_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for Gadgeteer")
if(DEFINED VRJUGGLER31_ROOT_DIR)
	mark_as_advanced(GADGETEER21_ROOT_DIR)
endif()
if(NOT GADGETEER21_ROOT_DIR)
	set(GADGETEER21_ROOT_DIR "${VRJUGGLER31_ROOT_DIR}")
endif()

set(_ROOT_DIR "${GADGETEER21_ROOT_DIR}")

find_path(GADGETEER21_INCLUDE_DIR
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

find_library(GADGETEER21_LIBRARY_RELEASE
	NAMES
	${_RELEASE_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBSUFFIXES}
	DOC
	"${_HUMAN} release library full path")

find_library(GADGETEER21_LIBRARY_DEBUG
	NAMES
	${_DEBUG_NAMES}
	HINTS
	"${_ROOT_DIR}"
	${${_FP_PKG_NAME}_FLAGPOLL_LIBRARY_DIRS}
	PATH_SUFFIXES
	${_VRJ_LIBDSUFFIXES}
	DOC
	"${_HUMAN} debug library full path")

select_library_configurations(GADGETEER21)

# Dependencies
foreach(package JCCL15 VPR23 GMTL)
	if(NOT ${PACKAGE}_FOUND)
		find_package(${package} ${_FIND_FLAGS})
	endif()
endforeach()

if(UNIX AND NOT APPLE AND NOT WIN32)
	# We need X11 if not on Mac or Windows
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

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GADGETEER21
	DEFAULT_MSG
	GADGETEER21_LIBRARY
	GADGETEER21_INCLUDE_DIR
	JCCL15_FOUND
	JCCL15_LIBRARIES
	JCCL15_INCLUDE_DIR
	VPR23_FOUND
	VPR23_LIBRARIES
	VPR23_INCLUDE_DIR
	GMTL_FOUND
	GMTL_INCLUDE_DIR
	${_CHECK_EXTRAS})

if(GADGETEER21_FOUND)
	set(_DEPS ${JCCL15_LIBRARIES} ${VPR23_LIBRARIES})

	set(GADGETEER21_INCLUDE_DIRS ${GADGETEER21_INCLUDE_DIR})
	list(APPEND
		GADGETEER21_INCLUDE_DIRS
		${JCCL15_INCLUDE_DIRS}
		${VPR23_INCLUDE_DIRS}
		${GMTL_INCLUDE_DIRS})

	if(UNIX AND NOT APPLE AND NOT WIN32)
		# We need X11 if not on Mac or Windows
		list(APPEND _DEPS ${X11_X11_LIB} ${X11_ICE_LIB} ${X11_SM_LIB})
		list(APPEND GADGETEER21_INCLUDE_DIRS ${X11_INCLUDE_DIR})
	endif()

	clean_directory_list(GADGETEER21_INCLUDE_DIRS)

	if(VRJUGGLER31_CREATE_IMPORTED_TARGETS)
		create_imported_target(GADGETEER21 ${_DEPS})
	else()
		clean_library_list(GADGETEER21_LIBRARIES ${_DEPS})
	endif()

	mark_as_advanced(GADGETEER21_ROOT_DIR)
endif()

mark_as_advanced(GADGETEER21_LIBRARY_RELEASE
	GADGETEER21_LIBRARY_DEBUG
	GADGETEER21_INCLUDE_DIR)
