import xml.etree.ElementTree as ET

TARGET_FUNCTIONS = {
    "vkCreateInstance", "vkEnumeratePhysicalDevices", "vkCreateDevice", "vkDestroyInstance", "vkDestroyDevice",
    "vkCreateBuffer", "vkGetBufferMemoryRequirements", "vkAllocateMemory", "vkBindBufferMemory", "vkMapMemory", "vkUnmapMemory", "vkFreeMemory",
    "vkCreateGraphicsPipelines", "vkCreatePipelineLayout", "vkCmdBindPipeline", "vkCmdBeginRendering", "vkCmdDraw", "vkCmdEndRendering",
    "vkCreateSemaphore", "vkBeginCommandBuffer", "vkEndCommandBuffer", "vkQueueSubmit", "vkResetCommandBuffer",
    "vkAcquireNextImageKHR", "vkCreateSwapchainKHR", "vkQueuePresentKHR"
}

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

    # 1. Grab Handles 
    ffi_declarations.append("// --- Handles ---")
    for handle in root.findall('.//types/type[@category="handle"]'):
        name_elem = handle.find('name')
        if name_elem is not None:
            handle_name = name_elem.text
            ffi_declarations.append(f"typedef struct {handle_name}_T* {handle_name};")
# ... (Keep the TARGET_FUNCTIONS and handle grabbing code) ...

    # Dictionary to map struct names to their XML element
    all_structs_xml = {s.get('name'): s for s in root.findall('.//types/type[@category="struct"]')}
    
    # 1. Figure out which structs our TARGET_FUNCTIONS need directly
    required_types = set()
    for command in root.findall('.//commands/command'):
        if command.find('name') is not None and command.find('name').text in TARGET_FUNCTIONS:
            for param in command.findall('param'):
                type_elem = param.find('type')
                if type_elem is not None:
                    required_types.add(type_elem.text)

    # 2. Recursively find nested structs (Dependencies)
    resolved_structs = set()
    struct_dependencies = {} # Maps struct -> set of structs it depends on
    
    def resolve_dependencies(type_name):
        if type_name in resolved_structs or type_name not in all_structs_xml:
            return
            
        struct_xml = all_structs_xml[type_name]
        resolved_structs.add(type_name)
        struct_dependencies[type_name] = set()

        for member in struct_xml.findall('member'):
            member_type = member.find('type')
            if member_type is not None and member_type.text in all_structs_xml:
                struct_dependencies[type_name].add(member_type.text)
                resolve_dependencies(member_type.text) # Recurse!

    for t in list(required_types):
        resolve_dependencies(t)

    # 3. Topological Sort (Print base structs before complex structs)
    ffi_declarations.append("\n// --- Structs (Auto-Sorted) ---")
    emitted = set()

    def emit_struct(struct_name):
        if struct_name in emitted:
            return
        
        # Make sure all dependencies are printed first
        for dep in struct_dependencies.get(struct_name, []):
            emit_struct(dep)

        struct_xml = all_structs_xml[struct_name]
        members = []
        seen_members = set() # Squash duplicate XML artifacts
        
        for member in struct_xml.findall('member'):
            for comment in member.findall('comment'):
                member.remove(comment)
            
            member_name = member.find('name').text if member.find('name') is not None else ""
            if member_name in seen_members:
                continue
            seen_members.add(member_name)

            member_text = "".join(member.itertext()).strip()
            members.append(f"    {' '.join(member_text.split())};")
            
        ffi_declarations.append(f"typedef struct {struct_name} {{\n" + "\n".join(members) + f"\n}} {struct_name};")
        emitted.add(struct_name)

    for s in resolved_structs:
        emit_struct(s)
        
    # ... (Keep the function grabbing code) ...
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
            
        if name_elem.text in seen_funcs:
            continue
        seen_funcs.add(name_elem.text)

        signature = "".join(proto.itertext()).strip()
        params = []
        for param in command.findall('param'):
            # FIX: Destroy <comment> tags here too, just in case
            for comment in param.findall('comment'):
                param.remove(comment)
                
            param_text = "".join(param.itertext()).strip()
            param_text = " ".join(param_text.split())
            params.append(param_text)

        param_str = ", ".join(params) if params else "void"
        ffi_declarations.append(f"{signature}({param_str});")

    return ffi_declarations

if __name__ == "__main__":
    print("ffi.cdef[[")
    
    print("// --- Base Types ---")
    print("typedef uint32_t VkFlags;")
    print("typedef uint64_t VkDeviceSize;")
    print("typedef uint32_t VkBool32;\n")
    
    declarations = generate_lua_ffi_cdef("vk.xml")
    for decl in declarations:
        print(decl)
        
    print("]]")
