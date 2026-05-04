#version 450

// --------------------------------------------------------
// INPUTS
// --------------------------------------------------------
// This exactly matches your attrDesc format: VK_FORMAT_R32G32B32A32_SFLOAT
// The GPU reads one of these PER INSTANCE (particle) from the Swarm Buffer.
layout(location = 0) in vec4 inPosition; 

// The Push Constant (64 bytes: 4x4 Matrix)
layout(push_constant) uniform PushConstants {
    mat4 viewProj;
} pc;

// --------------------------------------------------------
// OUTPUTS
// --------------------------------------------------------
// Passing a color to the Fragment Shader
layout(location = 0) out vec3 fragColor;

// --------------------------------------------------------
// HARDCODED GEOMETRY
// --------------------------------------------------------
// A simple triangle facing the camera. 
// (Since we set VK_FRONT_FACE_COUNTER_CLOCKWISE, we wind these CCW)
const vec3 positions[3] = vec3[](
    vec3( 0.0,  0.5, 0.0), // Top
    vec3(-0.5, -0.5, 0.0), // Bottom Left
    vec3( 0.5, -0.5, 0.0)  // Bottom Right
);

// A color palette for the corners
const vec3 colors[3] = vec3[](
    vec3(1.0, 0.2, 0.5), // Pinkish Red
    vec3(0.2, 1.0, 0.5), // Mint Green
    vec3(0.2, 0.5, 1.0)  // Ocean Blue
);

void main() {
    // 1. Grab the local vertex for this specific corner of the triangle (0, 1, or 2)
    vec3 localPos = positions[gl_VertexIndex % 3];
    
    // Scale the particle down (so they aren't massive on screen)
    localPos *= 0.2; 

    // 2. Add the Swarm particle's world position!
    vec3 worldPos = localPos + inPosition.xyz;

    // 3. Project it through the Camera Matrix
    gl_Position = pc.viewProj * vec4(worldPos, 1.0);

    // 4. Send some beautiful colors to the Fragment Shader
    // We mix the corner color with a pseudo-random color based on the particle's ID
    vec3 instanceColor = vec3(
        fract(sin(gl_InstanceIndex * 12.9898) * 43758.5453),
        fract(sin(gl_InstanceIndex * 78.2330) * 43758.5453),
        fract(sin(gl_InstanceIndex * 45.1640) * 43758.5453)
    );
    
    fragColor = mix(colors[gl_VertexIndex % 3], instanceColor, 0.5);
}
