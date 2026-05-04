local ffi = require("ffi")
local bit = require("bit")
local vk = nil -- We will inject the loaded library dynamically

local Memory = {
    Buffers = {},
    Mapped = {},
    DeviceMemory = {}
}

ffi.cdef[[
    typedef struct {
        float minX, minY, minZ; float _pad0;
        float maxX, maxY, maxZ; float _pad1;
        uint32_t isActive;      uint32_t _pad2[3];
    } GPU_GlobalCage;

    typedef struct {
        float x, y, z;
        float padding;
    } GPU_VertexAoS;
]]

-- The ReBAR logic we translated earlier
local function FindSmartBufferMemory(physicalDevice, typeFilter)
    local memProperties = ffi.new("VkPhysicalDeviceMemoryProperties")
    vk.vkGetPhysicalDeviceMemoryProperties(physicalDevice, memProperties)

    -- VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT (10) | HOST_COHERENT_BIT (2) | DEVICE_LOCAL_BIT (1)
    local rebarFlags = bit.bor(10, 2, 1) 
    for i = 0, memProperties.memoryTypeCount - 1 do
        local isTypeSupported = bit.band(typeFilter, bit.lshift(1, i)) ~= 0
        local hasProperties = bit.band(memProperties.memoryTypes[i].propertyFlags, rebarFlags) == rebarFlags
        if isTypeSupported and hasProperties then
            print("[MEMORY] ReBAR Supported! Streaming directly to VRAM.")
            return i
        end
    end

    local stdFlags = bit.bor(10, 2)
    for i = 0, memProperties.memoryTypeCount - 1 do
        local isTypeSupported = bit.band(typeFilter, bit.lshift(1, i)) ~= 0
        local hasProperties = bit.band(memProperties.memoryTypes[i].propertyFlags, stdFlags) == stdFlags
        if isTypeSupported and hasProperties then
            print("[MEMORY] ReBAR NOT found. Falling back to System RAM.")
            return i
        end
    end
    error("FATAL: Failed to find suitable buffer memory!")
end

-- The God-Tier Lua Buffer Allocator
function Memory.CreateHostVisibleBuffer(name, cdef_type, element_count, usage_flags, core_state)
    local byte_size = ffi.sizeof(cdef_type) * element_count

    -- 1. Create the Buffer
    local bufInfo = ffi.new("VkBufferCreateInfo", {
        sType = 12, -- VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO
        size = byte_size,
        usage = usage_flags,
        sharingMode = 0 -- VK_SHARING_MODE_EXCLUSIVE
    })

    local pBuffer = ffi.new("VkBuffer[1]")
    assert(vk.vkCreateBuffer(core_state.device, bufInfo, nil, pBuffer) == 0)
    Memory.Buffers[name] = pBuffer[0]

    -- 2. Get Memory Requirements
    local memReqs = ffi.new("VkMemoryRequirements")
    vk.vkGetBufferMemoryRequirements(core_state.device, Memory.Buffers[name], memReqs)

    -- 3. Allocate the Memory using our ReBAR logic
    local allocInfo = ffi.new("VkMemoryAllocateInfo", {
        sType = 5, -- VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO
        allocationSize = memReqs.size,
        memoryTypeIndex = FindSmartBufferMemory(core_state.physicalDevice, memReqs.memoryTypeBits)
    })

    local pMemory = ffi.new("VkDeviceMemory[1]")
    assert(vk.vkAllocateMemory(core_state.device, allocInfo, nil, pMemory) == 0)
    Memory.DeviceMemory[name] = pMemory[0]

    -- 4. Bind the Buffer to the Memory
    assert(vk.vkBindBufferMemory(core_state.device, Memory.Buffers[name], Memory.DeviceMemory[name], 0) == 0)

    -- 5. Map the memory to the CPU so Lua can edit it
    local ppData = ffi.new("void*[1]")
    assert(vk.vkMapMemory(core_state.device, Memory.DeviceMemory[name], 0, byte_size, 0, ppData) == 0)
    
    -- Cast it to the requested struct type!
    Memory.Mapped[name] = ffi.cast(cdef_type .. "*", ppData[0])
    
    print("[MEMORY] Allocated & Mapped Buffer: " .. name .. " (" .. byte_size .. " bytes)")
end

function Memory.Init(vulkan_lib, core_state)
    vk = vulkan_lib
    print("[MEMORY] Initializing GPU Buffer Manager...")

    -- ALLOCATE THE SWARM (Buffer A and B)
    -- Usage: VERTEX_BUFFER_BIT (128) | STORAGE_BUFFER_BIT (32) = 160
    Memory.CreateHostVisibleBuffer("SwarmA", "GPU_VertexAoS", 2500000, 160, core_state)
    Memory.CreateHostVisibleBuffer("SwarmB", "GPU_VertexAoS", 2500000, 160, core_state)

    -- ALLOCATE THE GLOBAL CAGE
    -- Usage: UNIFORM_BUFFER_BIT (16)
    Memory.CreateHostVisibleBuffer("Cage", "GPU_GlobalCage", 1, 16, core_state)

    -- Example of editing VRAM directly from Lua:
    Memory.Mapped.Cage[0].minX = -15000
    Memory.Mapped.Cage[0].maxX = 15000
    Memory.Mapped.Cage[0].isActive = 1
end

return Memory
