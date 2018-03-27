# Author: Marcin Serwach
# https://github.com/iblis-ms/conan_gmock

from conans import ConanFile, CMake
import os
import sys
import shutil

class GMockConan(ConanFile):
    name = 'GMock'
    version = '1.8.0'
    license = 'MIT LIcence'
    url = 'https://github.com/iblis-ms/conan_gmock'
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
    buildFolder = '_build'

    def source(self):
        folderNameDownloaded = 'googletest'
        folderNameWithVersion = self.source_root
     
        if os.environ.get('APPVEYOR') == 'True':
            git = '\"C:\\Program Files\\Git\\mingw64\\bin\\git.exe\"' # git is not present in PATH on AppVeyor
        else:
            git = 'git'
        self.run('%s clone https://github.com/google/googletest.git' % git)
        shutil.move(folderNameDownloaded, folderNameWithVersion)
        self.run("cd %s && %s checkout tags/release-%s -b %s" % (folderNameWithVersion, git, self.version, self.version))

    def build(self):
        
        cmake = CMake(self)

        for (opt, val) in self.options.items():
            if opt == 'include_main':
                self.includeMainLib = (val == "True")
            else:
                cmake.definitions[opt] = 'ON' if val == "True" else 'OFF'

        self.shared = (cmake.definitions['BUILD_SHARED_LIBS'] == 'ON')
        self.gTestBuild = (cmake.definitions['BUILD_GTEST'] == 'ON')
        self.gMockBuild = (cmake.definitions['BUILD_GMOCK'] == 'ON')

        if cmake.generator == "MinGW Makefiles":
            cmake.definitions['gtest_disable_pthreads'] = 'ON' # see https://github.com/google/googletest/pull/721

        sys.stdout.write("cmake " + str(cmake.command_line) + "\n")

        cmake.configure(source_dir=self.build_folder, build_dir=self.buildFolder)
        
        cmake.build()

    def packageCommon(self, copyMain, copyLib, libMainName, parentIncludeDirName, pathToLibs):
        self.copy(pattern='*.h', dst='include', src=os.path.join(self.source_root, parentIncludeDirName, 'include'), keep_path=True)
        
        libSrc='_build'
        
        dstLibExt = {'bin' : ['dll'], 'lib' : ['so', 'dylib', 'a', 'dll.a', 'lib', 'pdb']} # dll.a - MinGW
        
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

