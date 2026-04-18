--!strict

const dependency = require('@pkg/quill_dependencies')
const constants = require('@shared/constants')

const MovementProvider = {
  isSprinting = false,
  character = nil :: Model?,
  humanoid = nil :: Humanoid?
}

MovementProvider.CharacterProvider = dependency.use(require('./CharacterProvider'))

function MovementProvider.start(self: self): ()
  self.character = self.CharacterProvider:getCharacter()
  self.humanoid = self.CharacterProvider:getHumanoid()

  self.CharacterProvider.spawned:Connect(function(character, humanoid): ()
    self.character = character
    self.humanoid = humanoid

    self:setSprint(false)
  end)
end

function MovementProvider.setSprint(self: self, isSprinting: boolean)
  self.isSprinting = isSprinting
end

export type self = typeof(MovementProvider)
return MovementProvider