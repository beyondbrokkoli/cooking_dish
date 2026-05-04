import xml.etree.ElementTree as ET

# Your specific list of required Vulkan functions
TARGET_FUNCTIONS = {
    # Instance/Device
    "vkCreateInstance", "vkEnumeratePhysicalDevices", "vkCreateDevice", "vkDestroyInstance", "vkDestroyDevice",
    # Memory/Buffers
    "vkCreateBuffer", "vkGetBufferMemoryRequirements", "vkAllocateMemory", "vkBindBufferMemory", "vkMapMemory", "vkUnmapMemory", "vkFreeMemory",
    # Pipeline/Rendering
    "vkCreateGraphicsPipelines", "vkCreatePipelineLayout", "vkCmdBindPipeline", "vkCmdBeginRendering", "vkCmdDraw", "vkCmdEndRendering",
    # Sync/Command
    "vkCreateSemaphore", "vkBeginCommandBuffer", "vkEndCommandBuffer", "vkQueueSubmit", "vkResetCommandBuffer",
    # Extensions
    "vkAcquireNextImageKHR", "vkCreateSwapchainKHR", "vkQueuePresentKHR"
}

def generate_lua_ffi_cdef(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    ffi_functions = []

    # Iterate through all command definitions in vk.xml
    for command in root.findall('.//commands/command'):
        # Skip aliases for this extraction
        if command.get('alias'):
            continue
            
        proto = command.find('proto')
        if proto is None:
            continue
            
        name_elem = proto.find('name')
        if name_elem is None or name_elem.text not in TARGET_FUNCTIONS:
            continue

        # Flatten the <proto> tag (e.g., "VkResult vkCreateInstance")
        # itertext() gracefully merges the text inside and outside of the <type> and <name> child tags
        signature = "".join(proto.itertext()).strip()

        # Flatten all <param> tags
        params = []
        for param in command.findall('param'):
            # This handles pointers, const qualifiers, and types perfectly
            param_text = "".join(param.itertext()).strip()
            
            # Optional: Clean up array syntax if present (e.g., pCode[2])
            params.append(param_text)

        param_str = ", ".join(params) if params else "void"
        
        # Format for C/Lua FFI
        ffi_functions.append(f"{signature}({param_str});")

    return ffi_functions

if __name__ == "__main__":
    # Point this to your vk.xml file
    print("ffi.cdef[[")
    declarations = generate_lua_ffi_cdef("vk.xml")
    for decl in declarations:
        print(f"    {decl}")
    print("]]")
