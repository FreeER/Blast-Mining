data:extend({
  {
    type = "technology",
    name = "blast-mining",
    icon = "__blast-mining__/graphics/technology/dynamite-tech.png",
    prerequisites = {"explosives"},
    effects =
      {
        {
          type = "unlock-recipe",
          recipe = "BMdynamite"
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
  {
    type = "technology",
    name = "blast-mining-2",
    icon = "__blast-mining__/graphics/technology/dynamite-tech-2.png",
    prerequisites = {"blast-mining"},
    effects =
      {
        {
          type = "unlock-recipe",
          recipe = "BMdynamite-bundle"
        }
      },
    unit =
      {
        count = 200,
        ingredients =
          {
            {"science-pack-1", 1},
            {"science-pack-2", 1}
          },
        time = 15
      },
    upgrade = "true",
  },
  {
    type = "technology",
    name = "blast-mining-3",
    icon = "__blast-mining__/graphics/technology/quantum-explosion.png",
    prerequisites = {"blast-mining-2"},
    effects =
      {
        {
          type = "unlock-recipe",
          recipe = "quantum-tnt"
        }
      },
    unit =
      {
        count = 200,
        ingredients =
          {
            {"science-pack-1", 2},
            {"science-pack-2", 2},
            {"science-pack-3", 2},
            {"alien-science-pack", 1}
          },
        time = 30
      },
    upgrade = "true",
  },
})

if data.raw.fluid["dna"] then
  data:extend({
    {
    type = "technology",
    name = "blast-mining-4",
    icon = "__blast-mining__/graphics/technology/dna.png",
    prerequisites = {"blast-mining-3", "dna"},
    effects =
      {
        {
          type = "unlock-recipe",
          recipe = "quantum-dna-bomb"
        }
      },
    unit =
      {
        count = 200,
        ingredients =
          {
            {"science-pack-1", 2},
            {"science-pack-2", 2},
            {"science-pack-3", 2},
            {"alien-science-pack", 2}
          },
        time = 60
      },
    upgrade = "true",
  }
  })
end