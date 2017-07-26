local lfs = require "lfs"

local read_file = function (path)
    local f = assert(io.open(assert(path, "No path provided!"), "r"))
    local contents = f:read("*all")
    f:close()
    return contents
end

local mkdir = function (path)
    if lfs.attributes(path, "mode") == "directory" then return end
    assert(lfs.mkdir(path))
end

return {
    read_file = read_file,
    mkdir = mkdir,
}
