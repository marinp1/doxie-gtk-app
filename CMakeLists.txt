    project (com.github.marinp1.gtk-doxie-app)

    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.marinp1.gtk-doxie-app")

    set (EXEC_NAME "com.github.marinp1.gtk-doxie-app")
    set (RELEASE_NAME "Dalmatian")
    set (VERSION "0.1")
    set (VERSION_INFO "UI demo")

    set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")

    # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED
      granite
      json-glib-1.0
      gtk+-3.0
      libsoup-2.4
      gssdp-1.0
    )

    add_definitions(${DEPS_CFLAGS})
    add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

    link_directories(${DEPS_LIBRARY_DIRS})
    link_libraries(${DEPS_LIBRARIES})

    add_subdirectory (po)

    # make sure we have vala
    find_package(Vala REQUIRED)
    include(ValaVersion)
    ensure_vala_version("0.16" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/Application.vala
        src/Variables.vala
        src/Objects/DoxieScanner.vala
        src/Objects/Thumbnail.vala
        src/Widgets/ActionBar.vala
        src/Widgets/CustomHeader.vala
        src/Widgets/ScanHolder.vala

    # tell what libraries to use when compiling
    PACKAGES
        gtk+-3.0
        granite
        json-glib-1.0
        libsoup-2.4
        gssdp-1.0
    )

    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

    # install our .desktop file so the Applications menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.marinp1.gtk-doxie-app.desktop DESTINATION ${DATADIR}/applications/)

    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.marinp1.gtk-doxie-app.appdata.xml DESTINATION ${DATADIR}/metainfo/)