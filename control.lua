require "util"
require "defines"

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
  if not glob.dynamite.release and game.player.character then game.player.character.insert{name="dynamite", count=10} end
end)

game.onevent(defines.events.onbuiltentity, function(event)
  if event.createdentity.name == "dynamite" then
    glob.dynamite[#glob.dynamite+1] = {entity=event.createdentity, tick=event.tick}
    game.player.print("You placed dynamite! RUN? :)")
  end
end)

game.onevent(defines.events.ontick, function(event)
  for _, dynamite in ipairs(glob.dynamite) do
    if (event.tick - dynamite.tick > 120) and dynamite.entity.valid then dynamite.entity.die() end
  end
end)

game.onevent(defines.events.onentitydied, function(event)
  if event.entity.name == "dynamite" then
    for k,v in ipairs(glob.dynamite) do
      if event.entity.equals(v.entity) then table.remove(glob.dynamite,k) end
    end
    
    for _, resource in ipairs(game.findentities{{event.entity.position.x-1, event.entity.position.y-1},{event.entity.position.x+1,event.entity.position.y+1}}) do
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
    
    for _, nearbyentity in ipairs(game.findentities{{event.entity.position.x-3, event.entity.position.y-3}, {event.entity.position.x+3, event.entity.position.y+3}}) do
        if nearbyentity.name == "dynamite" then
          for i,v in ipairs(glob.dynamite) do
            if nearbyentity.equals(v.entity) then
              glob.dynamite[i].tick = glob.dynamite[i].tick-60
            end
          end
        elseif nearbyentity.health then nearbyentity.damage(20, game.player.force)
        end
    end
  end
end)
