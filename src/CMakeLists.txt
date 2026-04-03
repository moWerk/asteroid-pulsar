add_library(asteroid-pulsar main.cpp resources.qrc)
set_target_properties(asteroid-pulsar PROPERTIES PREFIX "")

target_link_libraries(asteroid-pulsar PUBLIC
    AsteroidApp)

install(TARGETS asteroid-pulsar
    DESTINATION ${CMAKE_INSTALL_LIBDIR})
