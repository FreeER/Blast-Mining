--dna mod items
if data.raw.fluid["dna"] then
  data:extend({
    {
      type = "item",
      name = "quantum-dna-bomb",
      place_result = "quantum-dna-bomb",
      icon = "__blast-mining__/graphics/icons/quantum-bomb.png",
      flags = {"goes-to-quickbar"},
      subgroup = "extraction-machine",
      group = "combat",
      order = "a-a",
      stack_size = 10
    },
    {
      type = "container",
      name = "quantum-dna-bomb",
      dying_explosion = "quantum-explosion",
      minable = {hardness = 0.2, mining_time = 0.5, result = "quantum-dna-bomb"},
      icon = "__blast-mining__/graphics/icons/quantum-bomb.png",
      flags = {"placeable-player", "placeable-enemy", "player-creation", "placeable-off-grid"},
      max_health = 30,
      collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      inventory_size = 0,
      picture =
      {
        filename = "__blast-mining__/graphics/entities/quantum-bomb.png",
        width = 50,
        height = 46
      }
    },
    {
      type = "recipe",
      name = "quantum-dna-bomb",
      energy_required = 10,
      ingredients = {{"quantum-tnt", 1}, {type="fluid", name="dna", amount=20}, {"copper-cable", 10}},
      category = "crafting-with-fluid",
      result = "quantum-dna-bomb",
      enabled = "false",
      result_count = 1
    },
  })
end