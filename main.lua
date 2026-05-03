local vk_core = require("vulkan_core")

-- Global engine state
Engine = {}

function love_load()
    print("[LUA] love_load executing...")
    Engine.vk_context = vk_core.init()
    print("[LUA] Engine Boot Sequence Complete.")
end

function love_update()
    -- Game logic goes here
end

function love_draw()
    -- The 9-line rendering clipboard goes here!
end
