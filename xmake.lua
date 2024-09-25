set_project("squirrel")
set_version("4.6", {build = "%Y%m%d%H%M"})
set_languages("cxx17")
set_description("The Quirrel programming language")
-- set_homepage("http://quirrel.io/")

option("DISABLE_STATIC", {description = "Avoid building/installing static libraries."})
option("LONG_OUTPUT_NAMES", {description = "Use longer names for binaries and libraries: squirrel3 (not sq)."})
option("ENABLE_VAR_TRACE", {description = "Enable variable change tracing feature."})

-- Set the output directories
set_targetdir("$(buildir)/$(plat)/$(arch)/$(mode)")
set_objectdir("$(buildir)/.objs")

-- Compiler and linker settings
if is_plat("windows") then
    add_defines("_CRT_SECURE_NO_WARNINGS")
elseif is_plat("linux") then
    add_cxflags("-fno-strict-aliasing", "-Wall", "-Wextra", "-pedantic", "-Wcast-qual", {force = true})
    if is_mode("release") then
        add_cxflags("-O3", {force = true})
    elseif is_mode("debug") then
        add_cxflags("-pg", "-pie", "-gstabs", "-g3", "-Og", {force = true})
    end
end

-- Target definitions based on options
local libsquirrel_name = "squirrel"
local sqstdlib_name = "sqstdlib"
if has_config("LONG_OUTPUT_NAMES") then
    libsquirrel_name = "squirrel3"
    sqstdlib_name = "sqstdlib3"
end

-- Subdirectories
includes("squirrel/xmake.lua", "sqstdlib/xmake.lua","sqmodules/xmake.lua")
if not has_config("SQ_DISABLE_INTERPRETER") then
    includes("sq/xmake.lua")
end

-- Additional configurations
if is_arch("x86_64") then
    add_defines("_SQ64")
end

-- Installation (if needed)
if not has_config("SQ_DISABLE_INSTALLER") and not has_config("SQ_DISABLE_HEADER_INSTALLER") then
    -- Add installation commands similar to CMake's 'install' directive
end
