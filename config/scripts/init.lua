-----------------
-- lua scripts --
-----------------

local beautiful = require('beautiful')

require('config.scripts.screenshot')
if beautiful.kb_layout1 ~= beautiful.kb_layout2 then
    require('config.scripts.language')
end
