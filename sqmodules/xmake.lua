add_rules("mode.debug", "mode.release")

-- Define the source files
local squirrel_src = {
	"path.cpp",
	"sqmodules.cpp"
}

-- Shared library target
if not has_config("DISABLE_DYNAMIC") then
    target("sqmodules")
        set_kind("shared")
		add_files(squirrel_src)
		add_deps("squirrel","sqstdlib")
		add_rules("utils.symbols.export_all", {export_classes = true})
        set_targetdir("$(buildir)/$(plat)/$(arch)/$(mode)")
		add_includedirs("$(projectdir)/include","$(projectdir)/sqmodules",  {public = true})
        if has_config("LONG_OUTPUT_NAMES") then
			set_basename("sqmodules3")
        else
			set_basename("sqmodules")
        end

        -- Installation (adjust as needed)
        -- after_build(function (target)
        --     os.cp(target:targetfile(), "/path/to/install/")
        -- end)
end

-- Static library target
if not has_config("DISABLE_STATIC") then
	target("sqmodules_static")
        set_kind("static")
		add_files(squirrel_src)
		add_deps("squirrel","sqstdlib_static")
        set_targetdir("$(buildir)/$(plat)/$(arch)/$(mode)")
		add_includedirs("$(projectdir)/include","$(projectdir)/sqmodules", {public = true})
        if has_config("LONG_OUTPUT_NAMES") then
			set_basename("sqmodules3_static")
        else
			set_basename("sqmodules_static")
        end

        -- Installation (adjust as needed)
        -- after_build(function (target)
        --     os.cp(target:targetfile(), "/path/to/install/")
        -- end)
end
