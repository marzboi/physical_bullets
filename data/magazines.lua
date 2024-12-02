local bullet_speed = settings.startup["bullet_speed"].value

local make_bullet_entity = function(param)
  data:extend
  {
    {
      type = "projectile",
      name = param.name,
      flags = {"not-on-map"},
      collision_box = {{-0.5, -0.25}, {0.5, 0.25}},
      hit_collision_mask = {
        layers = {
          object = true,
          player = true
        },
        not_colliding_with_itself = false
      },
      acceleration = 0,
      direction_only = true,
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects = param.target_effects
        }
      },
      animation =
      {
        filename = param.filename or "__Physical_Bullets__/graphics/entity/projectile/rifle-bullet-1.png",
        frame_count = 1,
        width = 3,
        height = 50,
        priority = "high"
      },
      shadow =
      {
        filename = param.filename or "__Physical_Bullets__/graphics/entity/projectile/rifle-bullet-1.png",
        frame_count = 1,
        width = 3,
        height = 50,
        priority = "high",
        draw_as_shadow = true
      },
      hit_at_collision_position = true,
      force_condition = "not-same",
      light = {intensity = 0.6, size = 4, color = param.light_color or {r=1.0, g=1.0, b=0.5}},
    }
  }
  return
  {
    type = "direct",
    action_delivery =
    {
      {
        type = "projectile",
        projectile = param.name,
        starting_speed = param.bullet_speed or bullet_speed,
        direction_deviation = param.direction_deviation or 0.02,
        range_deviation = param.range_deviation or 0.02,
        max_range = param.max_range or 35
      }
    }
  }
end


local make_ammo_type = function(ammo_type, name)
  -- ammo_type.target_type = "direction"

  local actions = (ammo_type.action and ammo_type.action[1] and ammo_type.action) or {ammo_type.action}

  local new_target_effects = {}
  for k, action in pairs (actions) do
    local action_deliverys = action.action_delivery and action.action_delivery[1] and action.action_delivery or {action.action_delivery}
    for k, delivery in pairs (action_deliverys) do
      if delivery.target_effects then
        for k, effect in pairs (delivery.target_effects and delivery.target_effects[1] and delivery.target_effects or {delivery.target_effects}) do
          table.insert(new_target_effects, effect)
        end
        delivery.target_effects = nil
      end
    end
  end

  if next(new_target_effects) then
    local bullet

    if name == "piercing-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-piercing.png",
        light_color = {r=1.0, g=0.5, b=0.2}
      }
    elseif name == "uranium-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-uranium.png",
        light_color = {r=0.5, g=1.0, b=0.2}
      }
    elseif name == "acid-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-acid.png",
        light_color = {r=0.2, g=1.0, b=1.0}
      }
    elseif name == "fire-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-fire.png",
        light_color = {r=1.0, g=0.7, b=0.3}
      }
    elseif name == "fmj-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-fmj.png",
        light_color = {r=0.3, g=0.8, b=0.8}
      }
    elseif name == "he-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-he.png",
        light_color = {r=1.0, g=0.2, b=0.6}
      }
    elseif name == "sp-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-sp.png",
        light_color = {r=0.6, g=0.2, b=1.0}
      }
    elseif name == "tungsten-rounds-magazine" then
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-tungsten.png",
        light_color = {r=1.0, g=1.0, b=1.0}
      }
    else
      bullet = make_bullet_entity {
        target_effects = new_target_effects,
        name = name .. "-projectile",
        filename = "__Physical_Bullets__/graphics/entity/projectile/bullet-standard.png",
        light_color = {r=1.0, g=1.0, b=0.5}
      }
    end

    table.insert(actions, bullet)
  end

  ammo_type.action = actions
end

local magazine_modifier = settings.startup["magazine-modifier"].value

for k, ammo in pairs(data.raw.ammo) do
  if ammo.ammo_category == "bullet" then
    make_ammo_type(ammo.ammo_type, ammo.name)
      if magazine_modifier then
        ammo.magazine_size = settings.startup["magazine_round_capacity"].value
      end
  end
end

