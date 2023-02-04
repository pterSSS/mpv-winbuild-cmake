ExternalProject_Add(vs-placebo
    DEPENDS
        vapoursynth
        libzimg
        libplacebo
        libdovi
    GIT_REPOSITORY https://github.com/Lypheo/vs-placebo.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(vs-placebo strip-dll
    DEPENDEES install
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s ${MINGW_INSTALL_PREFIX}/lib/vapoursynth/libvs_placebo.dll
    COMMENT "Stripping vs-placebo dll"
)

force_rebuild_git(vs-placebo)
force_meson_configure(vs-placebo)
cleanup(vs-placebo strip-dll)
