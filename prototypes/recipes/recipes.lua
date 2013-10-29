function resources()
  local recipe={}
  for _, item in pairs (data.raw.resource) do 
    table.insert(recipe, {item.name, 1})
  end
  table.insert(recipe, {"dynamite-bundle", 1})
  table.insert(recipe, {"steel-plate", 10})
  table.insert(recipe, {"alien-artifact", 10})
  return recipe
end

data:extend({
  {
      type = "recipe",
      name = "dynamite",
      energy_required = 10,
      ingredients = {{"coal", 10}, {"electronic-circuit", 2}, {"iron-gear-wheel", 3}, {"flame-thrower-ammo", 1}},
      result = "dynamite",
      enabled = "false",
      result_count = 1
  },
  {
      type = "recipe",
      name = "dynamite-bundle",
      energy_required = 10,
      ingredients = {{"dynamite", 10}, {"copper-cable", 10}},
      result = "dynamite-bundle",
      enabled = "false",
      result_count = 1
  },
  {
      type = "recipe",
      name = "quantum-tnt",
      energy_required = 10,
      ingredients = resources(),
      --ingredients = {{"dynamite-bundle", 1}, {"steel", 10}, {"alien-artifact", 10}}, --this probably needs to be far more expensive...
      result = "quantum-tnt",
      enabled = "false",
      result_count = 1
  },
  {
      type = "recipe",
      name = "quantum-dna-bomb",
      energy_required = 10,
      ingredients = {{"quantum-tnt", 1}, {"copper-cable", 10}}, --change copper cables, some new item gather from corpses perhaps?
      result = "quantum-dna-bomb",
      enabled = "false",
      result_count = 1
  }
})
