local util = require "build-utils.util"
-- Use luakit's customized markdown: it linkifies luakit:// URIs
package.path = "../../luakit/lib/?.lua;" .. package.path
local markdown = require "markdown"

local opts = {
    changelog = "../../luakit/CHANGELOG.md",
    template = "build-utils/news_template.html",
    target_dir = "news",
}

local split_string = function (s, pattern)
    local pos, ret = 1, {}
    local fstart, fend = string.find(s, pattern, pos)
    while fstart do
        table.insert(ret, string.sub(s, pos, fstart - 1))
        pos = fend + 1
        fstart, fend = string.find(s, pattern, pos)
    end
    table.insert(ret, string.sub(s, pos))
    return ret
end

local html_template
local make_news_html = function (release, is_latest)
    local md, ver = release.markdown, release.version
    local lrt = is_latest and " - latest release" or ""
    md = "## Luakit " .. ver .. lrt .. "\n" .. md
    html_template = html_template or util.read_file(opts.template)
    local html = html_template:gsub("{(%w+)}", {
        changelog = markdown(md),
        version = ver,
    })

    local dest = opts.target_dir .. "/luakit-" .. ver:gsub("%-", ".") .. ".html"
    local f = io.open(dest, "w")
    f:write(html)
    f:close()
    print("Wrote to " .. dest)
end

local split_changelog = function ()
    local changelog = util.read_file(opts.changelog)
    changelog = "\n" .. changelog:gsub("## %[Unreleased%]", ""):gsub("# Changelog.-\n## ", "## ")

    local parts = split_string(changelog, "\n## ")
    table.remove(parts, 1)
    for i, part in ipairs(parts) do
        parts[i] = {
            version = assert(part:match("^%[([0-9-]+)%]\n"), "Bad version!"),
            markdown = part:gsub("^%[([0-9-]+)%]\n", ""),
        }
    end
    return parts
end

assert(pcall(util.read_file, ".git/HEAD"), "Not at git root!")
util.mkdir(opts.target_dir)
local parts = split_changelog()

for i, part in ipairs(parts) do
    make_news_html(part, i == 1)
end

local make_news_index = function (releases)
    local contents = "<h2>Luakit releases</h2>"
    for i, release in ipairs(releases) do
        local lrt = i==1 and " - latest release" or ""
        local ver = release.version
        local hdr = "Luakit " .. ver .. lrt .. "\n"
        contents = contents .. '<li><h3><a href="/luakit/news/luakit-'.. ver:gsub("%-", ".") .. '.html">' .. hdr .. "</a></h3></li>"
    end
    contents  = contents .. "</ul>"

    local html = assert(html_template):gsub("{(%w+)}", {
        changelog = contents,
        version = "releases",
    })

    local dest = opts.target_dir .. "/index.html"
    local f = io.open(dest, "w")
    f:write(html)
    f:close()
    print("Wrote to " .. dest)
end

make_news_index(parts)
