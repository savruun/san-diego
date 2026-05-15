--!strict

const Players = game:GetService('Players')
const Player = Players.LocalPlayer

const Signal = require('@shared/lib/Signal')

const CharacterProvider = {
  character = nil :: Model?,
  humanoid  = nil :: Humanoid?,
  spawned = Signal.new<<(Model, Humanoid)>>()
}

function CharacterProvider.start(self: self): ()
  self.character = Player.Character
  self.humanoid = self.character and self.character:FindFirstChildOfClass('Humanoid')
  print('started')
  Player.CharacterAdded:Connect(function(char): ()
    self.character = char
    self.humanoid = char:WaitForChild('Humanoid') :: Humanoid
    self.spawned:Fire(self.character :: Model, self.humanoid :: Humanoid)
  end)
end

function CharacterProvider.getCharacter(self: self): Model
  return self.character :: Model
end

function CharacterProvider.getHumanoid(self: self): Humanoid
  return self.humanoid :: Humanoid
end

export type self = typeof(CharacterProvider)
return CharacterProvider