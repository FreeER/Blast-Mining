function resources()
  local recipe={}
  for _, item in pairs (data.raw.resource) do 
    --table.insert(recipe, {item.name, 1}) --disabled until DyTech update
  end
  table.insert(recipe, {"BMdynamite-bundle", 1})
  table.insert(recipe, {"steel-plate", 10})
  table.insert(recipe, {"alien-artifact", 10})
  return recipe
end

data:extend({
  {
      type = "recipe",
      name = "BMdynamite",
      energy_required = 10,
      ingredients = {{"coal", 10}, {"electronic-circuit", 2}, {"iron-gear-wheel", 3}, {"flame-thrower-ammo", 1}},
      result = "BMdynamite",
      enabled = "false",
      result_count = 1
  },
  {
      type = "recipe",
      name = "BMdynamite-bundle",
      energy_required = 10,
      ingredients = {{"BMdynamite", 10}, {"copper-cable", 10}},
      result = "BMdynamite-bundle",
      enabled = "false",
      result_count = 1
  },
  {
      type = "recipe",
      name = "quantum-tnt",
      energy_required = 10,
      --ingredients = {{"BMdynamite-bundle", 1}, {"steel", 10}, {"alien-artifact", 10}}, --this probably needs to be far more expensive...
      ingredients = resources(), -- or perhaps slightly annoying :)
      result = "quantum-tnt",
      enabled = "false",
      result_count = 1
  },
})

