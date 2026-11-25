-- Resolve from this module's location rather than assuming KOReader's default plugin directory.
local source = debug.getinfo(1, "S").source
local root = assert(source:match("^@(.*)common/kb_plugin_root%.lua$"), "Cannot locate the KOBrowser plugin root")

if root == "" then
    return "."
end
return root == "/" and root or root:sub(1, -2)
