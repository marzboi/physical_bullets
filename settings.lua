data:extend({
    {
        type = "bool-setting",
        name = "magazine-modifier",
        setting_type = "startup",
        default_value = false,
    },
    {
        type = "int-setting",
        name = "magazine_round_capacity",
        setting_type = "startup",
        default_value = 10,
        minimum_value = 5,
        maximum_value = 50,
    },
    {
        type = "double-setting",
        name = "bullet_speed",
        setting_type = "startup",
        default_value = 1.0,
        minimum_value = 1.0,
        maximum_value = 5.0,
    },
})
