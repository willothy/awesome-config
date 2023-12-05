local M = {}

function M.ensure_rgba(str)
  if #str < 8 then
    str = str .. "ff"
  end
  return str
end

function M.hex_to_int(str)
  return tonumber(str:gsub("#", ""), 16)
end

function M.int_to_hex(int)
  return string.format("#%08x", int)
end

function M.interpolate(color1, color2, bias)
  local rgba1 = M.hex_to_int(M.ensure_rgba(color1))
  local rgba2 = M.hex_to_int(M.ensure_rgba(color2))

  local r1 = (rgba1 >> 24) & 0xff
  local g1 = (rgba1 >> 16) & 0xff
  local b1 = (rgba1 >> 8) & 0xff
  local a1 = rgba1 & 0xff

  local r2 = (rgba2 >> 24) & 0xff
  local g2 = (rgba2 >> 16) & 0xff
  local b2 = (rgba2 >> 8) & 0xff
  local a2 = rgba2 & 0xff

  local r = math.ceil((r2 - r1) * bias + r1)
  local g = math.ceil((g2 - g1) * bias + g1)
  local b = math.ceil((b2 - b1) * bias + b1)
  local a = math.ceil((a2 - a1) * bias + a1)

  local rgba = (r << 24) | (g << 16) | (b << 8) | a

  return M.int_to_hex(rgba)
end

return M
