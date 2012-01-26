# - try to find VRJuggler 3.1-related packages (main finder)
#  VRJUGGLER31_LIBRARY_DIRS, library search paths
#  VRJUGGLER31_INCLUDE_DIRS, include search paths
#  VRJUGGLER31_LIBRARIES, the libraries to link against
#  VRJUGGLER31_ENVIRONMENT
#  VRJUGGLER31_RUNTIME_LIBRARY_DIRS
#  VRJUGGLER31_CXX_FLAGS
#  VRJUGGLER31_DEFINITIONS
#  VRJUGGLER31_FOUND, If false, do not try to use VR Juggler 3.1.
#
# Components available to search for (uses "VRJOGL31" by default):
#  VRJOGL31
#  VRJ31
#  Gadgeteer21
#  JCCL15
#  VPR23
#  Sonix15
#  Tweek15
#
# Additionally, a full setup requires these packages and their Find_.cmake scripts
#  CPPDOM
#  GMTL
#
# Optionally uses Flagpoll (and FindFlagpoll.cmake)
#
# Notes on components:
#  - All components automatically include their dependencies.
#  - You can search for the name above with or without the version suffix.
#  - If you do not specify a component, VRJOGL31(the OpenGL view manager)
#    will be used by default.
#  - Capitalization of component names does not matter, but it's best to
#    pretend it does and use the above capitalization.
#  - Since this script calls find_package for your requested components and
#    their dependencies, you can use any of the variables specified in those
#    files in addition to the "summary" ones listed here, for more finely
#    controlled building and linking.
#
# This CMake script requires all of the Find*.cmake scripts for the
# components listed above, as it is only a "meta-script" designed to make
# using those scripts more developer-friendly.
#
# Useful configuration variables you might want to add to your cache:
#  (CAPS COMPONENT NAME)_ROOT_DIR - A directory prefix to search
#                         (a path that contains include/ as a subdirectory)
#
# The VJ_BASE_DIR environment variable is also searched (preferentially)
# when seeking any of the above components, as well as Flagpoll, CPPDOM,
# and Boost (from within VPR23), so most sane build environments should
# "just work."
#
# IMPORTANT: Note that you need to manually re-run CMake if you change
# this environment variable, because it cannot auto-detect this change
# and trigger an automatic re-run.
#
# Original Author:
# 2009-2011 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
# Updated for VR Juggler 3.0 by:
# Brandon Newendorp <brandon@newendorp.com> and Ryan Pavlik
# Updated for VR Juggler 3.1 by:
# Juan Sebastian Casallas <casallas@iastate.edu>
#
# Copyright Iowa State University 2009-2012.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include(CleanLibraryList)
include(CleanDirectoryList)
include(FindPackageMessage)

set(VRJUGGLER31_ROOT_DIR
	"${VRJUGGLER31_ROOT_DIR}"
	CACHE
	PATH
	"Additional root directory to search for VR Juggler and its dependencies.")
if(NOT VRJUGGLER31_ROOT_DIR)
	file(TO_CMAKE_PATH "$ENV{VJ_BASE_DIR}" VRJUGGLER31_ROOT_DIR)
endif()

# Default required components
if(NOT VRJuggler31_FIND_COMPONENTS)
	set(VRJuggler31_FIND_COMPONENTS vrjogl31)
endif()

if(VRJuggler31_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

set(VRJUGGLER31_SUBMODULES
	VRJ31
	VRJOGL31
	Gadgeteer21
	JCCL15
	VPR23
	Sonix15
	Tweek15)
string(TOUPPER "${VRJUGGLER31_SUBMODULES}" VRJUGGLER31_SUBMODULES_UC)
string(TOUPPER
	"${VRJuggler31_FIND_COMPONENTS}"
	VRJUGGLER31_FIND_COMPONENTS_UC)

# Turn a potentially messy components list into a nice one with versions.
set(VRJUGGLER31_REQUESTED_COMPONENTS)
foreach(VRJUGGLER31_LONG_NAME ${VRJUGGLER31_SUBMODULES_UC})
	# Look at requested components
	foreach(VRJUGGLER31_REQUEST ${VRJUGGLER31_FIND_COMPONENTS_UC})
		string(REGEX
			MATCH
			"${VRJUGGLER31_REQUEST}"
			VRJUGGLER31_MATCHING
			"${VRJUGGLER31_LONG_NAME}")
		if(VRJUGGLER31_MATCHING)
			list(APPEND
				VRJUGGLER31_REQUESTED_COMPONENTS
				${VRJUGGLER31_LONG_NAME})
			list(APPEND
				VRJUGGLER31_COMPONENTS_FOUND
				${VRJUGGLER31_LONG_NAME}_FOUND)
		endif()
	endforeach()
endforeach()

if(VRJUGGLER31_REQUESTED_COMPONENTS)
	list(REMOVE_DUPLICATES VRJUGGLER31_REQUESTED_COMPONENTS)
endif()

if(VRJUGGLER31_COMPONENTS_FOUND)
	list(REMOVE_DUPLICATES VRJUGGLER31_COMPONENTS_FOUND)
endif()

if(CMAKE_SIZEOF_VOID_P MATCHES "8")
	set(_VRJ_LIBSUFFIXES lib64 lib)
	set(_VRJ_LIBDSUFFIXES
		debug
		lib64/x86_64/debug
		lib64/debug
		lib64
		lib/x86_64/debug
		lib/debug
		lib)
	set(_VRJ_LIBDSUFFIXES_ONLY
		debug
		lib64/x86_64/debug
		lib64/debug
		lib/x86_64/debug
		lib/debug)
else()
	set(_VRJ_LIBSUFFIXES lib)
	set(_VRJ_LIBDSUFFIXES debug lib/i686/debug lib/debug lib)
	set(_VRJ_LIBDSUFFIXES_ONLY debug lib/i686/debug lib/debug)
endif()

if(NOT VRJUGGLER31_FIND_QUIETLY
	AND NOT VRJUGGLER31_FOUND
	AND NOT "${_VRJUGGLER31_SEARCH_COMPONENTS}"	STREQUAL "${VRJUGGLER31_REQUESTED_COMPONENTS}")
	message(STATUS
		"Searching for these requested VR Juggler 3.1 components and their dependencies: ${VRJUGGLER31_REQUESTED_COMPONENTS}")
endif()

# Find components
if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "VRJOGL31" AND NOT VRJOGL31_FOUND)
	find_package(VRJOGL31 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "VRJ31" AND NOT VRJ31_FOUND)
	find_package(VRJ31 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "JCCL15" AND NOT JCCL15_FOUND)
	find_package(JCCL15 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "GADGETEER21" AND NOT GADGETEER21_FOUND)
	find_package(Gadgeteer21 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "SONIX15" AND NOT SONIX15_FOUND)
	find_package(Sonix15 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "TWEEK15" AND NOT TWEEK15_FOUND)
	find_package(Tweek15 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER31_REQUESTED_COMPONENTS}" MATCHES "VPR23" AND NOT VPR23_FOUND)
	find_package(VPR23 ${_FIND_FLAGS})
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRJuggler31
	DEFAULT_MSG
	${VRJUGGLER31_COMPONENTS_FOUND})

if(VRJUGGLER31_FOUND)
	foreach(VRJUGGLER31_REQUEST ${VRJUGGLER31_REQUESTED_COMPONENTS})
		list(APPEND VRJUGGLER31_LIBRARIES ${${VRJUGGLER31_REQUEST}_LIBRARIES})
		list(APPEND
			VRJUGGLER31_INCLUDE_DIRS
			${${VRJUGGLER31_REQUEST}_INCLUDE_DIRS})
	endforeach()

	clean_library_list(VRJUGGLER31_LIBRARIES)

	clean_directory_list(VRJUGGLER31_INCLUDE_DIRS)

	set(_vjbase)
	set(_vjbaseclean)
	foreach(_lib ${VPR23_LIBRARY} ${VRJ31_LIBRARY} ${VRJOGL31_LIBRARY} ${JCCL15_LIBRARY} ${GADGETEER21_LIBRARY})
		get_filename_component(_libpath "${_lib}" PATH)
		get_filename_component(_abspath "${_libpath}/.." ABSOLUTE)
		list(APPEND _vjbase "${_abspath}")
	endforeach()

	clean_directory_list(_vjbase)

	set(_vrj31_have_base_dir NO)
	list(LENGTH _vjbase _vjbaselen)
	if("${_vjbaselen}" EQUAL 1 AND NOT VRJUGGLER31_VJ_BASE_DIR)
		list(GET _vjbase 0 VRJUGGLER31_VJ_BASE_DIR)
		mark_as_advanced(VRJUGGLER31_VJ_BASE_DIR)
		if(NOT VRJUGGLER31_VJ_BASE_DIR STREQUAL _vrj31_base_dir)
			unset(VRJUGGLER31_VJ_CFG_DIR)
		endif()
		set(_vrj31_have_base_dir YES)
	else()
		list(GET _vjbase 0 _calculated_base_dir)
		if(NOT
			"${_calculated_base_dir}"
			STREQUAL
			"${VRJUGGLER31_VJ_BASE_DIR}")
			message("It looks like you might be mixing VR Juggler versions... ${_vjbaselen} ${_vjbase}")
			message("If you are, fix your libraries then remove the VRJUGGLER31_VJ_BASE_DIR variable in CMake, then configure again")
			message("If you aren't, set the VRJUGGLER31_VJ_BASE_DIR variable to the desired VJ_BASE_DIR to use when running")
		else()
			if(NOT VRJUGGLER31_VJ_BASE_DIR STREQUAL _vrj31_base_dir)
				unset(VRJUGGLER31_VJ_CFG_DIR)
			endif()
			set(_vrj31_have_base_dir YES)
		endif()
	endif()

	set(_vrj31_base_dir "${VRJUGGLER31_VJ_BASE_DIR}")
	set(_vrj31_base_dir "${_vrj31_base_dir}" CACHE INTERNAL "" FORCE)

	if(_vrj31_have_base_dir)
		find_path(VRJUGGLER31_VJ_CFG_DIR
			standalone.jconf
			PATHS
			${VRJUGGLER31_VJ_BASE_DIR}/share/vrjuggler-3.1.6/data/configFiles
			${VRJUGGLER31_VJ_BASE_DIR}/share/vrjuggler/data/configFiles
			NO_DEFAULT_PATH)
		mark_as_advanced(VRJUGGLER31_VJ_CFG_DIR)
	endif()

	set(VRJUGGLER31_VJ_BASE_DIR
		"${VRJUGGLER31_VJ_BASE_DIR}"
		CACHE
		PATH
		"Base directory to use as VJ_BASE_DIR when running your app."
		FORCE)
	set(VRJUGGLER31_ENVIRONMENT
		"VJ_BASE_DIR=${VRJUGGLER31_VJ_BASE_DIR}"
		"JCCL_BASE_DIR=${VRJUGGLER31_VJ_BASE_DIR}"
		"SONIX_BASE_DIR=${VRJUGGLER31_VJ_BASE_DIR}"
		"TWEEK_BASE_DIR=${VRJUGGLER31_VJ_BASE_DIR}"
		"VJ_CFG_DIR=${VRJUGGLER31_VJ_CFG_DIR}")

	include(GetDirectoryList)

	get_directory_list(VRJUGGLER31_RUNTIME_LIBRARY_DIRS
		${VRJUGGLER31_LIBRARIES})
	if(WIN32)
		foreach(dir ${VRJUGGLER31_RUNTIME_LIBRARY_DIRS})
			list(APPEND VRJUGGLER31_RUNTIME_LIBRARY_DIRS "${dir}/../bin")
		endforeach()
	endif()

	if(MSVC)
		# BOOST_ALL_DYN_LINK
		set(VRJUGGLER31_DEFINITIONS
			"-DBOOST_ALL_DYN_LINK"
			"-DCPPDOM_DYN_LINK"
			"-DCPPDOM_AUTO_LINK")

		# Disable these annoying warnings
		# 4275: non dll-interface class used as base for dll-interface class
		# 4251: needs to have dll-interface to be used by clients of class
		# 4100: unused parameter
		# 4512: assignment operator could not be generated
		# 4127: (Not currently disabled) conditional expression in loop evaluates to constant

		set(VRJUGGLER31_CXX_FLAGS "/wd4275 /wd4251 /wd4100 /wd4512")
	elseif(CMAKE_COMPILER_IS_GNUCXX)
		# Silence annoying warnings about deprecated hash_map.
		set(VRJUGGLER31_CXX_FLAGS "-Wno-deprecated")

		set(VRJUGGLER31_DEFINITIONS "")
	endif()
	set(VRJUGGLER31_CXX_FLAGS
		"${VRJUGGLER31_CXX_FLAGS} ${CPPDOM_CXX_FLAGS}")

	set(_VRJUGGLER31_SEARCH_COMPONENTS
		"${VRJUGGLER31_REQUESTED_COMPONENTS}"
		CACHE
		INTERNAL
		"Requested components, used as a flag.")



	set(_plugin_dirs)
	foreach(_libdir ${VRJUGGLER31_RUNTIME_LIBRARY_DIRS})
		# Find directories of Gadgeteer plugins and drivers
		if(EXISTS "${_libdir}/gadgeteer")
			list(APPEND
				_plugin_dirs
				"${_libdir}/gadgeteer/drivers"
				"${_libdir}/gadgeteer/plugins")
		elseif(EXISTS "${_libdir}/gadgeteer-2.1")
			list(APPEND
				_plugin_dirs
				"${_libdir}/gadgeteer-2.1/drivers"
				"${_libdir}/gadgeteer-2.1/plugins")
		endif()

		# Find directories of Sonix plugins
		if(EXISTS "${_libdir}/sonix")
			list(APPEND _plugin_dirs "${_libdir}/sonix/plugins/dbg")
			list(APPEND _plugin_dirs "${_libdir}/sonix/plugins/opt")
		elseif(EXISTS "${_libdir}/sonix-1.5")
			list(APPEND _plugin_dirs "${_libdir}/sonix-1.5/plugins/dbg")
			list(APPEND _plugin_dirs "${_libdir}/sonix-1.5/plugins/opt")
		endif()

		# Find directories of JCCL plugins
		if(EXISTS "${_libdir}/jccl/plugins")
			list(APPEND _plugin_dirs "${_libdir}/jccl/plugins")
		elseif(EXISTS "${_libdir}/jccl-1.5/plugins")
			list(APPEND _plugin_dirs "${_libdir}/jccl-1.5/plugins")
		endif()

		# Find directories of VR Juggler plugins
		if(EXISTS "${_libdir}/vrjuggler/plugins")
			list(APPEND _plugin_dirs "${_libdir}/vrjuggler/plugins")
		elseif(EXISTS "${_libdir}/vrjuggler-3.1/plugins")
			list(APPEND _plugin_dirs "${_libdir}/vrjuggler-3.1/plugins")
		endif()
	endforeach()

	# Grab the actual plugins
	foreach(_libdir ${_plugin_dirs})
		if(EXISTS "${_libdir}")
			list(APPEND VRJUGGLER31_RUNTIME_LIBRARY_DIRS "${_libdir}")
			file(GLOB _plugins "${_libdir}/*${CMAKE_SHARED_LIBRARY_SUFFIX}")
			foreach(_plugin ${_plugins})
				if("${_plugin}" MATCHES "_d${CMAKE_SHARED_LIBRARY_SUFFIX}")
					list(APPEND VRJUGGLER31_BUNDLE_PLUGINS_DEBUG ${_plugin})
				else()
					list(APPEND VRJUGGLER31_BUNDLE_PLUGINS ${_plugin})
				endif()
			endforeach()
		endif()
	endforeach()

	mark_as_advanced(VRJUGGLER31_ROOT_DIR)
endif()

mark_as_advanced(VRJUGGLER31_DEFINITIONS)

function(install_vrjuggler31_data_files prefix)
	set(base "${VRJUGGLER31_VJ_CFG_DIR}/..")
	get_filename_component(base "${base}" ABSOLUTE)
	file(RELATIVE_PATH reldest "${VRJUGGLER31_VJ_BASE_DIR}" "${base}")
	if(prefix STREQUAL "" OR prefix STREQUAL "." OR prefix STREQUAL "./")
		set(DEST "${reldest}")
	else()
		set(DEST "${prefix}/${reldest}")
	endif()

	# configFiles *.jconf
	file(GLOB
		_vj_config_files
		"${base}/configFiles/*.jconf")
	install(FILES ${_vj_config_files} DESTINATION "${DEST}/configFiles/")

	# definitions *.jdef
	file(GLOB
		_vj_defs_files
		"${base}/definitions/*.jdef")
	install(FILES ${_vj_defs_files} DESTINATION "${DEST}/definitions/")

	# models *.flt
	file(GLOB
		_vj_model_files
		"${base}/models/*.flt")
	install(FILES ${_vj_model_files} DESTINATION "${DEST}/models/")

	# sounds *.wav
	file(GLOB
		_vj_sound_files
		"${base}/sounds/*.wav")
	install(FILES ${_vj_sound_files} DESTINATION "${DEST}/sounds/")

	# calibration.table - needed?
	file(GLOB
		_vj_config_files
		"${base}/configFiles/*.jconf")
	install(FILES "${base}/calibration.table" DESTINATION "${DEST}")
endfunction()

macro(_vrjuggler31_plugin_install _VAR)
	foreach(plugin ${${_VAR}})
		get_filename_component(full "${plugin}" ABSOLUTE)
		file(RELATIVE_PATH relloc "${VRJUGGLER31_VJ_BASE_DIR}" "${full}")
		set(filedest "${DEST}/${relloc}")
		get_filename_component(path "${filedest}" PATH)
		list(APPEND out "${filedest}")
		install(FILES "${full}" DESTINATION "${path}" ${ARGN})
	endforeach()
endmacro()

function(install_vrjuggler31_plugins prefix varForFilenames)
	set(DEST "${prefix}")

	set(out)
	_vrjuggler31_plugin_install(VRJUGGLER31_BUNDLE_PLUGINS)
	_vrjuggler31_plugin_install(VRJUGGLER31_BUNDLE_PLUGINS_DEBUG CONFIGURATIONS DEBUG)
	set(${varForFilenames} ${out} PARENT_SCOPE)

endfunction()

function(get_vrjuggler_bundle_sources _target_sources)
	if(APPLE)
		set(_bundledir "${VRJUGGLER31_VJ_CFG_DIR}/../bundle")
		get_filename_component(_bundledir "${_bundledir}" ABSOLUTE)

		set(_vj_base_dir .)
		set(_vj_data_dir ${vj_base_dir}/share/vrjuggler-3.1)

		# Append Mac-specific sources to source list
		set(_vj_bundle_src
			${_bundledir}/vrjuggler.icns
			${_bundledir}/vrjuggler.plist
			${_bundledir}/en.lproj/MainMenu.nib/classes.nib
			${_bundledir}/MainMenu.nib/info.nib
			${_bundledir}/MainMenu.nib/keyedobjects.nib)

		message(STATUS "vjbundlesrc: ${_vj_bundle_src}")
		set(${_target_sources}
			${${_target_sources}}
			${_vj_bundle_src}
			PARENT_SCOPE)

		# Set destination of nib files
		set_source_files_properties(${_bundledir}/MainMenu.nib/classes.nib
			${_bundledir}/MainMenu.nib/info.nib
			${_bundledir}/MainMenu.nib/keyedobjects.nib
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			Resources/en.lproj/MainMenu.nib/)

		# Set destination of Resources
		set_source_files_properties(${_bundledir}/vrjuggler.icns
			${_bundledir}/vrjuggler.plist
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			Resources/)
	endif()
endfunction()

get_filename_component(_vrjuggler31moddir
	${CMAKE_CURRENT_LIST_FILE}
	PATH)
function(fixup_vrjuggler_app_bundle
	_target
	_targetInstallDest
	_extralibs
	_libdirs)

	if(NOT VRJUGGLER31_FOUND)
		return()
	endif()


	set(PACKAGE_DIR ${_vrjuggler31moddir}/package)
	set(MACOSX_PACKAGE_DIR ${PACKAGE_DIR}/macosx)

	set(TARGET_LOCATION
		"${_targetInstallDest}/${_target}${CMAKE_EXECUTABLE_SUFFIX}")
	if(APPLE)
		set(TARGET_LOCATION "${TARGET_LOCATION}.app")
	endif()

	set_target_properties(${_target}
		PROPERTIES
		MACOSX_BUNDLE_INFO_PLIST
		${MACOSX_PACKAGE_DIR}/VRJuggler31BundleInfo.plist.in
		MACOSX_BUNDLE_ICON_FILE
		vrjuggler.icns
		MACOSX_BUNDLE_INFO_STRING
		"${PROJECT_NAME} (VR Juggler Application) version ${CPACK_PACKAGE_VERSION}, created by ${CPACK_PACKAGE_VENDOR}"
		MACOSX_BUNDLE_GUI_IDENTIFIER
		org.vrjuggler.${PROJECT_NAME}
		MACOSX_BUNDLE_SHORT_VERSION_STRING
		${CPACK_PACKAGE_VERSION}
		MACOSX_BUNDLE_BUNDLE_VERSION
		${CPACK_PACKAGE_VERSION})

	if(WIN32)
		list(APPEND _libdirs "${VRJUGGLER31_VJ_BASE_DIR}/bin")
	endif()

	set(BUNDLE_LIBS ${_extralibs})
	set(BUNDLE_LIB_DIRS "${VRJUGGLER31_VJ_BASE_DIR}" ${_libdirs})

	configure_file(${PACKAGE_DIR}/fixupbundle.cmake.in
		${CMAKE_CURRENT_BINARY_DIR}/${_target}-fixupbundle-juggler.cmake
		@ONLY)
	install(SCRIPT
		"${CMAKE_CURRENT_BINARY_DIR}/${_target}-fixupbundle-juggler.cmake")
endfunction()
