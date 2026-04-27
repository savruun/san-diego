--!strict

const Debris = game:GetService("Debris")
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")
const Players = game:GetService("Players")

const Player = Players.LocalPlayer

const VFX = ReplicatedStorage.assets.vfx
const Bullet = VFX.Bullet
const Impact = VFX.BulletImpact

const BulletContainer = Instance.new("Folder")
BulletContainer.Name = "BulletContainer"
BulletContainer.Parent = workspace

type FireData = {
  position: Vector3,
  origin: Attachment,
  direction: Vector3,
  velocity: number 
}

const CombatProvider = {}

function CombatProvider.start(self: self) end

function CombatProvider.renderBullet(self: self, fireData: FireData): ()
  local bullet = Bullet:Clone()
  bullet.Parent = BulletContainer
  bullet.Position = fireData.position

  local velocity = fireData.direction.Unit * fireData.velocity
  local gravity = Vector3.new(0, -workspace.Gravity * .1, 0)

  local lastPosition = fireData.position

  local muzzleFlash = VFX.MuzzleFlash:Clone()
  muzzleFlash.Parent = fireData.origin
  Debris:AddItem(muzzleFlash, 0.2)

  local connection
  connection = RunService.Heartbeat:Connect(function(delta)
    velocity += gravity * delta

    local params = RaycastParams.new()
    params.ExcludeInstances = { Player.Character :: Instance }
    
    local newPosition = lastPosition + velocity * delta
    local result = workspace:Raycast(lastPosition, newPosition - lastPosition, params)

    if result then
      bullet.Position = result.Position
      bullet:Destroy()

      if connection then
        connection:Disconnect()
      end

      local pos = result.Position + result.Normal * .05
      local forward = -velocity.Unit
      local up = result.Normal

      local impact = Impact:Clone()
      impact.Parent = BulletContainer
      impact.CFrame = CFrame.lookAt(pos, pos + forward, up)

      for _, particle: ParticleEmitter in impact:GetChildren() do
        if not particle:IsA("ParticleEmitter") then continue end
        particle:Emit(3)
      end

      Debris:AddItem(Impact, .5)
      return
    end

    bullet.Position = newPosition
    lastPosition = newPosition
  end)
end

export type self = typeof(CombatProvider)
return CombatProvider
