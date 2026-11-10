import gi
gi.require_version('Gimp', '3.0')
gi.require_version('Gegl', '0.4')
from gi.repository import Gimp, Gio, Gegl

Gegl.init(None)

def generate_wallpaper(name, width, height, filename):
    wallpaper = Gimp.Image.new(width, height, Gimp.ImageBaseType.RGB)

    object_file = Gio.File.new_for_path(f"gimp/{name}.xcf")
    object_layer = Gimp.file_load_layer(Gimp.RunMode.NONINTERACTIVE, wallpaper, object_file)

    backdrop = Gimp.Layer.new(wallpaper, "bg", width, height, Gimp.ImageType.RGBA_IMAGE, 100, Gimp.LayerMode.NORMAL)
    grain = Gimp.Layer.new(wallpaper, "grain", width, height, Gimp.ImageType.RGBA_IMAGE, 15, Gimp.LayerMode.GRAIN_MERGE)
    gradient_x = Gimp.Layer.new(wallpaper, "gradient-x", width, height, Gimp.ImageType.RGBA_IMAGE, 100, Gimp.LayerMode.SOFTLIGHT)
    gradient_y = Gimp.Layer.new(wallpaper, "gradient-y", width, height, Gimp.ImageType.RGBA_IMAGE, 100, Gimp.LayerMode.SOFTLIGHT)

    center_x = width / 2
    center_y = height / 2
    if width > height:
        scale_factor = (height / 2000) if height < 2000 else 1
    else:
        scale_factor = (width / 2000) if width < 2000 else 1

    object_x1 = center_x - scale_factor * 850
    object_x2 = center_x + scale_factor * 850
    object_y1 = center_y - scale_factor * 850
    object_y2 = center_y + scale_factor * 850

    wallpaper.insert_layer(object_layer, None, 0)

    _, picked_color = wallpaper.pick_color([object_layer], 0, 0, True, True, 850)
    Gimp.context_set_foreground(picked_color)

    wallpaper.insert_layer(backdrop, None, 1)
    backdrop.fill(Gimp.FillType.FOREGROUND)

    wallpaper.insert_layer(grain, None, 0)
    pattern = Gimp.Pattern.get_by_name("Film Grain (Vertical)")
    Gimp.context_set_pattern(pattern)
    grain.fill(Gimp.FillType.PATTERN)

    noise_filter = Gimp.DrawableFilter.new(grain, "gegl:noise-spread", "spread")
    noise_config = noise_filter.get_config()
    noise_config.set_property("amount-x", 128)
    noise_config.set_property("amount-y", 128)
    noise_config.set_property("seed", 0)
    grain.append_filter(noise_filter)

    black = Gegl.Color.new('black')
    Gimp.context_set_foreground(black)
    wallpaper.insert_layer(gradient_y, None, 0)
    wallpaper.insert_layer(gradient_x, None, 0)

    object_layer.transform_scale(object_x1, object_y1, object_x2, object_y2)

    Gimp.context_set_paint_mode(Gimp.LayerMode.NORMAL)
    Gimp.context_set_opacity(100)
    Gimp.context_set_gradient_reverse(True)
    Gimp.context_set_gradient_repeat_mode(Gimp.RepeatMode.NONE)
    Gimp.context_set_gradient_fg_transparent()

    gradient_y.edit_gradient_fill(Gimp.GradientType.RADIAL, 0, True, 3, 0.2, True, center_x, center_y, center_x, 0)
    gradient_x.edit_gradient_fill(Gimp.GradientType.RADIAL, 0, True, 3, 0.2, True, center_x, center_y, 0, center_y)

    if width < height:
        wallpaper.raise_item_to_top(gradient_y)

    if name == "saturn":
        rings_file = Gio.File.new_for_path("gimp/rings.xcf")
        rings = Gimp.file_load_layer(Gimp.RunMode.NONINTERACTIVE, wallpaper, rings_file)
        rings_x1 = (center_x - scale_factor * 1652) + scale_factor * 97
        rings_x2 = (center_x + scale_factor * 1652) + scale_factor * 97
        rings_y1 = (center_y - scale_factor * 1134) + scale_factor * 95
        rings_y2 = (center_y + scale_factor * 1134) + scale_factor * 95
        wallpaper.insert_layer(rings, None, 4)
        rings.transform_scale(rings_x1, rings_y1, rings_x2, rings_y2)
        wallpaper.select_item(Gimp.ChannelOps.ADD, rings)
    else:
        wallpaper.select_item(Gimp.ChannelOps.ADD, object_layer)

    Gimp.Selection.invert(wallpaper)
    gradient_x.add_mask(gradient_x.create_mask(Gimp.AddMaskType.SELECTION))
    gradient_y.add_mask(gradient_y.create_mask(Gimp.AddMaskType.SELECTION))
    Gimp.Selection.none(wallpaper)

    wallpaper.flatten()
    out_file = Gio.File.new_for_path(filename)
    Gimp.file_save(Gimp.RunMode.NONINTERACTIVE, wallpaper, out_file, None)
    wallpaper.delete()

generate_wallpaper("__NAME__", __WIDTH__, __HEIGHT__, "__FILENAME__")
