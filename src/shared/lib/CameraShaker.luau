local HttpService = game:GetService("HttpService")
const RunService = game:GetService('RunService')

const CameraShakerMode = table.freeze {
  --[[
    Manual Application mode, you have to physically apply the shake impulse.
    Allows for modification of the CFrame before application to the Camera.
  ]]
  ManualApplication = 'Manual',

  --[[
    Automatic Application mode, CameraShaker will apply the shake impulses for you.
  ]]
  AutomaticApplication = 'Automatic'
}

const CameraShaker = {
  CameraShakerMode = CameraShakerMode
}

export type self = typeof(CameraShaker)
export type CameraShakerMode = typeof(CameraShakerMode)

--[[
  Creates a new CameraShaker.
  @param camera The camera to apply the shake to, defaults to workspace.CurrentCamera.
  @param mode The mode to create the CameraShaker in, defaults to AutomaticApplication.
  @return CameraShaker Instance
]]
function CameraShaker.new(camera: Camera?, mode: CameraShakerMode?): self
  local self = setmetatable({}, { __index = CameraShaker })

  self.__uuid = HttpService:GenerateGUID()
  self.__mode = mode or CameraShakerMode.AutomaticApplication
  self.__camera = camera or workspace.CurrentCamera

  if self.__mode == CameraShakerMode.AutomaticApplication then
    RunService:BindToRenderStep(`camera-shaker-{self.__uuid}`, Enum.RenderPriority.Camera.Value + 1, function(delta)
      self:__applyShake(delta)
    end)
  end

  return self
end

--[[
  Apply an impulse to the CameraShaker.
  @param self The CameraShaker Instance.
  @param impulse The impulse CFrame to apply to the camera.
]]
function CameraShaker.applyImpulse(self: self, impulse: CFrame): ()
  
end


--[[
  Used for applying the shake CFrame to the Camera in RunService.
  @param self The CameraShaker Instance.
  @param delta The delta time.
  @private
]]
function CameraShaker.__applyShake(self: self, delta: number): ()
  
end

return CameraShaker
