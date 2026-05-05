-- camera.lua
local math_rad, math_sin, math_cos, math_tan = math.rad, math.sin, math.cos, math.tan

-- 1. PURE DATA: Allocates the raw state buffer
local function create_state()
    return {
        -- Positional
        x = 0.0, y = 0.0, z = -5.0,
        yaw = -90.0, pitch = 0.0,
        -- Config
        fov = 60.0, zNear = 0.1, sensitivity = 0.1, speed = 10.0,
        -- The 16-float output payload (Pre-allocated)
        mat = {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1} 
    }
end

-- 2. PURE FUNCTION: Transforms position data based on input
local function apply_movement(state, dt)
    local moveSpeed = state.speed * dt
    local radYaw = math_rad(state.yaw)
    
    -- Planar movement vectors
    local fx, fz = math_cos(radYaw), math_sin(radYaw)
    local rx, rz = math_cos(radYaw - 1.5708), math_sin(radYaw - 1.5708)

    if love.keyboard.isDown("w") then 
        state.x = state.x + fx * moveSpeed; state.z = state.z + fz * moveSpeed 
    end
    if love.keyboard.isDown("s") then 
        state.x = state.x - fx * moveSpeed; state.z = state.z - fz * moveSpeed 
    end
    if love.keyboard.isDown("a") then 
        state.x = state.x - rx * moveSpeed; state.z = state.z - rz * moveSpeed 
    end
    if love.keyboard.isDown("d") then 
        state.x = state.x + rx * moveSpeed; state.z = state.z + rz * moveSpeed 
    end
end

-- 3. PURE FUNCTION: Transforms look data
local function apply_look(state, dx, dy)
    state.yaw = state.yaw + (dx * state.sensitivity)
    state.pitch = state.pitch - (dy * state.sensitivity)
    
    -- Clamp to prevent gimbal lock
    if state.pitch > 89.0 then state.pitch = 89.0 end
    if state.pitch < -89.0 then state.pitch = -89.0 end
end

local function build_matrix(state, width, height)
    local aspect = width / height
    local f = 1.0 / math_tan(math_rad(state.fov) * 0.5)
    
    -- 1. Projection Matrix (Reverse-Z, Vulkan Y-Down)
    local p00 = f / aspect
    local p11 = -f
    local p22 = 0.0
    local p23 = -1.0
    local p32 = state.zNear

    -- 2. View Matrix (FPS LookAt)
    local radPitch = math_rad(state.pitch)
    local radYaw = math_rad(state.yaw)
    
    local cp, sp = math_cos(radPitch), math_sin(radPitch)
    local cy, sy = math_cos(radYaw), math_sin(radYaw)
    
    -- Forward, Right, Up vectors
    local fx = cp * cy;  local fy = sp;  local fz = cp * sy
    local rx = -sy;      local ry = 0;   local rz = cy
    local ux = fy*rz - fz*ry; local uy = fz*rx - fx*rz; local uz = fx*ry - fy*rx

    local cx, cy_pos, cz = state.x, state.y, state.z

    -- Translation dots
    local tx = -(rx*cx + ry*cy_pos + rz*cz)
    local ty = -(ux*cx + uy*cy_pos + uz*cz)
    local tz = -(fx*cx + fy*cy_pos + fz*cz)

    -- 3. Multiply Proj * View directly into the 16-float array (Zero Allocation)
    local mat = state.mat
    mat[1] = p00 * rx; mat[5] = p00 * ux; mat[9]  = p00 * -fx; mat[13] = p00 * -tx
    mat[2] = p11 * ry; mat[6] = p11 * uy; mat[10] = p11 * -fy; mat[14] = p11 * -ty
    mat[3] = p23 * fz; mat[7] = p23 * uz; mat[11] = p23 * -fz; mat[15] = p23 * -tz + p32
    mat[4] = p23 * fx; mat[8] = p23 * ux; mat[12] = p23 * -fx; mat[16] = p23 * -tx
end

-- Export purely functional namespace
return {
    create_state = create_state,
    apply_movement = apply_movement,
    apply_look = apply_look,
    build_matrix = build_matrix
}
