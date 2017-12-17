
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void test(lua_State *L)
{
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
