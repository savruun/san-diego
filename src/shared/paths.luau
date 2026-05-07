const ReplicatedStorage = game:GetService('ReplicatedStorage')
const RunService = game:GetService('RunService')
const ServerScriptService = game:GetService('ServerScriptService')

const paths = {}

paths.client = ReplicatedStorage:WaitForChild('client')
paths.shared = ReplicatedStorage:WaitForChild('shared')
paths.server = RunService:IsServer() and ServerScriptService:WaitForChild('server')
paths.interface = paths.client:WaitForChild('interface')
paths.pkg = ReplicatedStorage:WaitForChild('packages')

return paths
