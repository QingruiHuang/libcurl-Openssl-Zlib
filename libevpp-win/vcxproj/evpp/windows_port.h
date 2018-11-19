#pragma once

// Fix VS compile warning
// 1>c:\program files (x86)\microsoft visual studio 14.0\vc\include\xkeycheck.h(250): fatal error C1189: #error:  The C++ Standard Library forbids macroizing keywords. Enable warning C4005 to find the forbidden macro.
#ifdef __cplusplus
#include <iostream>
#endif


//! Define Operation System.
#if ( defined(WIN32) || defined(WIN64) )
#   ifndef H_OS_WINDOWS
#       define H_OS_WINDOWS
#   endif
#   ifndef H_WINDOWS_API
#       define H_WINDOWS_API
#   endif
#endif

#ifdef H_OS_WINDOWS
#define usleep(us) Sleep((us)/1000)
#define snprintf  _snprintf
#define thread_local __declspec(thread)
#define strcasecmp   _stricmp
#define strncasecmp  _strnicmp
#define strcasestr	 strstr
#endif

#ifdef H_OS_WINDOWS
#pragma warning( disable: 4005 )
#pragma warning( disable: 4251 )
#pragma warning( disable: 4996 )
#pragma warning( disable: 4244 4251 4355 4715 4800 4996 4005 4819 4267)
#pragma warning( disable: 4530 )
#pragma warning( disable: 4577 )
#pragma warning( disable: 4503 )
#pragma warning( disable: 4039 )
#endif

// get rid of Windows/Linux inconsistencies
#ifdef H_OS_WINDOWS
#   ifndef PRIu64
#       define PRIu64     "I64u"
#   endif
#else
#   ifndef PRIu64
#       define PRIu64     "lu"
#   endif
#endif

//! Module symbol export
// #ifdef H_WINDOWS_API
// #   ifndef  H_STATIC_LIB_EVPP
// #       ifdef  EVPP_EXPORTS
// #           define EVPP_EXPORT __declspec(dllexport)
// #       else
// #           define EVPP_EXPORT __declspec(dllimport)
// #       endif
// #   else
// #       define EVPP_EXPORT
// #   endif
// #else
// #   define EVPP_EXPORT
// #endif

#define EVPP_EXPORT

// We must link against these libraries on windows platform for Visual Studio IDE
#ifdef _WIN32
#ifndef EVPP_EXPORTS
#if defined(VS_BUILD_LIB)
#if !defined(_LIB)
#if defined(_WIN64)
#if defined(_DEBUG)
#pragma comment(lib, "libevpp.x64.Debug.lib")
#else
#pragma comment(lib, "libevpp.x64.Release.lib")
#endif
#else
#if defined(_DEBUG)
#pragma comment(lib, "libevpp.Win32.Debug.lib")
#else
#pragma comment(lib, "libevpp.Win32.Release.lib")
#endif
#endif
#endif
#else
#pragma comment(lib, "evpp_static.lib")
#endif
#endif
#pragma comment(lib, "Ws2_32.lib")
#if !defined(VS_BUILD_LIB)
#pragma comment(lib, "glog.lib")
#pragma comment(lib, "event.lib")
#ifndef H_LIBEVENT_VERSION_14
#pragma comment(lib, "event_core.lib") // libevent2.0
#pragma comment(lib, "event_extra.lib") // libevent2.0
#endif
#endif
#endif



#ifdef H_OS_WINDOWS
#define __PRETTY_FUNCTION__ __FUNCTION__
#endif
