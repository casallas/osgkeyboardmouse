# Minimal OpenSourceGraph Build
# CMake cross-platform build system recipe
# 2012 Juan Sebastian Casallas
#
# Based on vrjuggler-osgnav-example by:
# 2009 Ryan Pavlik <rpavlik@iastate.edu>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

cmake_minimum_required(VERSION 2.6)

# Set package properties
project(osgkeyboardmouse)

###
# CMake Modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(UseBackportedModules)
include(SearchProgramFilesForOpenSceneGraph)
include(GetDirectoryList)

###
# Dependencies

# OpenSceneGraph
find_package(OpenSceneGraph REQUIRED COMPONENTS osgUtil osgDB osgGA osgFX osgViewer)
include_directories(${OPENSCENEGRAPH_INCLUDE_DIRS})
get_directory_list(OPENSCENEGRAPH_RUNTIME_LIBRARY_DIRS ${OPENSCENEGRAPH_LIBRARIES})
list(APPEND RUNTIME_LIBRARY_DIRS ${OPENSCENEGRAPH_RUNTIME_LIBRARY_DIRS})
if(WIN32)
	list(APPEND RUNTIME_LIBRARY_DIRS ${OPENSCENEGRAPH_RUNTIME_LIBRARY_DIRS}/../bin)
endif()

###
# Build the project
###
set(SOURCES
	osgkeyboardmouse.cpp)

add_executable(osgkeyboardmouse ${SOURCES})

target_link_libraries(osgkeyboardmouse
	${OPENSCENEGRAPH_LIBRARIES}
)
