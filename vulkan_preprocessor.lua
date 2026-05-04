--[[
  SYSTEM: VibeEngine Core
  MODULE: vulkan_preprocessor_v3.lua
  PURPOSE: Flatten Vulkan with cpp, protecting struct integrity while killing C++ noise.
--]]

local header_path = arg[1] or "./vulkan_core.h"

-- 1. Read and Assassinate ALL Includes
local f = io.open(header_path, "r")
if not f then error("Could not open: " .. header_path) end
local raw_content = f:read("*all")
f:close()

-- Kill every #include line so cpp doesn't hunt for missing files
local ghost_content = raw_content:gsub("#include%s+[\"<].-[\">]", "// Include Assassinated")

-- 2. System Preprocessor Strike
local tmp_in = "/tmp/vulkan_ghost.h"
local tmp_out = "/tmp/vulkan_flat.h"

local f_in = io.open(tmp_in, "w")
f_in:write(ghost_content)
f_in:close()

-- -P: No linemarkers
-- -D...: Defines to control what parts of the header are active
os.execute(string.format("cpp -P -DVK_USE_PLATFORM_XLIB_KHR -DVK_VERSION_1_0 %s > %s", tmp_in, tmp_out))

local f_out = io.open(tmp_out, "r")
local flattened = f_out:read("*all")
f_out:close()

-- 3. The Surgical Sanitizer
local function final_sanitize(text)
    -- Remove 'extern "C" {' 
    text = text:gsub('extern%s+"C"%s*{', "")
    
    -- Strip calling conventions and compiler attributes
    text = text:gsub("VKAPI_ATTR", "")
    text = text:gsub("VKAPI_CALL", "")
    text = text:gsub("VKAPI_PTR", "")
    text = text:gsub("__attribute__%s*%b()", "")
    text = text:gsub("__extension__", "") -- LuaJIT hates this one specifically
    
    -- We need to remove the VERY LAST closing brace (the extern "C" one)
    -- but keep every other brace for the structs.
    -- We do this by finding the last '}' and replacing it with a comment.
    local last_brace_idx = text:find("}%s*$")
    if last_brace_idx then
        text = text:sub(1, last_brace_idx - 1) .. "// Extern C Closed"
    end

    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        local clean = line:match("^%s*(.-)%s*$")
        if clean ~= "" then
            table.insert(lines, clean)
        end
    end
    return table.concat(lines, "\n")
end

local sanitized = final_sanitize(flattened)

-- 4. THE WRAPPER
io.write('local ffi = require("ffi")\n\n')
io.write('ffi.cdef[[\n')

-- Core C types for LuaJIT
io.write([[
    typedef size_t size_t;
    typedef uint8_t uint8_t;
    typedef uint32_t uint32_t;
    typedef uint64_t uint64_t;
    typedef int32_t int32_t;
    typedef int64_t int64_t;

    // OS Polyfills
    typedef void* HINSTANCE;
    typedef void* HWND;
    typedef void* Display;
    typedef unsigned long Window;
    typedef void* wl_display;
    typedef void* wl_surface;
    typedef void* xcb_connection_t;
    typedef uint32_t xcb_window_t;
    typedef uint32_t xcb_visualid_t;
    typedef void* ANativeWindow;
    typedef void* AHardwareBuffer;
    typedef void* CAMetalLayer;
    typedef struct VkAllocationCallbacks VkAllocationCallbacks;

    typedef void* PFN_vkAllocationFunction;
    typedef void* PFN_vkReallocationFunction;
    typedef void* PFN_vkFreeFunction;
    typedef void* PFN_vkInternalAllocationNotification;
    typedef void* PFN_vkInternalFreeNotification;
    typedef void* PFN_vkVoidFunction;
    typedef void* PFN_vkDebugUtilsMessengerCallbackEXT;
]])

io.write("\n" .. sanitized .. "\n")
io.write("]]\n\n")
io.write("return ffi\n")
