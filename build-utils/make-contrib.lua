local util = require "build-utils.util"
-- Use luakit's customized markdown: it linkifies luakit:// URIs
package.path = "../../luakit/lib/?.lua;" .. package.path
local markdown = require "markdown"

local opts = {
    source = "../../luakit/CONTRIBUTING.md",
    template = "build-utils/contrib_template.html",
    target_dir = "contributing",
}

local make_news_html = function (md)
    local html_template = util.read_file(opts.template)
    md = ("\n"..md):gsub("\n#", "\n##"):sub(2)
    local html = html_template:gsub("{(%w+)}", {
        content = markdown(md),
    })

    util.mkdir(opts.target_dir)
    local dest = opts.target_dir .. "/index.html"
    local f = io.open(dest, "w")
    f:write(html)
    f:close()
    print("Wrote to " .. dest)
end

assert(pcall(util.read_file, ".git/HEAD"), "Not at git root!")
make_news_html(util.read_file(opts.source))
