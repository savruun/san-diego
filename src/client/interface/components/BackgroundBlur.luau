const vide = require('@pkg/vide')
const create = vide.create
const spring = vide.spring
const source = vide.source

const camera = workspace.CurrentCamera


type Props = {
  size: number?
}

local function BackgroundBlur(props: Props?)
  props = props or {}

  local blurSize = source(props.size or 24)
  local blurSpring = spring(blurSize)

  return create 'BlurEffect' {
    Parent = camera,
    Size = blurSpring
  } 
end

return BackgroundBlur
