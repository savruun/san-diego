const Chat = game:GetService('Chat')

const net = require('@server/net')
const dependency = require('@pkg/quill_dependencies')

const safeChatOptions = require('@shared/data/safeChatOptions')

const Debounce = require('@lib/Debounce')
const safeChatDebounce = Debounce.new(0.75)

const ChatProvider = {}

ChatProvider.PlayerDataProvider = dependency.use(require('@ssingletons/player/PlayerDataProvider'))
ChatProvider.AnticheatProvider = dependency.use(require('@ssingletons/AnticheatProvider'))
ChatProvider.TeamProvider = dependency.use(require('@ssingletons/player/TeamProvider'))

function ChatProvider.start(self: self)
	self:__listenForSafeChat()
	self.PlayerDataProvider.DropPlayerData:Connect(function(player) safeChatDebounce:clear(player.UserId) end)
end

function ChatProvider.__listenForSafeChat(self: self)
	net.SaySafeChatOption.On(function(player, option)
		if safeChatDebounce:get(player.UserId) then return end

		const teamData = self.TeamProvider:getTeamData(player)
		if not teamData then return end

		const safeChatDialogChoices = safeChatOptions[teamData.safeChatGroup] or safeChatOptions.civilian
		const dialog = safeChatDialogChoices[option]

		if not dialog then
			self.AnticheatProvider:addPlayerTrigger(player, {
				expiration = 30,
				reason = 'Attempted to use non existent safechat dialogue.',
				timestamp = os.clock(),
			})

			return
		end

		Chat:Chat(player.Character, `📢 {dialog}`)
		safeChatDebounce:set(player.UserId)
	end)
end

export type self = typeof(ChatProvider)
return ChatProvider
