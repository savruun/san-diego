const CharacterProvider = {}

function CharacterProvider.start(self: self) end

--[[
    Respawn a player.
]]
function CharacterProvider.respawn(self: self, player: Player)
    player:LoadCharacterAsync()
end

export type self = typeof(CharacterProvider)
return CharacterProvider