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
    }
    default_options = ('BUILD_SHARED_LIBS=False',
                       'gmock_build_tests=False',
                       'gtest_build_tests=False',
                       'gtest_build_samples=False',
                       'gtest_disable_pthreads=False',
                       'gtest_hide_internal_symbols=False',
                      )
    generators = 'cmake'
    source_root = 'googletest-release-%s' % version
    exports = 'CMakeLists.txt'

    def source(self):
        zip_name = 'release-%s.zip' % self.version
        get('https://github.com/google/googletest/archive/%s' % zip_name)

    def build(self):
        
        cmake = CMake(
            settings_or_conanfile = self,
            )

        for (opt, val) in self.options.items():
            if val is not None:
                cmake.definitions[opt] = 'ON' if val == "True" else 'OFF'

        sys.stdout.write("\ncmake %s %s\n\n" % (cmake.command_line, self._conanfile_directory))
        
        cmake.configure(source_dir=self._conanfile_directory, build_dir='_build')
        
        cmake.build()

    def package(self):
        self.copy(pattern='*.h', dst='include', src=('%s/googlemock/include' % self.source_root), keep_path=True)
        self.copy(pattern='*.h', dst='include', src=('%s/googletest/include' % self.source_root), keep_path=True)
        self.copy(pattern='*.lib', dst='lib', src='_build/lib', keep_path=False)
        self.copy(pattern='*.a', dst='lib', src='_build/lib', keep_path=False)
        self.copy(pattern='*.so', dst='lib', src='_build/lib', keep_path=False)
        self.copy(pattern='*.dll', dst='lib', src='_build/lib', keep_path=False)

        for docPatter in ['*.md', 'LICENSE', 'AUTHORS', 'CONTRIBUTORS']:
            self.copy(pattern=docPatter, dst='doc', src=self.source_root, keep_path=False)


    def package_info(self):  
        self.cpp_info.libs = ['gmock', 'gmock_main', 'gtest']
