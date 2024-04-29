#include <squirrel.h>
#include <sqstddebug.h>


static SQInteger debug_seterrorhandler(HSQUIRRELVM v)
{
  sq_seterrorhandler(v);
  return 0;
}

static SQInteger debug_setdebughook(HSQUIRRELVM v)
{
  sq_setdebughook(v);
  return 0;
}

extern SQInteger __sq_getcallstackinfos(HSQUIRRELVM v, SQInteger level);

static SQInteger debug_getstackinfos(HSQUIRRELVM v)
{
  SQInteger level;
  sq_getinteger(v, -1, &level);
  return __sq_getcallstackinfos(v, level);
}

#ifndef NO_GARBAGE_COLLECTOR
static SQInteger debug_collectgarbage(HSQUIRRELVM v)
{
    sq_pushinteger(v, sq_collectgarbage(v));
    return 1;
}
static SQInteger debug_resurrectunreachable(HSQUIRRELVM v)
{
    sq_resurrectunreachable(v);
    return 1;
}
#endif

static SQInteger debug_getbuildinfo(HSQUIRRELVM v)
{
  sq_newtable(v);
  sq_pushstring(v, _SC("version"), -1);
  sq_pushstring(v, SQUIRREL_VERSION, -1);
  sq_newslot(v, -3, SQFalse);
  sq_pushstring(v, _SC("charsize"), -1);
  sq_pushinteger(v, sizeof(SQChar));
  sq_newslot(v, -3, SQFalse);
  sq_pushstring(v, _SC("intsize"), -1);
  sq_pushinteger(v, sizeof(SQInteger));
  sq_newslot(v, -3, SQFalse);
  sq_pushstring(v, _SC("floatsize"), -1);
  sq_pushinteger(v, sizeof(SQFloat));
  sq_newslot(v, -3, SQFalse);
  sq_pushstring(v, _SC("gc"), -1);
#ifndef NO_GARBAGE_COLLECTOR
  sq_pushstring(v, _SC("enabled"), -1);
#else
  sq_pushstring(v, _SC("disabled"), -1);
#endif // NO_GARBAGE_COLLECTOR
  sq_newslot(v, -3, SQFalse);
  return 1;
}


static const SQRegFunction debuglib_funcs[] = {
    {_SC("seterrorhandler"),debug_seterrorhandler,2, NULL},
    {_SC("setdebughook"),debug_setdebughook,2, NULL},
    {_SC("getstackinfos"),debug_getstackinfos,2, _SC(".n")},
#ifndef NO_GARBAGE_COLLECTOR
    {_SC("collectgarbage"),debug_collectgarbage,0, NULL},
    {_SC("resurrectunreachable"),debug_resurrectunreachable,0, NULL},
#endif
    {_SC("getbuildinfo"), debug_getbuildinfo,1,NULL},
    {NULL,(SQFUNCTION)0,0,NULL}
};


SQRESULT sqstd_register_debuglib(HSQUIRRELVM v)
{
  SQInteger i = 0;
  while (debuglib_funcs[i].name != 0)
  {
    sq_pushstring(v, debuglib_funcs[i].name, -1);
    sq_newclosure(v, debuglib_funcs[i].f, 0);
    sq_setparamscheck(v, debuglib_funcs[i].nparamscheck, debuglib_funcs[i].typemask);
    sq_setnativeclosurename(v, -1, debuglib_funcs[i].name);
    sq_newslot(v, -3, SQFalse);
    i++;
  }
  return SQ_OK;
}
