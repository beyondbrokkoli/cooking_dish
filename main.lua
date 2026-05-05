local ffi = require("ffi")
local vk_core = require("vulkan_core")
local memory = require("memory")
local descriptors = require("descriptors")
local swapchain = require("swapchain") -- ADD THIS
local graphics_pipeline = require("graphics_pipeline")
local compute_pipeline = require("compute_pipeline")
local camera_math = require("camera")

-- 1. Allocate the data payload once
local cam_state = camera_math.create_state()

-- Universal Vulkan Loader
local success, vk = pcall(ffi.load, "vulkan-1")
if not success then success, vk = pcall(ffi.load, "vulkan") end

Engine = {}
-- ========================================================
-- LOVE2D API MOCKING (So camera.lua works unmodified!)
-- ========================================================
love = {
    keyboard = {
        isDown = function(key)
            if key == "w" then return Engine.isKeyDown(87) end
            if key == "a" then return Engine.isKeyDown(65) end
            if key == "s" then return Engine.isKeyDown(83) end
            if key == "d" then return Engine.isKeyDown(68) end
            if key == "q" then return Engine.isKeyDown(81) end
            if key == "e" then return Engine.isKeyDown(69) end
            if key == "space" then return Engine.isKeyDown(32) end
            if key == "left" then return Engine.isKeyDown(263) end
            if key == "right" then return Engine.isKeyDown(262) end
            if key == "up" then return Engine.isKeyDown(265) end
            if key == "down" then return Engine.isKeyDown(264) end
            return false
        end
    },
    mouse = {
        getRelativeMode = function() return true end,
        -- [THE FIX] Bind to our new GLFW bridge!
        isDown = function(button) return Engine.isMouseDown(button) end
    }
}
function love_load()
    print("[LUA] love_load executing...")
    
    -- 1. Boot Core Vulkan
    Engine.vk_context = vk_core.init()
    
    -- 2. Boot GPU Memory Manager
    memory.Init(vk, Engine.vk_context)
    -- ========================================================
    -- THE BIG BANG (Seed the initial particle positions)
    -- ========================================================
    print("[LUA] Seeding 2.5 Million Particles... (Standby)")
    math.randomseed(os.time())
    local swarmA = memory.Mapped["SwarmA"]
    
    for i = 0, 2500000 - 1 do
        -- Spread them randomly in a 200x200x200 cube
        swarmA[i].x = (math.random() - 0.5) * 200.0
        swarmA[i].y = (math.random() - 0.5) * 200.0
        swarmA[i].z = (math.random() - 0.5) * 200.0
        swarmA[i].padding = 1.0
    end
    print("[LUA] Big Bang Complete!")
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

    -- The TRULY BULLETPROOF 64-bit String Converter
    local function ptr2str(ptr)
        if ptr == nil then return "0" end
        local cdata_num = ffi.cast("uint64_t", ffi.cast("uintptr_t", ptr))
        return string.match(tostring(cdata_num), "%d+")
    end

    -- 6. Build Compute Dependencies (RESTORED!)
    Engine.vk_compute = compute_pipeline.Init(
        vk,
        Engine.vk_context.device,
        Engine.vk_descriptors.pipelineLayout
    )

    -- 7. THE CORE HANDOFF
    C_Bridge.set_core_handles(
        ptr2str(Engine.vk_context.device),
        ptr2str(Engine.vk_context.queue),
        Engine.vk_context.qIndex, 
        ptr2str(Engine.vk_swapchain.handle),
        Engine.vk_swapchain.imageCount, 
        Engine.vk_swapchain.extent.width, 
        Engine.vk_swapchain.extent.height 
    )

    -- THE PIPELINE HANDOFF (Fixed the Compute Layout origin!)
    C_Bridge.set_pipeline_handles(
        ptr2str(Engine.vk_graphics.pipeline),
        ptr2str(Engine.vk_graphics.pipelineLayout),
        ptr2str(Engine.vk_compute.pipeline),
        ptr2str(Engine.vk_descriptors.pipelineLayout), -- <--- THIS WAS THE GHOST!
        ptr2str(Engine.vk_graphics.depthImage),
        ptr2str(Engine.vk_graphics.depthImageView),
        ptr2str(Engine.vk_descriptors.set0),
        ptr2str(Engine.vk_descriptors.set1)
    )

    for i = 0, Engine.vk_swapchain.imageCount - 1 do
        C_Bridge.set_swapchain_asset(i, ptr2str(Engine.vk_swapchain.images[i]), ptr2str(Engine.vk_swapchain.imageViews[i]))
    end

    -- 8. BUFFER HANDOFF
    C_Bridge.submit_buffers(
        ptr2str(memory.Buffers["SwarmA"]),
        ptr2str(memory.Buffers["SwarmB"]),
        ptr2str(memory.Buffers["Cage"]),
        ptr2str(memory.Mapped["SwarmA"]),
        ptr2str(memory.Mapped["SwarmB"]),
        ptr2str(memory.Mapped["Cage"])
    )

    print("[LUA] Engine Boot Sequence Complete.")

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

function love_update(dt)
    -- Pipe data to logic
    camera_math.apply_movement(cam_state, dt)
    camera_math.build_matrix(cam_state, Engine.vk_swapchain.extent.width, Engine.vk_swapchain.extent.height)

    -- Pass the flat 16-float array across the C-Bridge
    -- LuaJIT's `unpack` is heavily optimized, effectively zero-cost here.
    Engine.setCameraMatrix(unpack(cam_state.mat))
    -- Non-blocking poll!
    local msg = C_Bridge.net_poll()
    if msg then
        print("[NET IN]: " .. msg)
    end

end
function love_mousemoved(x, y, dx, dy)
    -- Pipe data to logic
    camera_math.apply_look(cam_state, dx, dy)
end
