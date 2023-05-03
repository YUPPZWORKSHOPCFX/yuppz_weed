--===== FiveM Script =========================================
--= weed - YUPPZWORKSHOP CFX (Webhook)
--===== Developed By: ========================================
--= YUPPZWORKSHOP CFX
--= Copyright (C) YUPPZWORKSHOP CFX - All Rights Reserved
--= You are not allowed to sell this script or edit
--============================================================

Config = {}
Config.CircleZones = {
		Zone1 = {
			coords = vector3(2836.1027, -1446.895, 10.913446)},
}
Config.Model 		= "prop_weed_01" --@=> โมเดลเก็บ
Config.Item			= "weed" --@=> ชื่อไอเท็ม
Config.ItemCount	= {1, 2} --@=> จำนวนเก็บเข้าตัว หาก อยากให้ สุ่ม ตั่งเป็น {1, 5}
Config.Cops			= 0	--@=> จำนวนตำรวจปรับแค่อันเดียว
Config.Time			= 1000  --@=> เวลาตอนขโมย 10 เท่ากับ 10 วิ
Config.Text = 'กำลังเก็บกัญชา' --@=> ชื่อตอนเก็บ

NOTIFYPREE = function ()
	exports["?"]:ShowHelpNotification("กด ~INPUT_CONTEXT~ เก็บกัญชา") -- @=>TextUI
end


Config["Discord"] = {
    Webhook = '?',-- @=> webhook
    Enable = false, -- @=> เปิดใช้ Discord Log แยก
    DiscordLog = function(playerId,text) -- @=> Log แยก
		TriggerEvent('azael_discordlogs:sendToDiscord', '?', sendToDiscord, xPlayer.source, '^2')--@=> azaellog
    end
}
