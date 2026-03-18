# Color3
A Color library, written in Lua.

## Features
* Create new Color3
	* Supports [Decimal/Arithmetic RGB](https://en.wikipedia.org/wiki/RGB_color_model#Numeric_representations), [8-bit RGB](https://en.wikipedia.org/wiki/RGB_color_model#Numeric_representations), [HSV](https://en.wikipedia.org/wiki/HSL_and_HSV), or [Hexadecimal](https://en.wikipedia.org/wiki/Web_colors#Extended_colors)
* Convert from Decimal/Arithmetic RGB
	* To HSV or Hexadecimal
* Linear Interpolation
	* Also called [Lerp](https://facelessuser.github.io/coloraide/interpolation/)

## Notes
* I originally wrote this because I wanted to use Roblox-style colors with a [Figura](https://figuramc.org/) library, but realized that the library only supported Decimal/Arithmetic RGB. I have tested and can say that this works in both Figura and Roblox environments.
* Other than the Color3 type itself, this is <i>(almost)</i> functionally identical to [Roblox's Color3 library](https://create.roblox.com/docs/reference/engine/datatypes/Color3).
