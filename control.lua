require "util"
require "defines"

game.oninit(function()
  glob.dynamite = {}
  glob.resources = {}
  glob.dna = {}
  glob.release = true -- boolean used for easily testing mod during developement, false gives free items oninit and debug statements
  for k, entity in pairs(game.entityprototypes) do
    if entity.type == "resource" then
      local resource = {name=entity.name, count=0}
      table.insert(glob.resources, resource)
    end
  end
  if not glob.release and game.player.character then
    game.player.character.insert{name="BMdynamite", count=10}
    game.player.character.insert{name="BMdynamite-bundle", count=10}
    game.player.character.insert{name="quantum-tnt", count=10}
    game.player.character.insert{name="quantum-dna-bomb", count=10}
  end
end)

game.onevent(defines.events.onbuiltentity, function(event)
  if (event.createdentity.name == "BMdynamite") or (event.createdentity.name == "BMdynamite-bundle") or (event.createdentity.name == "quantum-tnt") or (event.createdentity.name == "quantum-dna-bomb") then
    glob.dynamite[#glob.dynamite+1] = {entity=event.createdentity, tick=event.tick}
    if not glob.release then game.player.print("You placed dynamite! RUN? :)") end
  end
end)

game.onevent(defines.events.ontick, function(event)
  for _, dynamite in ipairs(glob.dynamite) do
    if dynamite.entity.valid and not (event.tick%60==1) then 
      if (dynamite.entity.name == "BMdynamite") and (event.tick - dynamite.tick > 120) and dynamite.entity.valid then dynamite.entity.die()
      elseif (dynamite.entity.name == "BMdynamite-bundle") and (event.tick - dynamite.tick > 300) and dynamite.entity.valid then dynamite.entity.die()
      elseif (dynamite.entity.name == "quantum-tnt") and (event.tick - dynamite.tick > 600) and dynamite.entity.valid then dynamite.entity.die()
      elseif (dynamite.entity.name == "quantum-dna-bomb") and (event.tick - dynamite.tick > 600) and dynamite.entity.valid then dynamite.entity.die()
      end
    elseif dynamite.entity.valid then
        game.createentity{name="flying-text", text="tick", position=dynamite.entity.position}
    end
  end
end)

game.onevent(defines.events.onentitydied, function(event)
  if (event.entity.name == "BMdynamite") or (event.entity.name == "BMdynamite-bundle") or (event.entity.name == "quantum-tnt") then
    local area --area that will be clear/damaged by explosion
    if event.entity.name == "BMdynamite" then area=1
    elseif event.entity.name == "BMdynamite-bundle" then area=5
    elseif (event.entity.name == "quantum-tnt") then area=10
    end
    
    for index, dynamite in ipairs(glob.dynamite) do
      --if event.entity.equals(dynamite.entity) then table.remove(glob.dynamite,index) end
      if dynamite.entity.equals(event.entity) then table.remove(glob.dynamite,index) end
    end
    
    for _, resource in ipairs(game.findentities{getboundingbox(event.entity.position, area)}) do
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
        game.createentity{name="item-on-ground", position = event.entity.position, stack={name=resources.name, count=resources.count-math.random(resources.count/area)}}
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

function causedamage(entity, area, targetforce, destroy)
  if destroy == nil then destroy = false end --make destroy false if not given in call
  for _, nearbyentity in ipairs(game.findentities{getboundingbox(entity.position, area*3)}) do
    if (nearbyentity.name == "BMdynamite") or (nearbyentity.name == "BMdynamite-bundle") or (nearbyentity.name == "quantum-tnt") or (nearbyentity.name == "quantum-dna-bomb") then
      for index, dynamite in ipairs(glob.dynamite) do
        if dynamite.entity.equals(nearbyentity) then
          glob.dynamite[index].tick = glob.dynamite[index].tick-60
          break
        end
      end
    elseif targetforce~=nil then --used with quantum dna bomb to destroy all enemy force entities and to teleport player, should probably do the teleporting elsewhere but...
      if nearbyentity.equals(game.player.character) then --teleport player +-32 in both x and y coords
        randomTeleport(game.player.character, 32)
      end
      if nearbyentity.force.equals(targetforce) then
        if nearbyentity.health then
          nearbyentity.die()
        else nearbyentity.destroy()
        end
      end
    elseif nearbyentity.health then nearbyentity.damage((50*area/util.distance(entity.position, nearbyentity.position)), game.player.force)
    else
      if destroy then nearbyentity.destroy() end
    end
  end
end

function getboundingbox(position, radius)
return {position.x-radius, position.y-radius}, {position.x+radius,position.y+radius}
end

function randomTeleport(entity, distance)
  local position = entity.position
  repeat
    position.x=position.x+math.random(-distance, distance)
    position.y=position.y+math.random(-distance, distance)
  until (game.canplaceentity{name=entity.name, position=position})
  entity.teleport(position)
end
