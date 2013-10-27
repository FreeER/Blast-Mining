require "util"
require "defines"
-- todo incoporate quantum
game.oninit(function()
  glob.dynamite = {}
  glob.resources = {}
  glob.dynamite.release = false -- boolean used for easily testing mod during developement, false gives free items oninit and possibly debug statements
  for k, entity in pairs(game.entityprototypes) do
    if entity.type == "resource" then
      local resource = {name=entity.name, count=0}
      table.insert(glob.resources, resource)
    end
  end
  if not glob.dynamite.release and game.player.character then
    game.player.character.insert{name="dynamite", count=10}
    game.player.character.insert{name="dynamite-bundle", count=10}
  end
end)

game.onevent(defines.events.onbuiltentity, function(event)
  if (event.createdentity.name == "dynamite") or (event.createdentity.name == "dynamite-bundle") then
    glob.dynamite[#glob.dynamite+1] = {entity=event.createdentity, tick=event.tick}
    game.player.print("You placed dynamite! RUN? :)")
  end
end)

game.onevent(defines.events.ontick, function(event)
  for _, dynamite in ipairs(glob.dynamite) do
    if dynamite.entity.name == "dynamite" then 
      if (event.tick - dynamite.tick > 120) and dynamite.entity.valid then dynamite.entity.die() end
    elseif dynamite.entity.name == "dynamite-bundle" then
      if (event.tick - dynamite.tick > 300) and dynamite.entity.valid then dynamite.entity.die() end
    end
  end
end)

game.onevent(defines.events.onentitydied, function(event)
  if (event.entity.name == "dynamite") or (event.entity.name == "dynamite-bundle") then
    local area --area that will be clear/damaged by explosion
    if event.entity.name == "dynamite" then area=1
    elseif event.entity.name == "dynamite-bundle" then area=5
    end
    
    for k,v in ipairs(glob.dynamite) do
      if event.entity.equals(v.entity) then table.remove(glob.dynamite,k) end
    end
    
    for _, resource in ipairs(game.findentities{{event.entity.position.x-area, event.entity.position.y-area},{event.entity.position.x+area,event.entity.position.y+area}}) do
      for i, reslist in ipairs(glob.resources) do 
        if resource.name == reslist.name then
          reslist.count = reslist.count+resource.amount
          resource.destroy()
          break
        end
      end
    end
    
    for _, resources in ipairs(glob.resources) do
      if resources.count > 0 then
        game.createentity{name="item-on-ground", position = {event.entity.position.x, event.entity.position.y}, stack={name=resources.name, count=math.random(resources.count)}}
      end
      resources.count = 0
    end
    
    for _, nearbyentity in ipairs(game.findentities{{event.entity.position.x-area*3, event.entity.position.y-area*3}, {event.entity.position.x+area*3, event.entity.position.y+area*3}}) do
        if (nearbyentity.name == "dynamite") or (nearbyentity.name == "dynamite-bundle") then
          for i,v in ipairs(glob.dynamite) do
            if nearbyentity.equals(v.entity) then
              glob.dynamite[i].tick = glob.dynamite[i].tick-60
            end
          end
        elseif nearbyentity.health then nearbyentity.damage(50*area/util.distance(event.entity.position, nearbyentity.position), game.player.force)
        end
    end
  end
end)
