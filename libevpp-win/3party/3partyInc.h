#pragma once

#if !defined(HG_3PARTY_INC)

#if defined(_MSC_VER)
#define MSC_VER_VS1998	1200//vc++6.0
#define MSC_VER_VS2003	1300//vc++7.1
#define MSC_VER_VS2005	1400//vc++8.0
#define MSC_VER_VS2008	1500
#define MSC_VER_VS2010	1600
#define MSC_VER_VS2012	1700
#define MSC_VER_VS2013	1800
#define MSC_VER_VS2015	1900
#define MSC_VER_VS2017	1910
#endif

#include "args/args.hxx"
#include "jsoncpp/include/json/json.h"
#include "effolkronium/random.hpp"

#include "uuid4/uuid4.h"

#endif
