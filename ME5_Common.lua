-- **************************************************************
-- MASS EFFECT: UNIFICATION Common Function Library
-- Aaron Gilbert - Marth8880@gmail.com
-- Copyright (c) 2021 Aaron Gilbert. All rights reserved.
-- 
-- About: 
--  <script description>
-- 
-- Legal:
--  REPRODUCTION OR TRANSMISSION OF ALL OR PART OF THIS COPYRIGHT WORK IN ANY MEDIUM OR BY ELECTRONIC MEANS WITHOUT THE WRITTEN PERMISSION OF AARON GILBERT IS PROHIBITED.
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-- **************************************************************

local __SCRIPT_NAME = "ME5_Common";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

local _;
local pairs = pairs;
local ipairs = ipairs;

-- ********************************
-- DEBUG FUNCTIONS
-- ********************************
Debug = {};

-- If condition is false, prints a message to the debug log
function Debug.Warning(condition, ...)
	if not condition then
		print("[Warning]", unpack(arg));
		return false;
	else
		return true;
	end
end

-- `assert` but with '[Assert]' prepended to the message
function Debug.Assert(condition, ...)
	arg[1] = "[Assert]\t"..arg[1];
	return assert(condition, unpack(arg));
end

-- ********************************
-- MISC FUNCTIONS
-- ********************************

-- Gets the length of the specified table or string
function getn(v)
	local v_type = type(v);
	if v_type == "table" then
		return table.getn(v);
	elseif v_type == "string" then
		return string.len(v);
	else
		return;
	end
end

-- Returns true if the specified number is between the specified min and max
function IsBetween(v, min, max)
	local v_type = type(v);
	if v_type == "number" then
		return v >= min and v <= max;
	else
		return;
	end
end

-- ********************************
-- STRING FUNCTIONS
-- ********************************

-- If string begins with another string
function string.starts(str, Start)
	return string.sub(str, 1, getn(Start)) == Start;
end

-- If string ends with another string
function string.ends(str, End)
	return End == "" or string.sub(str, -getn(End)) == End;
end

-- Splits string by one or more delimiter characters into a table
function string.split(source, delimiters)
	local elements = {};
	local pattern = "([^"..delimiters.."]+)";
	string.gsub(source, pattern, function(value) elements[getn(elements) + 1] = value; end);
	return elements;
end

-- Lua implementation of C#'s String.Format method. Token indexes must be 1-based.
-- 
-- Usage: 
--     string.formatcs("first = {1}, second = {2}, third = {3}", "value one", "value two", "value three")
-- 
-- This example would return the following string:
--     first = value one, second = value two, three = value three
-- 
-- Further documentation: https://msdn.microsoft.com/en-us/library/system.string.format
function string.formatcs(str, ...)
	if getn(arg) > 0 then
		for k,v in ipairs(arg) do
			str = string.gsub(str, "{"..(k).."}", tostring(arg[k]));
		end
	end
	return str;
end

-- ********************************
-- MATH FUNCTIONS
-- ********************************

-- Clamps value between low and high range values
function math.clamp(n, low, high)
	if n < low then
		return low
	elseif n > high then
		return high
	else
		return n
	end
end

-- ********************************
-- TABLE FUNCTIONS
-- ********************************

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- Derived from https://gist.github.com/hashmal/874792 and https://gist.github.com/xytis/5361405
function tprint(tbl, indent)
	if not indent then
		indent = 1
		print(tostring(tbl))
	end
	if tbl then
		for k, v in pairs(tbl) do
			if not string.starts(tostring(k), "__") then
				formatting = string.rep("  ", indent) .. k .. ": "
				if type(v) == "table" then
					print(formatting)
					tprint(v, indent + 1)
				else
					print(formatting .. tostring(v))
				end
			end
		end
	end
end