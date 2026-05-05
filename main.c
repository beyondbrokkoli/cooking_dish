#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <luajit-2.1/lua.h>
#include <luajit-2.1/lualib.h>
#include <luajit-2.1/lauxlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h> // <--- ADD THIS LINE
// ========================================================
// VULKAN RENDER STATE GLOBALS
// ========================================================
VkDevice g_device;
VkQueue g_queue;
uint32_t g_qIndex;
VkSwapchainKHR g_swapchain;
uint32_t g_imageCount;
uint32_t g_width, g_height;

VkPipeline g_gfxPipeline;
VkPipelineLayout g_gfxLayout;
VkPipeline g_compPipeline;
VkPipelineLayout g_compLayout;
VkImage g_depthImage;
VkImageView g_depthView;
VkDescriptorSet g_compSet0;
VkDescriptorSet g_compSet1;

VkImage g_swapchainImages[10];
VkImageView g_swapchainViews[10];

// ========================================================
// GPU BUFFER STATE GLOBALS
// ========================================================
VkBuffer g_buf_swarm_A;
VkBuffer g_buf_swarm_B;
VkBuffer g_buf_cage;

void* g_mapped_swarm_A;
void* g_mapped_swarm_B;
void* g_mapped_cage;

// ========================================================
// LUA HANDOFF FUNCTIONS
// ========================================================
// [BRIDGE] 1. Core State
// [BRIDGE] 1. Core State
static int l_set_core_handles(lua_State* L) {
    const char* dev_str = lua_tostring(L, 1);
    g_device     = (VkDevice)strtoull(dev_str, NULL, 10);
    g_queue      = (VkQueue)strtoull(lua_tostring(L, 2), NULL, 10);
    g_qIndex     = (uint32_t)lua_tointeger(L, 3);
    g_swapchain  = (VkSwapchainKHR)strtoull(lua_tostring(L, 4), NULL, 10);
    g_imageCount = (uint32_t)lua_tointeger(L, 5);
    g_width      = (uint32_t)lua_tointeger(L, 6);
    g_height     = (uint32_t)lua_tointeger(L, 7);
    
    printf("[C BRIDGE] Parsed Device String: '%s'\n", dev_str);
    printf("[C BRIDGE] Rebuilt VkDevice Pointer: %p\n", (void*)g_device);
    
    return 0;
}
// [BRIDGE] 2. Pipeline State
static int l_set_pipeline_handles(lua_State* L) {
    g_gfxPipeline  = (VkPipeline)strtoull(lua_tostring(L, 1), NULL, 10);
    g_gfxLayout    = (VkPipelineLayout)strtoull(lua_tostring(L, 2), NULL, 10);
    g_compPipeline = (VkPipeline)strtoull(lua_tostring(L, 3), NULL, 10);
    g_compLayout   = (VkPipelineLayout)strtoull(lua_tostring(L, 4), NULL, 10);
    g_depthImage   = (VkImage)strtoull(lua_tostring(L, 5), NULL, 10);
    g_depthView    = (VkImageView)strtoull(lua_tostring(L, 6), NULL, 10);
    g_compSet0     = (VkDescriptorSet)strtoull(lua_tostring(L, 7), NULL, 10);
    g_compSet1     = (VkDescriptorSet)strtoull(lua_tostring(L, 8), NULL, 10);
    return 0;
}

// [BRIDGE] 3. Swapchain Assets
static int l_set_swapchain_asset(lua_State* L) {
    uint32_t index = (uint32_t)lua_tointeger(L, 1);
    if (index < 10) {
        g_swapchainImages[index] = (VkImage)strtoull(lua_tostring(L, 2), NULL, 10);
        g_swapchainViews[index]  = (VkImageView)strtoull(lua_tostring(L, 3), NULL, 10);
    }
    return 0;
}

// [BRIDGE] 4. Buffer Handoff (Update your existing one to this!)
static int l_submit_buffers(lua_State* L) {
    g_buf_swarm_A    = (VkBuffer)strtoull(lua_tostring(L, 1), NULL, 10);
    g_buf_swarm_B    = (VkBuffer)strtoull(lua_tostring(L, 2), NULL, 10);
    g_buf_cage       = (VkBuffer)strtoull(lua_tostring(L, 3), NULL, 10);

    g_mapped_swarm_A = (void*)strtoull(lua_tostring(L, 4), NULL, 10);
    g_mapped_swarm_B = (void*)strtoull(lua_tostring(L, 5), NULL, 10);
    g_mapped_cage    = (void*)strtoull(lua_tostring(L, 6), NULL, 10);

    printf("[C BRIDGE] GPU Buffers safely locked via 64-bit strings.\n");
    return 0;
}
// ========================================================
// CROSS-PLATFORM SOCKETS
// ========================================================
#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    typedef int socklen_t;
#else
    #include <sys/socket.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <unistd.h>
    #include <fcntl.h>
    #define SOCKET int
    #define INVALID_SOCKET -1
    #define SOCKET_ERROR -1
    #define closesocket close
#endif

SOCKET g_udp_socket = INVALID_SOCKET;
struct sockaddr_in g_peer_addr = {0}; // Who we are talking to

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
// [BRIDGE] Host a UDP Server
static int l_net_host(lua_State* L) {
    int port = luaL_checkinteger(L, 1);

#ifdef _WIN32
    WSADATA wsa; WSAStartup(MAKEWORD(2,2), &wsa);
#endif

    g_udp_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    
    // Make it NON-BLOCKING (Crucial so our game loop doesn't freeze!)
#ifdef _WIN32
    u_long mode = 1; ioctlsocket(g_udp_socket, FIONBIO, &mode);
#else
    fcntl(g_udp_socket, F_SETFL, O_NONBLOCK);
#endif

    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(g_udp_socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        printf("[NETWORK] Failed to bind to port %d\n", port);
        lua_pushboolean(L, 0);
        return 1;
    }

    printf("[NETWORK] Hosting UDP on port %d\n", port);
    lua_pushboolean(L, 1);
    return 1;
}

// [BRIDGE] Join a UDP Server
static int l_net_join(lua_State* L) {
    const char* ip = luaL_checkstring(L, 1);
    int port = luaL_checkinteger(L, 2);

#ifdef _WIN32
    WSADATA wsa; WSAStartup(MAKEWORD(2,2), &wsa);
#endif

    g_udp_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    
    // Make it NON-BLOCKING
#ifdef _WIN32
    u_long mode = 1; ioctlsocket(g_udp_socket, FIONBIO, &mode);
#else
    fcntl(g_udp_socket, F_SETFL, O_NONBLOCK);
#endif

    g_peer_addr.sin_family = AF_INET;
    g_peer_addr.sin_port = htons(port);
    g_peer_addr.sin_addr.s_addr = inet_addr(ip);

    printf("[NETWORK] Ready to blast UDP to %s:%d\n", ip, port);
    lua_pushboolean(L, 1);
    return 1;
}

// [BRIDGE] Non-blocking read
static int l_net_poll(lua_State* L) {
    if (g_udp_socket == INVALID_SOCKET) { lua_pushnil(L); return 1; }

    char buffer[1024];
    struct sockaddr_in sender;
    socklen_t sender_len = sizeof(sender);

    int bytes = recvfrom(g_udp_socket, buffer, sizeof(buffer) - 1, 0, (struct sockaddr*)&sender, &sender_len);
    
    if (bytes > 0) {
        buffer[bytes] = '\0'; // Null-terminate the string
        lua_pushstring(L, buffer);
        
        // If we are the server, save who just talked to us so we can reply!
        if (g_peer_addr.sin_port == 0) {
            g_peer_addr = sender; 
        }
        return 1;
    }
    
    lua_pushnil(L); // No messages waiting
    return 1;
}
// [BRIDGE] Send a string over UDP
static int l_net_send(lua_State* L) {
    if (g_udp_socket == INVALID_SOCKET || g_peer_addr.sin_port == 0) return 0;
    
    const char* msg = luaL_checkstring(L, 1);
    sendto(g_udp_socket, msg, strlen(msg), 0, (struct sockaddr*)&g_peer_addr, sizeof(g_peer_addr));
    
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
    lua_pushcfunction(L, l_net_host); lua_setfield(L, -2, "net_host");
    lua_pushcfunction(L, l_net_join); lua_setfield(L, -2, "net_join");
    lua_pushcfunction(L, l_net_poll); lua_setfield(L, -2, "net_poll");
    lua_pushcfunction(L, l_net_send); lua_setfield(L, -2, "net_send");
    lua_pushcfunction(L, l_set_core_handles); lua_setfield(L, -2, "set_core_handles");
    lua_pushcfunction(L, l_set_pipeline_handles); lua_setfield(L, -2, "set_pipeline_handles");
    lua_pushcfunction(L, l_set_swapchain_asset); lua_setfield(L, -2, "set_swapchain_asset");

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
// ========================================================
    // CREATE COMMAND POOL & SYNC OBJECTS (The Engine Block)
    // ========================================================
    VkCommandPoolCreateInfo poolInfo = {0};
    poolInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
    poolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
    poolInfo.queueFamilyIndex = g_qIndex;

    VkCommandPool commandPool;
    vkCreateCommandPool(g_device, &poolInfo, NULL, &commandPool);

    VkCommandBufferAllocateInfo allocInfo = {0};
    allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    allocInfo.commandPool = commandPool;
    allocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    allocInfo.commandBufferCount = 1;

    VkCommandBuffer cmd;
    vkAllocateCommandBuffers(g_device, &allocInfo, &cmd);

    // Semaphores & Fences prevent CPU/GPU race conditions
    VkSemaphore imageAvailableSemaphore, renderFinishedSemaphore;
    VkFence inFlightFence;

    VkSemaphoreCreateInfo semInfo = {0}; semInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
    VkFenceCreateInfo fenceInfo = {0}; fenceInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
    fenceInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT; 

    vkCreateSemaphore(g_device, &semInfo, NULL, &imageAvailableSemaphore);
    vkCreateSemaphore(g_device, &semInfo, NULL, &renderFinishedSemaphore);
    vkCreateFence(g_device, &fenceInfo, NULL, &inFlightFence);

    PFN_vkCmdBeginRenderingKHR pfn_vkCmdBeginRenderingKHR = (PFN_vkCmdBeginRenderingKHR)vkGetDeviceProcAddr(g_device, "vkCmdBeginRenderingKHR");
    PFN_vkCmdEndRenderingKHR pfn_vkCmdEndRenderingKHR = (PFN_vkCmdEndRenderingKHR)vkGetDeviceProcAddr(g_device, "vkCmdEndRenderingKHR");

    uint32_t frameIndex = 0;
    double startTime = glfwGetTime();

    printf("[BOOT] Entering Main Loop...\n");

    // ========================================================
    // THE RENDER LOOP (The Heartbeat)
    // ========================================================
    while (!glfwWindowShouldClose(g_window)) {
        glfwPollEvents();

        // 1. Tick Lua Update
        lua_getglobal(L, "love_update");
        if (lua_isfunction(L, -1)) { 
            if (lua_pcall(L, 0, 0, 0) != LUA_OK) {
                printf("[LUA FATAL ERROR]: %s\n", lua_tostring(L, -1));
                break;
            }
        } else { lua_pop(L, 1); }

        double currentTime = glfwGetTime();
        float dt = (float)(currentTime - startTime);
        startTime = currentTime;

        vkWaitForFences(g_device, 1, &inFlightFence, VK_TRUE, UINT64_MAX);
        vkResetFences(g_device, 1, &inFlightFence);

        uint32_t imageIndex;
        vkAcquireNextImageKHR(g_device, g_swapchain, UINT64_MAX, imageAvailableSemaphore, VK_NULL_HANDLE, &imageIndex);

        vkResetCommandBuffer(cmd, 0);
        VkCommandBufferBeginInfo beginInfo = {0};
        beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
        vkBeginCommandBuffer(cmd, &beginInfo);

        // ----------------------------------------------------
        // PASS A: COMPUTE SHADER (MOVE 2.5 MILLION PARTICLES)
        // ----------------------------------------------------
        vkCmdBindPipeline(cmd, VK_PIPELINE_BIND_POINT_COMPUTE, g_compPipeline);

        VkDescriptorSet currentSet = (frameIndex % 2 == 0) ? g_compSet0 : g_compSet1;
        vkCmdBindDescriptorSets(cmd, VK_PIPELINE_BIND_POINT_COMPUTE, g_compLayout, 0, 1, &currentSet, 0, NULL);

        struct { float dt; float time; int state; } pc;
        pc.dt = dt;
        pc.time = (float)glfwGetTime();
        
        lua_getglobal(L, "Engine");
        if (lua_istable(L, -1)) {
            lua_getfield(L, -1, "connected");
            pc.state = lua_toboolean(L, -1) ? 1 : 0;
            lua_pop(L, 1);
        } else {
            pc.state = 0;
        }
        lua_pop(L, 1);

        vkCmdPushConstants(cmd, g_compLayout, VK_SHADER_STAGE_COMPUTE_BIT, 0, sizeof(pc), &pc);

        vkCmdDispatch(cmd, 9766, 1, 1);

        VkMemoryBarrier memBarrier = {0};
        memBarrier.sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER;
        memBarrier.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
        memBarrier.dstAccessMask = VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT;
        
        vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT, VK_PIPELINE_STAGE_VERTEX_INPUT_BIT, 
                             0, 1, &memBarrier, 0, NULL, 0, NULL);

        // ----------------------------------------------------
        // PASS B: GRAPHICS SHADER (DYNAMIC RENDERING)
        // ----------------------------------------------------
        VkImageMemoryBarrier imgBarrier = {0};
        imgBarrier.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
        imgBarrier.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
        imgBarrier.newLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
        imgBarrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        imgBarrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        imgBarrier.image = g_swapchainImages[imageIndex];
        imgBarrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
        imgBarrier.subresourceRange.levelCount = 1;
        imgBarrier.subresourceRange.layerCount = 1;
        imgBarrier.srcAccessMask = 0;
        imgBarrier.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;

        vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
                             0, 0, NULL, 0, NULL, 1, &imgBarrier);

        VkRenderingAttachmentInfoKHR colorAttachment = {0};
        colorAttachment.sType = VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR;
        colorAttachment.imageView = g_swapchainViews[imageIndex];
        colorAttachment.imageLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
        colorAttachment.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
        colorAttachment.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
        VkClearValue clearColor = {{{0.01f, 0.01f, 0.02f, 1.0f}}};
        colorAttachment.clearValue = clearColor;

        VkRenderingInfoKHR renderInfo = {0};
        renderInfo.sType = VK_STRUCTURE_TYPE_RENDERING_INFO_KHR;
        renderInfo.renderArea.extent.width = g_width;
        renderInfo.renderArea.extent.height = g_height;
        renderInfo.layerCount = 1;
        renderInfo.colorAttachmentCount = 1;
        renderInfo.pColorAttachments = &colorAttachment;

        pfn_vkCmdBeginRenderingKHR(cmd, &renderInfo);
        vkCmdBindPipeline(cmd, VK_PIPELINE_BIND_POINT_GRAPHICS, g_gfxPipeline);

        VkViewport viewport = {0.0f, 0.0f, (float)g_width, (float)g_height, 0.0f, 1.0f};
        vkCmdSetViewport(cmd, 0, 1, &viewport);
        VkRect2D scissor = {{0, 0}, {g_width, g_height}};
        vkCmdSetScissor(cmd, 0, 1, &scissor);

        VkBuffer vertexBuffer = (frameIndex % 2 == 0) ? g_buf_swarm_B : g_buf_swarm_A;
        VkDeviceSize offsets[] = {0};
        vkCmdBindVertexBuffers(cmd, 0, 1, &vertexBuffer, offsets);

        float viewProj[16] = {
            0.005f, 0,       0, 0,
            0,      -0.005f, 0, 0, 
            0,       0,      1, 0,
            0,       0,      0, 1
        };
        vkCmdPushConstants(cmd, g_gfxLayout, VK_SHADER_STAGE_VERTEX_BIT, 0, sizeof(float)*16, viewProj);

        // DRAW 2.5 MILLION PARTICLES!
        vkCmdDraw(cmd, 3, 2500000, 0, 0);

        pfn_vkCmdEndRenderingKHR(cmd);

        imgBarrier.oldLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
        imgBarrier.newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
        imgBarrier.srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
        imgBarrier.dstAccessMask = 0;

        vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
                             0, 0, NULL, 0, NULL, 1, &imgBarrier);

        vkEndCommandBuffer(cmd);

        VkSubmitInfo submitInfo = {0};
        submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submitInfo.waitSemaphoreCount = 1;
        submitInfo.pWaitSemaphores = &imageAvailableSemaphore;
        VkPipelineStageFlags waitStages[] = {VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT};
        submitInfo.pWaitDstStageMask = waitStages;
        submitInfo.commandBufferCount = 1;
        submitInfo.pCommandBuffers = &cmd;
        submitInfo.signalSemaphoreCount = 1;
        submitInfo.pSignalSemaphores = &renderFinishedSemaphore;

        vkQueueSubmit(g_queue, 1, &submitInfo, inFlightFence);

        VkPresentInfoKHR presentInfo = {0};
        presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
        presentInfo.waitSemaphoreCount = 1;
        presentInfo.pWaitSemaphores = &renderFinishedSemaphore;
        presentInfo.swapchainCount = 1;
        presentInfo.pSwapchains = &g_swapchain;
        presentInfo.pImageIndices = &imageIndex;

        vkQueuePresentKHR(g_queue, &presentInfo);

        frameIndex++;
    }

    vkDeviceWaitIdle(g_device);
    glfwDestroyWindow(g_window);
    glfwTerminate();
    lua_close(L);
    return 0;
}
