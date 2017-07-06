// Author: Marcin Serwach
// https://github.com/iblis-ms/conan_gbenchmark

#include <iostream>

#ifdef BUILD_GMOCK

// -DBUILD_GTEST=${gtest} -DBUILD_GMOCK

// adds GTest header
#include <gtest/gtest.h>
// adds GMock header
#include <gmock/gmock.h>

///////////////////
// to easily use GTest and GMock objects and methods.
using namespace ::testing;

class IListener 
{
public:
  virtual ~IListener(){}

  virtual void functionNoArg() = 0;
};

class CLibrary
{
public:

  static void fun(IListener& arg)
  {
    arg.functionNoArg();
  }
};

class IListenerMock : public IListener
{
public:
  MOCK_METHOD0(functionNoArg, void());
};

class CMyTestCase : public Test
{
};

TEST_F(CMyTestCase, ExpectCall_simple)
{
  IListenerMock listenerMock; 
  EXPECT_CALL(listenerMock, functionNoArg()).Times(1);
  CLibrary::fun(listenerMock);

}

#if !defined(INCLUDE_MAIN)
#if GTEST_OS_WINDOWS_MOBILE
# include <tchar.h>  // NOLINT

GTEST_API_ int _tmain(int argc, TCHAR** argv) {
#else
GTEST_API_ int main(int argc, char** argv) {
#endif  // GTEST_OS_WINDOWS_MOBILE
  std::cout << "Running main() from gmock_main.cc\n";
  // Since Google Mock depends on Google Test, InitGoogleMock() is
  // also responsible for initializing Google Test.  Therefore there's
  // no need for calling testing::InitGoogleTest() separately.
  testing::InitGoogleMock(&argc, argv);
  return RUN_ALL_TESTS();
}
#endif // INCLUDE_MAIN

#endif // BUILD_GMOCK

#if defined(BUILD_GTEST) && !defined(BUILD_GMOCK)

// adds GTest header
#include <gtest/gtest.h>

///////////////////
// to easily use GTest and GMock objects and methods.
using namespace ::testing;


class CMyTestCase : public Test
{
};

TEST_F(CMyTestCase, ExpectCall_simple)
{
  int a = 0;
  ASSERT_EQ(a, 0);

}

#if !defined(INCLUDE_MAIN)
GTEST_API_ int main(int argc, char **argv) {
  printf("Running main() from gtest_main.cc\n");
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
#endif // INCLUDE_MAIN
#endif // BUILD_GTEST

