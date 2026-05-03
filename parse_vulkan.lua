--[[
  SYSTEM: VibeEngine Core
  MODULE: parse_vulkan.lua
  PURPOSE: Memory-safe, state-machine parser for vulkan_core.h
  USAGE: luajit parse_vulkan.lua /usr/include/vulkan/vulkan_core.h [optional_search_term]
--]]

local function CreateVulkanParser(filepath, filter_term)
    -- ==========================================
    -- PRIVATE STATE (The State Machine)
    -- ==========================================
    local state = {
        mode = "IDLE", -- Can be "IDLE", "STRUCT", "ENUM", "FUNC"
        current_name = "",
        current_meta = "",
        buffer = {},
        stats = { structs = 0, enums = 0, funcs = 0 }
    }

    -- ==========================================
    -- PRIVATE UTILITIES
    -- ==========================================
    local function clean_line(str)
        -- Strip leading/trailing whitespace and inline C comments
        local s = str:match("^%s*(.-)%s*$")
        s = s:gsub("//.*$", "") 
        return s
    end

    local function print_audited_block()
        -- Only print if it matches our filter (or if no filter is provided)
        if filter_term and not state.current_name:lower():find(filter_term:lower()) then
            return
        end

        print(string.format("\n[EXTRACTED %s]: %s", state.mode, state.current_name))
        if state.mode == "FUNC" then
            print("  |- Returns: " .. state.current_meta)
        end
        
        for i, line in ipairs(state.buffer) do
            if line ~= "" then
                print("  |    " .. line)
            end
        end
    end

    local function reset_state()
        state.mode = "IDLE"
        state.current_name = ""
        state.current_meta = ""
        state.buffer = {}
    end

    -- ==========================================
    -- PUBLIC API
    -- ==========================================
    local public_api = {}

    function public_api:Parse()
        local file = io.open(filepath, "r")
        if not file then
            error("[FATAL]: Could not open Vulkan header at: " .. filepath)
        end

        print(string.format("--- INITIATING VULKAN PARSER (Filter: %s) ---", filter_term or "ALL"))

        -- Read line by line (Extremely RAM efficient)
        for line in file:lines() do
            local clean = clean_line(line)
            if clean == "" then goto continue end

            -- STATE: IDLE (Looking for triggers)
            if state.mode == "IDLE" then
                
                -- TRIGGER: Struct
                local struct_name = clean:match("^typedef struct%s+(%w+)%s*{")
                if struct_name then
                    state.mode = "STRUCT"
                    state.current_name = struct_name
                    goto continue
                end

                -- TRIGGER: Enum
                local enum_name = clean:match("^typedef enum%s+(%w+)%s*{")
                if enum_name then
                    state.mode = "ENUM"
                    state.current_name = enum_name
                    goto continue
                end

                -- TRIGGER: Function (VKAPI_ATTR ... VKAPI_CALL vkFunctionName)
                local ret, func_name, args = clean:match("^VKAPI_ATTR%s+(.-)%s+VKAPI_CALL%s+(vk%w+)%s*%((.*)")
                if func_name then
                    state.mode = "FUNC"
                    state.current_name = func_name
                    state.current_meta = ret -- Store the return type
                    
                    -- Some functions are 1-liners
                    if args:match("%);$") then
                        table.insert(state.buffer, args:sub(1, -3))
                        state.stats.funcs = state.stats.funcs + 1
                        print_audited_block()
                        reset_state()
                    else
                        table.insert(state.buffer, args)
                    end
                    goto continue
                end

            -- STATE: IN STRUCT OR ENUM
            elseif state.mode == "STRUCT" or state.mode == "ENUM" then
                if clean:match("^}%s*%w*;") then
                    -- End of block reached!
                    if state.mode == "STRUCT" then state.stats.structs = state.stats.structs + 1 end
                    if state.mode == "ENUM" then state.stats.enums = state.stats.enums + 1 end
                    print_audited_block()
                    reset_state()
                else
                    table.insert(state.buffer, clean)
                end

            -- STATE: IN FUNCTION
            elseif state.mode == "FUNC" then
                if clean:match("%);$") then
                    -- End of function arguments reached!
                    table.insert(state.buffer, clean:sub(1, -3)) -- Strip the closing );
                    state.stats.funcs = state.stats.funcs + 1
                    print_audited_block()
                    reset_state()
                else
                    table.insert(state.buffer, clean)
                end
            end

            ::continue::
        end

        file:close()
        print("\n--- PARSE COMPLETE ---")
        print(string.format("Structs: %d | Enums: %d | Functions: %d", state.stats.structs, state.stats.enums, state.stats.funcs))
    end

    -- ==========================================
    -- METATABLE FIREWALL
    -- ==========================================
    local proxy = {}
    setmetatable(proxy, {
        __index = public_api,
        __newindex = function()
            error("[ACCESS DENIED]: Parser state is immutable during execution.")
        end
    })

    return proxy
end

-- ==========================================
-- EXECUTION BRIDGE
-- ==========================================
local target_file = arg[1] or "/usr/include/vulkan/vulkan_core.h"
local search_filter = arg[2] -- Optional: e.g., "VkInstanceCreateInfo"

local parser = CreateVulkanParser(target_file, search_filter)
parser:Parse()
