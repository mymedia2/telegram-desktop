QT += core

CONFIG(debug, debug|release) {
    DEFINES += _DEBUG
    OBJECTS_DIR = ./../DebugIntermediateLang
    MOC_DIR = ./GeneratedFiles/Debug
    DESTDIR = ./../DebugLang
    OUTPUT = ../DebugIntermediate/GeneratedFiles
}
CONFIG(release, debug|release) {
    OBJECTS_DIR = ./../ReleaseIntermediateLang
    MOC_DIR = ./GeneratedFiles/Release
    DESTDIR = ./../ReleaseLang
    OUTPUT = ../ReleaseIntermediate/GeneratedFiles
}

CONFIG += plugin static c++11

macx {
    QMAKE_INFO_PLIST = ./SourceFiles/_other/Lang.plist
    QMAKE_LFLAGS += -framework Cocoa
}

SOURCES += \
    ./SourceFiles/_other/mlmain.cpp \
    ./SourceFiles/_other/genlang.cpp \

HEADERS += \
    ./SourceFiles/_other/mlmain.h \
    ./SourceFiles/_other/genlang.h \

INCLUDEPATH += "/usr/include/$$(DEB_HOST_MULTIARCH)/qt5/QtGui/$$[QT_VERSION]/QtGui" \
               "/usr/include/$$(DEB_HOST_MULTIARCH)/qt5/QtCore/$$[QT_VERSION]/QtCore" \
               "/usr/include/$$(DEB_HOST_MULTIARCH)/qt5"

QMAKE_POST_LINK = $$DESTDIR/$$TARGET -lang_in ../../Telegram/Resources/langs/lang.strings -lang_out $$OUTPUT/lang_auto
