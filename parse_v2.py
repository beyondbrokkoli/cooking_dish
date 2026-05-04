import xml.etree.ElementTree as ET

TARGET_FUNCTIONS = {
    "vkCreateInstance", "vkEnumeratePhysicalDevices", "vkCreateDevice", "vkDestroyInstance", "vkDestroyDevice",
    "vkCreateBuffer", "vkGetBufferMemoryRequirements", "vkAllocateMemory", "vkBindBufferMemory", "vkMapMemory", "vkUnmapMemory", "vkFreeMemory",
    "vkCreateGraphicsPipelines", "vkCreatePipelineLayout", "vkCmdBindPipeline", "vkCmdBeginRendering", "vkCmdDraw", "vkCmdEndRendering",
    "vkCreateSemaphore", "vkBeginCommandBuffer", "vkEndCommandBuffer", "vkQueueSubmit", "vkResetCommandBuffer",
    "vkAcquireNextImageKHR", "vkCreateSwapchainKHR", "vkQueuePresentKHR"
}

# The specific structs needed by the functions above
TARGET_STRUCTS = {
    "VkInstanceCreateInfo", "VkAllocationCallbacks", "VkApplicationInfo",
    "VkDeviceCreateInfo", "VkDeviceQueueCreateInfo", "VkSubmitInfo",
    "VkMemoryAllocateInfo", "VkMemoryRequirements", "VkSemaphoreCreateInfo",
    "VkBufferCreateInfo", "VkGraphicsPipelineCreateInfo", "VkPipelineLayoutCreateInfo",
    "VkCommandBufferBeginInfo", "VkSwapchainCreateInfoKHR", "VkPresentInfoKHR",
    "VkRenderingInfo"
}

def generate_lua_ffi_cdef(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    ffi_declarations = []
    seen_funcs = set()

    # 1. Grab Handles (Opaque pointers for LuaJIT like VkInstance, VkDevice)
    ffi_declarations.append("// --- Handles ---")
    for handle in root.findall('.//types/type[@category="handle"]'):
        name_elem = handle.find('name')
        if name_elem is not None:
            handle_name = name_elem.text
            # Define as opaque pointers so LuaJIT is happy
            ffi_declarations.append(f"typedef struct {handle_name}_T* {handle_name};")

    # 2. Grab Structs
    ffi_declarations.append("\n// --- Structs ---")
    for struct in root.findall('.//types/type[@category="struct"]'):
        struct_name = struct.get('name')
        if struct_name not in TARGET_STRUCTS:
            continue
            
        members = []
        for member in struct.findall('member'):
            # Grab text, strip it, and remove weird internal XML spacing
            member_text = "".join(member.itertext()).strip()
            member_text = " ".join(member_text.split())
            members.append(f"    {member_text};")
        
        # Format struct definition
        struct_def = f"typedef struct {struct_name} {{\n" + "\n".join(members) + f"\n}} {struct_name};"
        ffi_declarations.append(struct_def)

    # 3. Grab Functions
    ffi_declarations.append("\n// --- Functions ---")
    for command in root.findall('.//commands/command'):
        if command.get('alias'):
            continue
            
        proto = command.find('proto')
        if proto is None:
            continue
            
        name_elem = proto.find('name')
        if name_elem is None or name_elem.text not in TARGET_FUNCTIONS:
            continue
            
        # Prevent duplicates
        if name_elem.text in seen_funcs:
            continue
        seen_funcs.add(name_elem.text)

        signature = "".join(proto.itertext()).strip()
        params = []
        for param in command.findall('param'):
            param_text = "".join(param.itertext()).strip()
            param_text = " ".join(param_text.split())
            params.append(param_text)

        param_str = ", ".join(params) if params else "void"
        ffi_declarations.append(f"{signature}({param_str});")

    return ffi_declarations

if __name__ == "__main__":
    print("ffi.cdef[[")
    
    # You may need to manually define some base types/enums if LuaJIT complains
    print("// --- Base Types ---")
    print("typedef uint32_t VkFlags;")
    print("typedef uint64_t VkDeviceSize;")
    print("typedef uint32_t VkBool32;\n")
    
    declarations = generate_lua_ffi_cdef("vk.xml")
    for decl in declarations:
        print(decl)
        
    print("]]")
