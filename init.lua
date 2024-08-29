
----------------------------------- Helpers ------------------------------------

-- local function dump(var)
--    if type(var) == 'table' then
--       local str = '{ '
--       for key,val in pairs(var) do
--          if type(key) ~= 'number' then key = '"'..key..'"' end
--          str = str .. '['..key..'] = ' .. dump(val) .. ','
--       end
--       return str .. '} '
--    else
--       return tostring(var)
--    end
-- end

require("config.options")
require("config.keymap")
require("config.package_manager")
