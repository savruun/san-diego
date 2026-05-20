const Chat = game:GetService('Chat')

const net = require('@server/net')
const dependency = require('@pkg/quill_dependencies')

const safeChatOptions = require('@shared/data/safeChatOptions')

const Debounce = require('@lib/Debounce')
const safeChatDebounce = Debounce.new(0.75)

const ChatService = {
	cooldowns = {} :: { [number]: number },
}

ChatService.PlayerDataProvider = dependency.use(require('@ssingletons/player/PlayerDataProvider'))

function ChatService.start(self: self)
	self:__listenForSafeChat()
	self.PlayerDataProvider.DropPlayerData:Connect(function(player) safeChatDebounce:clear(player.UserId) end)
end

function ChatService.__listenForSafeChat(self: self)
	net.SaySafeChatOption.On(function(player, option)
		if safeChatDebounce:get(player.UserId) then return end

		local dialog = safeChatOptions.armed[option]
		if not dialog then return end

		Chat:Chat(player.Character, `📢 {dialog}`)
		safeChatDebounce:set(player.UserId)
	end)
end

export type self = typeof(ChatService)
return ChatService
