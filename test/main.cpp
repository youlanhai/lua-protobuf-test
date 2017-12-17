
#include <lua.hpp>
#include <pb.h>

#if 1
extern "C" int luaopen_pb(lua_State *L);
bool register_pb(lua_State *L)
{
    lua_pushcfunction(L, luaopen_pb);
    if (0 != lua_pcall(L, 0, 1, 0))
    {
        printf("%s\n", lua_tostring(L, -1));
        return false;
    }
    lua_setglobal(L, "pb");
    return true;
}
#endif

void test(lua_State *L)
{
    register_pb(L);

    if (0 == luaL_loadfile(L, "test.lua"))
    {
        if (0 != lua_pcall(L, 0, 0, 0))
        {
            printf("%s\n", lua_tostring(L, -1));
        }
    }
    else
    {
        printf("%s\n", lua_tostring(L, -1));
    }
}

int main(int argc, char **argv)
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    test(L);
    lua_close(L);
    return 0;
}
