# Author: Marcin Serwach
# https://github.com/iblis-ms/conan_gmock

from conans import ConanFile, CMake
import os
import sys

channel = os.getenv("CONAN_CHANNEL", "stable")
username = os.getenv("CONAN_USERNAME", "iblis_ms")

class GMockTestConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    requires = "GMock/1.8.0@%s/%s" % (username, channel)
    generators = "cmake"

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def imports(self):
        self.copy("*.dll", dst="bin", src="bin")
        self.copy("*.dylib*", dst="bin", src="lib")
        self.copy("*.so", dst="bin", src="lib")

    def test(self):
        os.chdir("bin")
        self.run(".%sexample" % os.sep)
