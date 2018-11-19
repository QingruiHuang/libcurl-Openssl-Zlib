/* src/config.h.in.  Generated from configure.ac by autoheader.  */

/* Namespace for Google classes */
#define GOOGLE_NAMESPACE google

/* Stops putting the code inside the Google namespace */
#define _END_GOOGLE_NAMESPACE_ }

/* Puts following code inside the Google namespace */
#define _START_GOOGLE_NAMESPACE_ namespace google {

/* Always the empty-string on non-windows systems. On windows, should be
   "__declspec(dllexport)". This way, when we compile the dll, we export our
   functions/classes. It's safe to define this here because config.h is only
   used internally, to compile the DLL, and every DLL source file #includes
   "config.h" before anything else. */
#ifndef GOOGLE_GLOG_DLL_DECL
# define GOOGLE_GLOG_IS_A_DLL  1   /* not set if you're statically linking */
# define GOOGLE_GLOG_DLL_DECL  __declspec(dllexport)
# define GOOGLE_GLOG_DLL_DECL_FOR_UNITTESTS  __declspec(dllimport)
#endif


#if defined(_MSC_VER) && (_MSC_VER > 1700)
#define HAVE_SNPRINTF
#endif

#if defined(_MSC_VER)
#pragma warning( disable: 4005 ) 
#pragma warning( disable: 4251 )
#pragma warning( disable: 4996 ) 
#pragma warning( disable: 4244 4251 4355 4715 4800 4996 4005 4819 4267)
#pragma warning( disable: 4530 )
#pragma warning( disable: 4577 )
#pragma warning( disable: 4503 ) 
#endif