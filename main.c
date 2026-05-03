#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <luajit-2.1/lua.h>
#include <luajit-2.1/lualib.h>
#include <luajit-2.1/lauxlib.h>
#include <stdio.h>
#include <stdlib.h>

GLFWwindow* g_window = NULL;

// Bridge 1: Ask GLFW what OS extensions Vulkan needs
static int l_get_glfw_extensions(lua_State* L) {
    uint32_t count = 0;
    const char** exts = glfwGetRequiredInstanceExtensions(&count);
    lua_pushlightuserdata(L, (void*)exts); // Return the C-array pointer
    lua_pushinteger(L, count);             // Return the count
    return 2;
}

// Bridge 2: Ask GLFW to create the Vulkan Surface for our Window
static int l_create_surface(lua_State* L) {
    // Lua passes the VkInstance down to C
    VkInstance instance = (VkInstance)lua_touserdata(L, 1);
    VkSurfaceKHR surface;
    if (glfwCreateWindowSurface(instance, g_window, NULL, &surface) != VK_SUCCESS) {
        printf("FATAL: GLFW Failed to create Vulkan Surface!\n");
        exit(-1);
    }
    // Hand the Surface handle back up to Lua
    lua_pushlightuserdata(L, surface);
    return 1;
}

int main() {
    printf("[BOOT] Starting Naked Bootloader...\n");

    glfwInit();
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API); // Tell GLFW we aren't using OpenGL
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
    g_window = glfwCreateWindow(1280, 720, "VibeEngine - Cooking Dish", NULL, NULL);

    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    // Register our Bridge Functions
    lua_newtable(L);
    lua_pushcfunction(L, l_get_glfw_extensions); lua_setfield(L, -2, "get_glfw_extensions");
    lua_pushcfunction(L, l_create_surface);      lua_setfield(L, -2, "create_surface");
    lua_setglobal(L, "C_Bridge");

    // Boot the Lua Brain
    if (luaL_dofile(L, "main.lua") != LUA_OK) {
        printf("[LUA FATAL]: %s\n", lua_tostring(L, -1));
        return -1;
    }

    // Call love.load
    lua_getglobal(L, "love_load");
    if (lua_isfunction(L, -1)) { lua_pcall(L, 0, 0, 0); } else { lua_pop(L, 1); }

    printf("[BOOT] Entering Main Loop...\n");
    while (!glfwWindowShouldClose(g_window)) {
        glfwPollEvents();

        lua_getglobal(L, "love_update");
        if (lua_isfunction(L, -1)) { lua_pcall(L, 0, 0, 0); } else { lua_pop(L, 1); }

        lua_getglobal(L, "love_draw");
        if (lua_isfunction(L, -1)) { lua_pcall(L, 0, 0, 0); } else { lua_pop(L, 1); }
    }

    glfwDestroyWindow(g_window);
    glfwTerminate();
    lua_close(L);
    return 0;
}
