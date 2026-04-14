// Code that opens Roblox Studio dependent on your OS
import { execSync } from 'child_process'

if (process.platform === 'linux') {
  execSync('flatpak run org.vinegarhq.Vinegar', {
    stdio: 'inherit'
  })
} else {
  execSync('start roblox-studio:', {
    stdio: 'inherit'
  })
} 