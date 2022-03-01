
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static void test(lua_State *L, const char *filename)
{
    if (0 == luaL_loadfile(L, filename))
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
    
    if (argc > 0)
    {
        lua_createtable(L, 0, 1);
        lua_pushstring(L, argv[0]);
        lua_rawseti(L, -2, -1);
        lua_setglobal(L, "arg");
    }

    test(L, argc > 1 ? argv[1] : "test.lua");
    lua_close(L);
    return 0;
}
