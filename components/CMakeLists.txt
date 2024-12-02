cmake_minimum_required(VERSION 3.5)

project(
  components
  VERSION 0.1
  LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Widgets)
find_package(Qt6 REQUIRED COMPONENTS StateMachine) 

file(GLOB THELIB "lib/*")
file(GLOB LAYOUT "layouts/*")
file(GLOB COMPONENTSHEADER "*.h")
file(GLOB COMPONENTSSOURCE "*.cpp")
set(RCC_FILES resources.qrc)
add_library(${PROJECT_NAME} STATIC ${THELIB} ${LAYOUT} ${COMPONENTSHEADER}
                                   ${COMPONENTSSOURCE} ${RCC_FILES})
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Core Qt6::Widgets Qt6::StateMachine)

target_link_directories(${PROJECT_NAME} PUBLIC .)