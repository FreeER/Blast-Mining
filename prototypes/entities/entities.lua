data:extend({
  {
    type = "container",
    name = "dynamite",
    dying_explosion = "low-huge-explosion",
    minable = {hardness = 0.2, mining_time = 0.5, result = "dynamite"},
    icon = "__blast-mining__/graphics/icons/dynamite-icon.png",
    flags = {"placeable-player", "placeable-enemy", "player-creation", "placeable-off-grid"},
    max_health = 5,
    emissions_per_tick = 20,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    inventory_size = 0,
    picture =
    {
      filename = "__blast-mining__/graphics/entities/dynamite.png",
      width = 14,
      height = 40
    }
  },
  {
  type = "explosion",
  name = "low-huge-explosion",
  animation_speed = 5,
  animations =
  {
    {
      filename = "__base__/graphics/entity/huge-explosion/huge-explosion.png",
      priority = "extra-high",
      frame_width = 111,
      frame_height = 131,
      frame_count = 24,
      line_length = 5
    }
  },
  light = {intensity = 1, size = 50},
  smoke = "smoke",
  smoke_count = 20,
  smoke_slow_down_factor = 1,
  sound =
  {
    {
      filename = "__base__/sound/huge-explosion.wav",
      volume = 0.25
    }
  }
  },
})
