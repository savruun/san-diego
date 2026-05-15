--!strict

const Debris = game:GetService('Debris')
const Players = game:GetService('Players')
const ReplicatedStorage = game:GetService('ReplicatedStorage')
const RunService = game:GetService('RunService')

const constants = require('@shared/constants')
const net = require('@client/net')
const gunData = require("../../../shared/data/gunData")

const LocalPlayer = Players.LocalPlayer

const VFX = ReplicatedStorage:WaitForChild('assets'):WaitForChild('vfx')
const BulletTemplate = VFX:WaitForChild('Bullet') :: BasePart
const ImpactTemplate = VFX:WaitForChild('BulletImpact') :: Attachment
const MuzzleFlashTemplate = VFX:WaitForChild('MuzzleFlash') :: Attachment

const GRAVITY = constants.GRAVITY

const BulletContainer = Instance.new('Folder')
BulletContainer.Name = 'BulletContainer'
BulletContainer.Parent = workspace

type FireData = {
	origin: Attachment,
  position: Vector3,
	direction: Vector3,
	range: number,
	velocity: number
}

const CombatProvider = {}

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function createImpact(position: Vector3, normal: Vector3, velocity: Vector3)
	local impact = ImpactTemplate:Clone()

	local forward = -velocity.Unit
	local offsetPosition = position + normal * 0.05

	impact.CFrame = CFrame.lookAt(offsetPosition, offsetPosition + forward, normal)
	impact.Parent = BulletContainer

	for _, descendant in impact:GetDescendants() do
		if descendant:IsA('ParticleEmitter') then
			descendant:Emit(3)
		end
	end

	Debris:AddItem(impact, 0.5)
end

local function createMuzzleFlash(origin: Attachment)
	local muzzleFlash = MuzzleFlashTemplate:Clone()

	muzzleFlash.Parent = origin

	Debris:AddItem(muzzleFlash, 0.2)
end

function CombatProvider.start(self: self)
	raycastParams.FilterDescendantsInstances = {
		LocalPlayer.Character :: Instance
	}

  net.RenderBullet.On(function(data)
    const directions = data.directions
    if not directions then return end

    local gunStats = gunData.getDataFromName(data.gunType)
    if not gunStats then return end -- Should never be true

    local mode = gunData.normalizeMode(gunStats.modes[data.mode :: gunData.GunFireMode])
    
    for index, direction in directions do
      self:renderBullet({
        direction = direction,
        origin = data.origin :: Attachment,
        position = data.position,
        range = gunStats.range,
        velocity = gunStats.bulletVelocity
      })

      -- Don't wait on the last bullet
      if index < #directions then
        task.wait(mode.interval)
      end
    end
  end)
end

function CombatProvider.renderBullet(self: self, fireData: FireData): ()
	local bullet = BulletTemplate:Clone()

	bullet.Position = fireData.position
	bullet.Parent = BulletContainer

	createMuzzleFlash(fireData.origin)

	local position = fireData.position
	local velocity = fireData.direction.Unit * fireData.velocity
	local traveledDistance = 0

	local connection: RBXScriptConnection
	connection = RunService.Heartbeat:Connect(function(delta)
		local nextPosition = position + velocity * delta
		local displacement = nextPosition - position

		traveledDistance += displacement.Magnitude

		if traveledDistance >= fireData.range then
			velocity += GRAVITY * delta
		end

    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character :: Instance, BulletContainer }

		local result = workspace:Raycast(
			position,
			displacement,
			raycastParams
		)

		if result then
			bullet.Position = result.Position

			createImpact(
				result.Position,
				result.Normal,
				velocity
			)

			connection:Disconnect()
			bullet:Destroy()

			return
		end

		bullet.Position = nextPosition
		position = nextPosition
	end)

	Debris:AddItem(bullet, 10)
end

export type self = typeof(CombatProvider)

return CombatProvider
