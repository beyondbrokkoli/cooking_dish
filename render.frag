#version 450

// Input from the Vertex Shader
layout(location = 0) in vec3 fragColor;

// Output to the Swapchain
layout(location = 0) out vec4 outColor;

void main() {
    // We just pass the color through, setting Alpha to 1.0 (Opaque)
    outColor = vec4(fragColor, 1.0);
}
