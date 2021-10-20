ExternalProject_Add(mpv
    DEPENDS
        angle-headers
        ffmpeg
        fribidi
        lcms2
        libarchive
        libass
        libdvdnav
        libdvdread
        libiconv
        libjpeg
        libpng
        luajit
        rubberband
        uchardet
        openal-soft
        mujs
        vulkan
        shaderc
        libplacebo
        spirv-cross
        vapoursynth
        libsdl2
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=both
        -Dlibmpv=true
        -Dpdf-build=enabled
        -Dlua=enabled
        -Djavascript=enabled
        -Dsdl2=enabled
        -Dlibarchive=enabled
        -Dlibbluray=enabled
        -Duchardet=enabled
        -Drubberband=enabled
        -Dlcms2=enabled
        -Dopenal=enabled
        -Dspirv-cross=enabled
        -Dvulkan=enabled
        -Dvapoursynth=enabled
        -Degl-angle=disabled
        -Ddvdnav=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

#force_rebuild_git(mpv)
force_meson_configure(mpv)
extra_step(mpv)
#cleanup(mpv install)
