#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <luajit-2.1/lua.h>
#include <luajit-2.1/lualib.h>
#include <luajit-2.1/lauxlib.h>
#include <stdio.h>
#include <stdlib.h>

GLFWwindow* g_window = NULL;

// GLOBAL VULKAN RESOURCES (Populated by Lua)
VkBuffer g_buf_swarm_A = VK_NULL_HANDLE;
VkBuffer g_buf_swarm_B = VK_NULL_HANDLE;
VkBuffer g_buf_cage    = VK_NULL_HANDLE;

void* g_mapped_swarm_A = NULL;
void* g_mapped_swarm_B = NULL;
void* g_mapped_cage    = NULL;

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
    // 1. Read the raw memory address as a standard number
    uintptr_t addr = (uintptr_t)luaL_checknumber(L, 1);
    
    // 2. Cast it back to a Vulkan Instance
    VkInstance instance = (VkInstance)addr;
    
    VkSurfaceKHR surface; 
    VkResult res = glfwCreateWindowSurface(instance, g_window, NULL, &surface);
    
    if (res != VK_SUCCESS) {
        printf("FATAL: GLFW Failed to create Vulkan Surface! Error code: %d\n", res);
        exit(-1);
    }
    
    // Pass the surface pointer back to Lua as a raw number!
    lua_pushnumber(L, (lua_Number)(uintptr_t)surface);
    return 1;
}
// 3. Get Window Size (Crucial for Swapchain setup later)
static int l_get_window_size(lua_State* L) {
    int width, height;
    glfwGetFramebufferSize(g_window, &width, &height);
    lua_pushinteger(L, width);
    lua_pushinteger(L, height);
    return 2; // Returns both width and height to Lua
}

// 4. Toggle Fullscreen
static int l_set_fullscreen(lua_State* L) {
    int enable = lua_toboolean(L, 1);
    
    // Grab the primary monitor and its current video mode
    GLFWmonitor* monitor = glfwGetPrimaryMonitor();
    const GLFWvidmode* mode = glfwGetVideoMode(monitor);

    if (enable) {
        // Switch to Exclusive Fullscreen using the monitor's native resolution
        glfwSetWindowMonitor(g_window, monitor, 0, 0, mode->width, mode->height, mode->refreshRate);
    } else {
        // Switch back to Windowed mode (e.g., 1280x720 centered)
        int win_w = 1280;
        int win_h = 720;
        int pos_x = (mode->width - win_w) / 2;
        int pos_y = (mode->height - win_h) / 2;
        glfwSetWindowMonitor(g_window, NULL, pos_x, pos_y, win_w, win_h, GLFW_DONT_CARE);
    }
    return 0;
}
// Bridge 5: Hand off the constructed memory buffers to the C loop
static int l_submit_buffers(lua_State* L) {
    // 1. Read the VkBuffer handles
    g_buf_swarm_A = (VkBuffer)(uintptr_t)luaL_checknumber(L, 1);
    g_buf_swarm_B = (VkBuffer)(uintptr_t)luaL_checknumber(L, 2);
    g_buf_cage    = (VkBuffer)(uintptr_t)luaL_checknumber(L, 3);

    // 2. Read the Mapped VRAM Pointers
    g_mapped_swarm_A = (void*)(uintptr_t)luaL_checknumber(L, 4);
    g_mapped_swarm_B = (void*)(uintptr_t)luaL_checknumber(L, 5);
    g_mapped_cage    = (void*)(uintptr_t)luaL_checknumber(L, 6);

    printf("[C BRIDGE] GPU Buffers locked and loaded in C backend.\n");
    return 0;
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
    lua_pushcfunction(L, l_get_window_size); lua_setfield(L, -2, "getWindowSize");
    lua_pushcfunction(L, l_set_fullscreen); lua_setfield(L, -2, "setFullscreen");
    lua_pushcfunction(L, l_submit_buffers);      lua_setfield(L, -2, "submit_buffers");

    lua_setglobal(L, "C_Bridge");

    // Boot the Lua Brain
    if (luaL_dofile(L, "main.lua") != LUA_OK) {
        printf("[LUA FATAL]: %s\n", lua_tostring(L, -1));
        return -1;
    }

    // Call love_load
    lua_getglobal(L, "love_load");
    if (lua_isfunction(L, -1)) {
        if (lua_pcall(L, 0, 0, 0) != LUA_OK) {
            printf("[LUA FATAL ERROR]: %s\n", lua_tostring(L, -1));
            exit(-1);
        }
    } else {
        lua_pop(L, 1);
    }

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
