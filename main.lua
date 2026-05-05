local ffi = require("ffi")
local vk_core = require("vulkan_core")
local memory = require("memory")
local descriptors = require("descriptors")
local swapchain = require("swapchain") -- ADD THIS
local graphics_pipeline = require("graphics_pipeline")
local compute_pipeline = require("compute_pipeline")

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

    -- 3. Wire up the Compute Descriptors
    Engine.vk_descriptors = descriptors.Init(
        vk, 
        Engine.vk_context.device, 
        memory.Buffers["SwarmA"], 
        memory.Buffers["SwarmB"]
    )

    -- 4. Create the Swapchain (NEW!)
    local win_width, win_height = C_Bridge.getWindowSize()
    Engine.vk_swapchain = swapchain.Init(vk, Engine.vk_context, win_width, win_height)

    -- 5. Build Graphics Dependencies (Depth + Shaders)
    Engine.vk_graphics = graphics_pipeline.Init(vk, Engine.vk_context, win_width, win_height)

    -- 5. Extract the handles and cast them to raw numbers
    local bufA    = tonumber(ffi.cast("uintptr_t", memory.Buffers["SwarmA"]))
    local bufB    = tonumber(ffi.cast("uintptr_t", memory.Buffers["SwarmB"]))
    local bufCage = tonumber(ffi.cast("uintptr_t", memory.Buffers["Cage"]))

    local ptrA    = tonumber(ffi.cast("uintptr_t", memory.Mapped["SwarmA"]))
    local ptrB    = tonumber(ffi.cast("uintptr_t", memory.Mapped["SwarmB"]))
    local ptrCage = tonumber(ffi.cast("uintptr_t", memory.Mapped["Cage"]))

    -- 6. Build Compute Dependencies (THIS WAS MISSING!)
    Engine.vk_compute = require("compute_pipeline").Init(
        vk, 
        Engine.vk_context.device, 
        Engine.vk_descriptors.pipelineLayout
    )

    -- 6. Hand off to C!
    C_Bridge.submit_buffers(bufA, bufB, bufCage, ptrA, ptrB, ptrCage)

    print("[LUA] Engine Boot Sequence Complete.")

    -- ========================================================
    -- 7. THE DUMB & EFFICIENT NETWORK BOOTSTRAP
    -- ========================================================
    print("\n=============================================")
    print(" 📡 VIBE ENGINE NETWORK BOOTSTRAP 📡 ")
    print("=============================================")
    print("Do you want to host? [Press ENTER]")
    print("Is someone online? Type 'J' to Join 127.0.0.1")
    print("Any other key = Single Player")
    io.write("> ")
    
    local choice = io.read("*l") -- Blocks the terminal until the user hits Enter
    
    Engine.net_mode = "Offline"

    if choice == "" then
        C_Bridge.net_host(25000)
        Engine.net_mode = "Host"
        print("[NET] Hosting! Waiting for connections...")
        
    elseif choice:lower() == "j" then
        C_Bridge.net_join("127.0.0.1", 25000)
        Engine.net_mode = "Client"
        -- Fire the glorious handshake into the void!
        C_Bridge.net_send("GLORIOUS_HANDSHAKE_REQUEST")
        print("[NET] Handshake fired! Waiting for reply...")
        
    else
        print("[NET] Sleeping.")
    end
    print("=============================================\n")






end
-- Host a server:
-- C_Bridge.net_host(25000)

-- Or join one:
-- C_Bridge.net_join("127.0.0.1", 25000)

function love_update()
    -- Non-blocking poll!
    local msg = C_Bridge.net_poll()
    if msg then
        print("[NET IN]: " .. msg)
    end
end
