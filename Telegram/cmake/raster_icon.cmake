# This file is part of Telegram Desktop,
# the official desktop application for the Telegram messaging service.
#
# This code is in Public Domain, see license terms in .github/CONTRIBUTING.md
# Copyright (C) 2020, Nicholas Guriev <guriev-ns@ya.ru>

# Add rules to rasterization SVG-icons into PNG-images at build time.
#
# The function defines a custom command to convert an SVG file in current
# source directory to a PNG raster. An optional third parameter specifies
# final resolution of the result (first number is width, second one is height).
#
# Example:
#   raster_icon(in_image.svg out_image.png 800x600)
#
function (raster_icon source result)
    if (ARGN MATCHES "^([0-9]+)x([0-9]+)$")
        set(width ${CMAKE_MATCH_1})
        set(height ${CMAKE_MATCH_2})
    elseif (ARGN)
        message(FATAL_ERROR "Invalid output size")
    endif()
    get_filename_component(in_path ${source} ABSOLUTE)
    get_filename_component(image_name ${result} NAME)

    get_filename_component(cairosvg_path cairosvg PROGRAM CACHE)
    get_filename_component(rsvg-convert_path rsvg-convert PROGRAM CACHE)
    get_filename_component(inkscape_path inkscape PROGRAM CACHE)
    get_filename_component(svgexport_path svgexport PROGRAM CACHE)
    get_filename_component(im-convert_path convert PROGRAM CACHE)
    if (cairosvg_path)
        set(tool_name "CairoSVG")
        set(cmd ${cairosvg_path} ${in_path} -o ${result})
        if (width AND height)
            list(APPEND cmd -W ${width} -H ${height})
        endif()
    elseif (rsvg-convert_path)
        set(tool_name "librsvg")
        set(cmd ${rsvg-convert_path} ${in_path} -o ${result})
        if (width AND height)
            list(APPEND cmd -a -w ${width} -h ${height})
        endif()
    elseif (inkscape_path)
        set(tool_name "Inkscape")
        set(cmd ${inkscape_path} ${in_path} --export-png ${result})
        if (width AND height)
            list(APPEND cmd -w ${width} -h ${height})
        endif()
    elseif (svgexport_path)
        set(tool_name "svgexport")
        set(cmd ${svgexport_path} ${in_path} ${result})
        if (width AND height)
            list(APPEND cmd "${width}:${height}" pad)
        endif()
    elseif (im-convert_path)
        set(tool_name "ImageMagick")
        if (NOT width OR NOT height)
            set(cmd ${im-convert_path} -background none ${in_path} ${result})
        else()
            set(cmd ${im-convert_path} -background none
                -resize "${width}x${height}" ${in_path} ${result})
        endif()
    else()
        message(FATAL_ERROR "No CairoSVG, librsvg, Inkscape, svgexport, "
                "or ImageMagick found.")
    endif()

    add_custom_command(
        OUTPUT ${result}
        DEPENDS ${source}
        COMMAND ${cmd}
        COMMENT "Rasterizing ${image_name} with ${tool_name}"
        VERBATIM COMMAND_EXPAND_LISTS
    )
endfunction()
