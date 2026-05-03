--[[
  SYSTEM: VibeEngine Core
  MODULE: vulkan_tree_shaker.lua
  PURPOSE: Scans user code for used Vulkan symbols, then extracts ONLY those from vulkan_core.h
  USAGE: luajit vulkan_tree_shaker.lua /path/to/your/main.c /usr/include/vulkan/vulkan_core.h
--]]

local target_code_path = arg[1]
local vulkan_header_path = arg[2] or "/usr/include/vulkan/vulkan_core.h"

if not target_code_path then
    print("[FATAL]: You must provide the path to your source code!")
    print("Usage: luajit vulkan_tree_shaker.lua ../lua_vulkan/main.c")
    os.exit(1)
end

---------------------------------------------------------
-- PHASE 1: THE SCANNER (Building the Cheat Sheet)
---------------------------------------------------------
local function build_cheat_sheet(filepath)
    local file = io.open(filepath, "r")
    if not file then error("Could not open source code: " .. filepath) end

    local symbols = {}
    local count = 0

    for line in file:lines() do
        -- Find Vulkan Functions (e.g., vkCreateInstance)
        for func in line:gmatch("[^%w_](vk%u%w+)") do
            if not symbols[func] then
                symbols[func] = true
                count = count + 1
            end
        end
        -- Find Vulkan Structs/Handles (e.g., VkInstanceCreateInfo)
        for struct in line:gmatch("[^%w_](Vk%u%w+)") do
            if not symbols[struct] then
                symbols[struct] = true
                count = count + 1
            end
        end
    end
    file:close()
    
    print(string.format("[SCAN COMPLETE] Found %d unique Vulkan symbols in your code.", count))
    return symbols
end

---------------------------------------------------------
-- PHASE 2: THE STATE MACHINE (The Tree Shaker)
---------------------------------------------------------
local function shake_tree(header_path, cheat_sheet)
    local state = {
        mode = "IDLE",
        current_name = "",
        buffer = {},
        stats = { extracted = 0 }
    }

    local function clean_line(str)
        local s = str:match("^%s*(.-)%s*$")
        return (s:gsub("//.*$", ""))
    end

    local function print_audited_block()
        -- THE CHEAT: Only print if it's on our cheat sheet!
        if cheat_sheet[state.current_name] then
            print(string.format("\n// --- Extracted %s: %s ---", state.mode, state.current_name))
            for _, line in ipairs(state.buffer) do
                if line ~= "" then print("    " .. line) end
            end
            state.stats.extracted = state.stats.extracted + 1
        end
    end

    local function reset_state()
        state.mode = "IDLE"
        state.current_name = ""
        state.buffer = {}
    end

    local file = io.open(header_path, "r")
    if not file then error("Could not open header: " .. header_path) end

    print("\nffi.cdef[[")

    for line in file:lines() do
        local clean = clean_line(line)
        if clean == "" then goto continue end

        if state.mode == "IDLE" then
            -- Check Structs
            local struct_name = clean:match("^typedef struct%s+(%w+)%s*{")
            if struct_name then
                state.mode = "STRUCT"
                state.current_name = struct_name
                table.insert(state.buffer, clean)
                goto continue
            end

            -- Check Enums
            local enum_name = clean:match("^typedef enum%s+(%w+)%s*{")
            if enum_name then
                state.mode = "ENUM"
                state.current_name = enum_name
                table.insert(state.buffer, clean)
                goto continue
            end

            -- Check Functions
            local func_name, args = clean:match("^VKAPI_ATTR.-VKAPI_CALL%s+(vk%w+)%s*%((.*)")
            if func_name then
                state.mode = "FUNC"
                state.current_name = func_name
                -- Synthesize a clean C function signature for Lua FFI
                local ret_type = clean:match("^VKAPI_ATTR%s+(.-)%s+VKAPI_CALL")
                table.insert(state.buffer, ret_type .. " " .. func_name .. "(" .. args)
                
                if args:match("%);$") then
                    print_audited_block()
                    reset_state()
                end
                goto continue
            end

            -- Check simple typedefs (Handles like VkDevice)
            local handle_name = clean:match("^typedef struct %w+%* (%w+);")
            if handle_name and cheat_sheet[handle_name] then
                print("    " .. clean)
            end

        elseif state.mode == "STRUCT" or state.mode == "ENUM" then
            table.insert(state.buffer, clean)
            if clean:match("^}%s*%w*;") then
                print_audited_block()
                reset_state()
            end

        elseif state.mode == "FUNC" then
            table.insert(state.buffer, clean)
            if clean:match("%);$") then
                print_audited_block()
                reset_state()
            end
        end

        ::continue::
    end
    file:close()
    print("]]")
    print(string.format("\n[TREE SHAKE COMPLETE] Successfully extracted %d definitions tailored to your code.", state.stats.extracted))
end

-- ==========================================
-- EXECUTION
-- ==========================================
local cheat_sheet = build_cheat_sheet(target_code_path)
shake_tree(vulkan_header_path, cheat_sheet)
