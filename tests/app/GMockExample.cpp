// Author: Marcin Serwach
// https://github.com/iblis-ms/conan_gbenchmark

#include <iostream>

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
