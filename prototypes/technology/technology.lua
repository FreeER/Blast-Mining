data:extend({
  {
    type = "technology",
    name = "blast-mining",
    icon = "__blast-mining__/graphics/technology/dynamite-tech.png",
    prerequisites = {"explosives", "flame-thrower"},
    effects =
      {
        {
          type = "unlock-recipe",
          recipe = "dynamite"
        }
      },
    unit =
      {
        count = 20,
        ingredients =
          {
            {"science-pack-1", 1},
            {"science-pack-2", 1}
          },
        time = 15
      }
  },
})
