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
    game.player.character.insert{name="quantum-tnt", count=10}
    game.player.character.insert{name="quantum-dna-bomb", count=10}
  end
end)

game.onevent(defines.events.onbuiltentity, function(event)
  if (event.createdentity.name == "dynamite") or (event.createdentity.name == "dynamite-bundle") or (event.createdentity.name == "quantum-tnt") or (event.createdentity.name == "quantum-dna-bomb") then
    glob.dynamite[#glob.dynamite+1] = {entity=event.createdentity, tick=event.tick}
    if not glob.dynamite.release then game.player.print("You placed dynamite! RUN? :)") end
  end
end)

game.onevent(defines.events.ontick, function(event)
  for _, dynamite in ipairs(glob.dynamite) do
    if dynamite.entity.valid and not (event.tick%60==1) then 
      if (dynamite.entity.name == "dynamite") and (event.tick - dynamite.tick > 120) and dynamite.entity.valid then dynamite.entity.die()
      elseif (dynamite.entity.name == "dynamite-bundle") and (event.tick - dynamite.tick > 300) and dynamite.entity.valid then dynamite.entity.die()
      elseif (dynamite.entity.name == "quantum-tnt") and (event.tick - dynamite.tick > 600) and dynamite.entity.valid then dynamite.entity.die()
      elseif (dynamite.entity.name == "quantum-dna-bomb") and (event.tick - dynamite.tick > 600) and dynamite.entity.valid then dynamite.entity.die()
      end
    elseif dynamite.entity.valid then
        game.createentity{name="flying-text", text="tick", position=dynamite.entity.position}
    end
  end
end)

game.onevent(defines.events.onentitydied, function(event)
  if (event.entity.name == "dynamite") or (event.entity.name == "dynamite-bundle") or (event.entity.name == "quantum-tnt") then
    local area --area that will be clear/damaged by explosion
    if event.entity.name == "dynamite" then area=1
    elseif event.entity.name == "dynamite-bundle" then area=5
    elseif (event.entity.name == "quantum-tnt") then area=10
    end
    
    for index, dynamite in ipairs(glob.dynamite) do
      --if event.entity.equals(dynamite.entity) then table.remove(glob.dynamite,index) end
      if dynamite.entity.equals(event.entity) then table.remove(glob.dynamite,index) end
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
        game.createentity{name="item-on-ground", position = {event.entity.position.x, event.entity.position.y}, stack={name=resources.name, count=math.random(resources.count)-math.random(resources.count/area)}}
      end
      resources.count = 0
    end
    
    if event.entity.name ~= "quantum-tnt" then causedamage(event.entity, area) end
  end -- end blast mining code
  
  if (event.entity.name == "quantum-dna-bomb") then
    local area=10 --incase I add other bombs, but I don't really think I'll need to lol
    causedamage(event.entity, area, game.forces.enemy)
  end-- end quantum dna bomb code
end) -- end onentitydied

function causedamage(entity, area, force, destroy)
  if destroy == nil then destroy = false end --make destroy false if not given in call
  for _, nearbyentity in ipairs(game.findentities{{entity.position.x-area*3, entity.position.y-area*3}, {entity.position.x+area*3, entity.position.y+area*3}}) do
    if (nearbyentity.name == "dynamite") or (nearbyentity.name == "dynamite-bundle") or (nearbyentity.name == "quantum-tnt") or (nearbyentity.name == "quantum-dna-bomb") then
      for index, dynamite in ipairs(glob.dynamite) do
        if dynamite.entity.equals(nearbyentity) then
          glob.dynamite[index].tick = glob.dynamite[index].tick-60
        end
      end
    elseif force~=nil then
      if nearbyentity.force.equals(force) then
        if nearbyentity.health then
          nearbyentity.die()
        else nearbyentity.destroy()
        end
      end
    elseif nearbyentity.health then nearbyentity.damage(50*area/util.distance(entity.position, nearbyentity.position), game.player.force)
    else
      if destroy then nearbyentity.destroy() end
    end
  end
end
