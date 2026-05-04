local ffi = require("ffi")

-- =========================================================
-- END OF BOILERPLATE
-- START OF vulkan_core.lua
-- =========================================================
-- We need to declare a few basic primitive handles that the tree shaker missed
-- because they are essentially just void pointers in C.
--ffi.cdef[[
--    typedef void* VkInstance;
--    typedef void* VkPhysicalDevice;
--    typedef void* VkDevice;
--    typedef void* VkSurfaceKHR;
--    typedef void* VkQueue;
--]]

local vk = ffi.load("vulkan")
local core = {}

function core.init()
    print("[LUA] Initializing Vulkan Core...")

    -- 1. Ask C for the OS Extensions needed for the Window
    local exts_ptr, exts_count = C_Bridge.get_glfw_extensions()
    -- Cast the raw pointer to something the FFI understands
    local glfwExtensions = ffi.cast("const char* const*", exts_ptr)

    -- 2. Build the Application Info
    local appInfo = ffi.new("VkApplicationInfo", {
        sType = vk.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        pApplicationName = "VibeEngine Cooking Dish",
        apiVersion = 4194304 -- VK_API_VERSION_1_0
    })

    -- 3. Build the Instance Info
    local createInfo = ffi.new("VkInstanceCreateInfo", {
        sType = vk.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        pApplicationInfo = appInfo,
        enabledExtensionCount = exts_count,
        ppEnabledExtensionNames = glfwExtensions,
        enabledLayerCount = 0 -- We will add validation layers back later
    })

    -- 4. Create the Instance
    local pInstance = ffi.new("VkInstance[1]")
    local res = vk.vkCreateInstance(createInfo, nil, pInstance)
    assert(res == 0, "FATAL: vkCreateInstance failed!")
    local instance = pInstance[0]
    print("[LUA] Vulkan Instance Created!")

    -- 5. Ask C to create the Window Surface using our new Instance
    local surface = C_Bridge.create_surface(instance)
    print("[LUA] Window Surface Linked!")

    -- 6. Find the GPU
    local pDeviceCount = ffi.new("uint32_t[1]")
    vk.vkEnumeratePhysicalDevices(instance, pDeviceCount, nil)
    local pDevices = ffi.new("VkPhysicalDevice[?]", pDeviceCount[0])
    vk.vkEnumeratePhysicalDevices(instance, pDeviceCount, pDevices)
    
    local physicalDevice = pDevices[0] -- Just grab the first GPU for now
    print("[LUA] Hardware GPU Selected!")

    return {
        instance = instance,
        physicalDevice = physicalDevice,
        surface = surface
    }
end

return core
