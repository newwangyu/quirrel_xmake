add_rules("mode.debug", "mode.release")

-- Define the source files
local squirrel_src = {
	"sqapi.cpp",
	"sqast.cpp",
	"sqastcodegen.cpp",
	"sqastparser.cpp",
	"sqbaselib.cpp",
	"sqbinaryast.cpp",
	"sqclass.cpp",
	"sqcompilationcontext.cpp",
    "sqcompiler.cpp",
	"sqdebug.cpp",
	"sqdirect.cpp",
    "sqfuncstate.cpp",
    "sqlexer.cpp",
    "sqmem.cpp",
	"sqobject.cpp",
	"sqoptimizer.cpp",
	"sqstate.cpp",
	"sqstringlib.cpp",
    "sqtable.cpp",
	"sqvm.cpp",
	"optimizations/closureHoisting.cpp",
	"static_analyzer/analyzer.cpp"
}

if not has_config("ENABLE_VAR_TRACE") then
	add_files("vartracestub.cpp")
	add_defines("SQ_VAR_TRACE_ENABLED=0")
else
	add_files("vartrace.cpp")
	add_defines("SQ_VAR_TRACE_ENABLED=1")
end
	
-- Shared library target
if not has_config("DISABLE_DYNAMIC") then
    target("squirrel")
        set_kind("shared")
	add_files(squirrel_src)
	if is_plat("windows") then
		add_rules("utils.symbols.export_all", {export_classes = true})
	end
        set_targetdir("$(buildir)/$(plat)/$(arch)/$(mode)")
		add_includedirs("$(projectdir)/include","$(projectdir)/internal", "$(projectdir)/helpers",{public = true})
        if has_config("LONG_OUTPUT_NAMES") then
            set_basename("squirrel3")
        else
            set_basename("squirrel")
        end

        -- Installation (adjust as needed)
        -- after_build(function (target)
        --     os.cp(target:targetfile(), "/path/to/install/")
        -- end)
end

-- Static library target
if not has_config("DISABLE_STATIC") then
    target("squirrel_static")
        set_kind("static")
        add_files(squirrel_src)
        set_targetdir("$(buildir)/$(plat)/$(arch)/$(mode)")
		add_includedirs("$(projectdir)/include","$(projectdir)/internal","$(projectdir)/helpers", {public = true})
        if has_config("LONG_OUTPUT_NAMES") then
            set_basename("squirrel3_static")
        else
            set_basename("squirrel_static")
        end

        -- Installation (adjust as needed)
        -- after_build(function (target)
        --     os.cp(target:targetfile(), "/path/to/install/")
        -- end)
end
