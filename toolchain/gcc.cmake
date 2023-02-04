if(${TARGET_CPU} MATCHES "x86_64")
    set(arch "${GCC_ARCH}")
else()
    set(arch "i686")
endif()

ExternalProject_Add(gcc
    DEPENDS
        mingw-w64-headers
    URL https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.1.0/gcc-13.1.0.tar.xz
    URL_HASH SHA512=6cf06dfc48f57f5e67f7efe3248019329a14d690c728d9f2f7ef5fa0d58f1816f309586ba7ea2eac20d0b60a2d1b701f68392e9067dd46f827ba0efd7192db33
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=54412
    PATCH_COMMAND ${EXEC} curl -sL https://gist.githubusercontent.com/quietvoid/1e540f92a6b9d107b03af90b07cf06a2/raw/6dbb64f1810e3ef339e85be12add988c9410085b/vmov-alignment.patch | patch -p2
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --libdir=${CMAKE_INSTALL_PREFIX}/lib
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --disable-multilib
        --enable-languages=c,c++
        --disable-nls
        --disable-shared
        --disable-win32-registry
        --with-arch=${arch}
        --with-tune=generic
        --enable-threads=posix
        --without-included-gettext
        --enable-lto
        --enable-checking=release
        --disable-sjlj-exceptions
    BUILD_COMMAND make -j${MAKEJOBS} all-gcc
    INSTALL_COMMAND make install-strip-gcc
    STEP_TARGETS download install
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(gcc final
    DEPENDS
        mingw-w64-crt
        winpthreads
        gendef
        rustup
    COMMAND ${MAKE}
    COMMAND ${MAKE} install-strip
    WORKING_DIRECTORY <BINARY_DIR>
    LOG 1
)

ExternalProject_Add_Step(gcc symlink-eh
    DEPENDEES final

    COMMAND ${EXEC} ln -vs ${CMAKE_INSTALL_PREFIX}/lib/gcc/${TARGET_ARCH}/13.1.0/libgcc.a ${CMAKE_INSTALL_PREFIX}/lib/gcc/${TARGET_ARCH}/13.1.0/libgcc_eh.a
    LOG 1
)

cleanup(gcc symlink-eh)
