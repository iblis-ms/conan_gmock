# Author: Marcin Serwach
# https://github.com/iblis-ms/conan_gbenchmark

from conans import ConanFile, CMake, tools
from conans.model.settings import Settings
from conans.model.settings import SettingsItem
from conans.tools import get
import os
import sys

class GMockConan(ConanFile):
    name = 'GMock'
    version = '1.8.0'
    license = 'MIT LIcence'
    url = 'https://github.com/iblis-ms/conan_gbenchmark/tree/development'
    description = 'Conan.io support for Google Mock'
    settings = ['os', 'compiler', 'build_type', 'arch']
    options = {
        'BUILD_SHARED_LIBS':            [True, False], 
        'gmock_build_tests':            [True, False],
        'gtest_build_tests':            [True, False],
        'gtest_build_samples':          [True, False],
        'gtest_disable_pthreads':       [True, False],
        'gtest_hide_internal_symbols':  [True, False],
        'include_main':                 [True, False],
        'BUILD_GTEST':                  [True, False],
        'BUILD_GMOCK':                  [True, False],
    }
    default_options = ('BUILD_SHARED_LIBS=False',
                       'gmock_build_tests=False',
                       'gtest_build_tests=False',
                       'gtest_build_samples=False',
                       'gtest_disable_pthreads=False',
                       'gtest_hide_internal_symbols=False',
                       'include_main=True',
                       'BUILD_GTEST=False',
                       'BUILD_GMOCK=True',
                      )
    generators = 'cmake'
    source_root = 'googletest-release-%s' % version
    exports = 'CMakeLists.txt'

    shared = False
    includeMainLib = False
    gTestBuild = False
    gMockBuild = False

    def source(self):
        zipName = 'release-%s.zip' % self.version
        get('https://github.com/google/googletest/archive/%s' % zipName)

    def build(self):
        
        cmake = CMake(
            settings_or_conanfile = self,
            )

        for (opt, val) in self.options.items():
            if opt == 'include_main':
                self.includeMainLib = (val == "True")
            else:
                cmake.definitions[opt] = 'ON' if val == "True" else 'OFF'
        #cmake.definitions['BUILD_SHARED_LIBS'] = 'ON'
        self.shared = (cmake.definitions['BUILD_SHARED_LIBS'] == 'ON')
        self.gTestBuild = (cmake.definitions['BUILD_GTEST'] == 'ON')
        self.gMockBuild = (cmake.definitions['BUILD_GMOCK'] == 'ON')

        sys.stdout.write("\ncmake %s %s\n\n" % (cmake.command_line, self._conanfile_directory))

        cmake.configure(source_dir=self._conanfile_directory, build_dir='_build')

        cmake.build()


    def packageCommon(self, copyMain, copyLib, libMainName, parentIncludeDirName, pathToLibs):
        self.copy(pattern='*.h', dst='include', src=os.path.join(self.source_root, parentIncludeDirName, 'include'), keep_path=True)
        
        libSrc='_build'
        
        dstLibExt = {'bin' : ['dll'], 'lib' : ['so', 'dylib', 'a', 'lib']}
        
        for (dst, libExts) in dstLibExt.items():
            for libExt in libExts:
                if copyMain:
                    libPattern = '*%s_main.%s' % (libMainName, libExt)
                    self.copy(pattern=libPattern, dst=dst, src=libSrc, keep_path=False)
                if copyLib:
                    libPattern = '*%s.%s' % (libMainName, libExt)
                    self.copy(pattern=libPattern, dst=dst, src=libSrc, keep_path=False) 
        
        for docPatter in ['docs', 'README.md', 'LICENSE', 'CONTRIBUTORS', 'CHANGES']:
            src = os.path.join(self.source_root, parentIncludeDirName)
            dst = os.path.join('docs', parentIncludeDirName)
            self.copy(pattern=docPatter, dst=str(dst), src=str(src), keep_path=False)

    def packageGTestOnly(self, copyMain):
        self.packageCommon(copyMain, True, 'gtest', 'googletest', 'googletest')

    def packageGMock(self, copyMain):
        self.packageCommon(False, False, 'gtest', 'googletest', 'googletest')
        self.packageCommon(copyMain, not copyMain, 'gmock', 'googlemock', 'googlemock')

    def package(self):
        if not self.gMockBuild and self.gTestBuild:
            self.packageGTestOnly(self.includeMainLib)
        elif self.gMockBuild:
            self.packageGMock(self.includeMainLib)

        self.copy(pattern='README.md', dst='docs', src=str(self.source_root), keep_path=False)

    def package_info(self):
        if self.gMockBuild:
            if self.includeMainLib:
                self.cpp_info.libs = ['gmock_main'] # gmock_main includes gmock
            else:
                self.cpp_info.libs = ['gmock']
        elif self.gTestBuild:
            if self.includeMainLib:
                self.cpp_info.libs = ['gtest_main', 'gtest'] # gtest_main doesn't include gtest
            else:
                self.cpp_info.libs = ['gtest']

