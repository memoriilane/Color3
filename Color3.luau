--[[
    File:        | Color3.luau
    Author:      | memoriilane
    Description: | started this because i didn't want to use color values from 0 - 1 with figura libraries (i like RGB 255), and i decided to turn it into a roblox Color3 library replica (with a few small changes & minus all the Roblox specific stuff like Color3 being its own type)

    To-Do:
        * make the code less ugly
        * add proper checks

    Notes:
        * small preference changes (like percentages being accepted for saturation and value arguments)
        * Descriptions were taken from the Roblox Documentation site.
        * uhhhh
]]--
--------------------------------------------------------------------------------------------------------------------------------

-- # Important stuff

local Color3                  = {}
local math_abs                = math.abs
local math_max                = math.max
local math_min                = math.min
local string_find             = string.find
local string_format           = string.format
local string_lower            = string.lower
local string_sub              = string.sub
local table_find              = table.find
local CONSTRUCTOR_NAMES       = {"new", "fromRGB", "fromHSV", "fromHex"}
local METHOD_NAMES            = {"Lerp", "ToHSV", "ToHex"}


-- # Main logic

setmetatable(Color3, {
	__index = function(tbl, idx)
		-- Hide Methods from main library
		if (table_find(METHOD_NAMES, idx)) then
			return nil
		end

		return rawget(tbl, idx)
	end
})


local CONSTRUCTOR_METAMETHODS = {
	__index = function(tbl, idx)
		-- Hide constructors inside other constructors
		if (table_find(CONSTRUCTOR_NAMES, idx)) then
			return nil
		end

		-- Expose methods to constructors
        -- CHECK REDUNDANCY
		if (table_find(METHOD_NAMES, idx)) then
			return rawget(Color3, idx)
		end

		return rawget(tbl, idx)
	end
}


-- Returns a Color3 with the given red, green, and blue values. The parameters should be within the range of 0 to 1.
---@param red number
---@param green number
---@param blue number
---@return table {red: number, green: number, blue: number}
function Color3.new(red, green, blue)
    local Color3_object = {
        R = red or 0,
        G = green or 0,
        B = blue or 0
    }

    return setmetatable(Color3_object, CONSTRUCTOR_METAMETHODS)
end


-- Creates a Color3 with the given red, green, and blue components.
---@param red number
---@param green number
---@param blue number
---@return table {red: number, green: number, blue: number}
function Color3.fromRGB(red, green, blue)
    local Color3_object = {
        R = (red   or 0)  / 255,
        G = (green or 0)  / 255,
        B = (blue  or 0)  / 255
    }

    return setmetatable(Color3_object, CONSTRUCTOR_METAMETHODS)
end


-- Creates a Color3 with the given hue, saturation, and value.
---@param hue number
---@param saturation number
---@param value number
---@return table {red: number, green: number, blue: number}
function Color3.fromHSV(hue, saturation, value)
    saturation = ((saturation > 1) and (saturation / 100)) or saturation
    value      = ((value > 1) and (value / 100)) or value

    local r_prime, g_prime, b_prime

    local chroma              = saturation * value
    local X                   = chroma * (1 - math_abs(((hue / 60) % 2) - 1))
    local m                   = value - chroma

    if (hue >= 0) and (hue < 60) then -- 🥀
        r_prime, g_prime, b_prime =
            chroma, X, 0

    elseif (hue >= 60) and (hue < 120) then
        r_prime, g_prime, b_prime =
            X, chroma, 0

    elseif (hue >= 120) and (hue < 180) then
        r_prime, g_prime, b_prime =
            0, chroma, X

    elseif (hue >= 180) and (hue < 240) then
        r_prime, g_prime, b_prime =
            0, X, chroma

    elseif (hue >= 240) and (hue < 300) then
        r_prime, g_prime, b_prime =
            X, 0, chroma

    elseif (hue >= 300) and (hue < 360) then
        r_prime, g_prime, b_prime =
            chroma, 0, X

    end

    local Color3_object = {
        R = r_prime + m,
        G = g_prime + m,
        B = b_prime + m
    }

    return setmetatable(Color3_object, CONSTRUCTOR_METAMETHODS)
end


-- Creates a Color3 with the given red, green, and blue components.
---@param hex string
---@return table {red: number, green: number, blue: number}
function Color3.fromHex(hex)
    hex = string_lower((not string_find(hex, "#") and hex) or string_sub(hex, 2))

    local r_Hex, g_Hex, b_Hex =
        string_sub(hex, 1, 2),
        string_sub(hex, 3, 4),
        string_sub(hex, 5, 6)

    local Color3_object = {
        red   = tonumber(r_Hex, 16),
        green = tonumber(g_Hex, 16),
        blue  = tonumber(b_Hex, 16),
    }

    return setmetatable(Color3_object, CONSTRUCTOR_METAMETHODS)
end


-- Returns a Color3 interpolated between two colors. The alpha value should be within the range of 0 to 1.
---@param color table
---@param alpha number
function Color3:Lerp(color, alpha)
    local new_red, new_green, new_blue =
        self.R + (color.R - self.R) * alpha,
        self.G + (color.G - self.G) * alpha,
        self.B + (color.B - self.B) * alpha

    local Color3_object = {
        R = new_red,
        G = new_green,
        B = new_blue
    }

    return setmetatable(Color3_object, CONSTRUCTOR_METAMETHODS)
end


-- Returns the hue, saturation, and value of a Color3. This function is the inverse operation of the Color3.fromHSV() constructor.
---@param self table
---@return number hue
---@return number saturation
---@return number value
function Color3:ToHSV()
    local r_prime, g_prime, b_prime = (self.R / 255), (self.G / 255), (self.B / 255)

    local C_Max = math_max(r_prime, g_prime, b_prime)
    local C_Min = math_min(r_prime, g_prime, b_prime)
    local delta = (C_Max - C_Min)

    local hue, saturation, value

    hue =
        delta == 0 and (0)                                              or
        C_Max == r_prime and (60 * (((g_prime - b_prime) / delta) % 6)) or
        C_Max == g_prime and (60 * (((b_prime - r_prime) / delta) + 2)) or
        C_Max == b_prime and (60 * (((g_prime - b_prime) / delta) + 4))

    saturation =
        C_Max == 0 and (0) or
        C_Max ~= 0 and (delta / C_Max)

    value =
		math.clamp((C_Max * 255), 0, 1)

	hue = (hue % 360) / 360

    return hue, saturation, value
end


-- Converts the color to a six-character hexadecimal string representing the color in the format RRGGBB. It is not prefixed with an octothorpe (#).
---@param red number
---@param green number
---@param blue number
---@return string hexcode
function Color3:ToHex(red, green, blue)
	return string_format("%x%x%x", ((self.R > 1 and self.R) or self.R * 255), ((self.G > 1 and self.G) or self.G * 255), ((self.B > 1 and self.B) or self.B * 255))
end

--------------------------------------------------------------------------------------------------------------------------------

return Color3
