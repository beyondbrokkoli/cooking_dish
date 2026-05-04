local ffi = require("ffi")
local vk_core = require("vulkan_core")
local memory = require("memory")
local descriptors = require("descriptors") -- ADD THIS

-- Universal Vulkan Loader
local success, vk = pcall(ffi.load, "vulkan-1")
if not success then success, vk = pcall(ffi.load, "vulkan") end

Engine = {}

function love_load()
    print("[LUA] love_load executing...")
    
    -- 1. Boot Core Vulkan
    Engine.vk_context = vk_core.init()
    
    -- 2. Boot GPU Memory Manager
    memory.Init(vk, Engine.vk_context)

    -- 3. Wire up the Compute Descriptors (NEW!)
    Engine.vk_descriptors = descriptors.Init(
        vk, 
        Engine.vk_context.device, 
        memory.Buffers["SwarmA"], 
        memory.Buffers["SwarmB"]
    )

    -- 4. Extract the handles and cast them to raw numbers
    local bufA    = tonumber(ffi.cast("uintptr_t", memory.Buffers["SwarmA"]))
    local bufB    = tonumber(ffi.cast("uintptr_t", memory.Buffers["SwarmB"]))
    local bufCage = tonumber(ffi.cast("uintptr_t", memory.Buffers["Cage"]))

    local ptrA    = tonumber(ffi.cast("uintptr_t", memory.Mapped["SwarmA"]))
    local ptrB    = tonumber(ffi.cast("uintptr_t", memory.Mapped["SwarmB"]))
    local ptrCage = tonumber(ffi.cast("uintptr_t", memory.Mapped["Cage"]))

    -- 5. Hand off to C!
    C_Bridge.submit_buffers(bufA, bufB, bufCage, ptrA, ptrB, ptrCage)

    print("[LUA] Engine Boot Sequence Complete.")
end
