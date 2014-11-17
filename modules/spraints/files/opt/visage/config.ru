visage_root = Gem.loaded_specs["visage-app"].gem_dir
config_ru = File.join(visage_root, "lib/visage-app/config.ru")
eval File.read(config_ru), nil, config_ru
