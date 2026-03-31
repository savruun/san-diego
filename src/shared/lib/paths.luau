local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local ServerScriptService = game:GetService('ServerScriptService')
local paths = {}

paths.client = ReplicatedStorage:WaitForChild('client')
paths.shared = ReplicatedStorage:WaitForChild('shared')
paths.server = RunService:IsServer() and ServerScriptService:WaitForChild('server')
paths.interface = paths.client:WaitForChild('interface')

return paths
