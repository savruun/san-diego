const camerashaker = require('@lib/CameraShaker')
const camera = workspace.CurrentCamera

const CameraProvider = {
  cameraShaker = camerashaker.new()
}

function CameraProvider.start(self: self)
end

function CameraProvider.shakeCamera(self: self, shakeCFrame: CFrame)
  
end

function CameraProvider.on_pre_render(delta: number)
  
end

export type self = typeof(CameraProvider)
return CameraProvider