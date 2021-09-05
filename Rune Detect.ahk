#SingleInstance Force
IniRead, wURL, config.ini, Settings, webhookURL
IniRead, role, config.ini, Settings, roleID
IniRead, user, config.ini, Settings, name
IniRead, macrok, config.ini, Settings, macrokey
IniRead, jumpk, config.ini, Settings, jumpkey
IniRead, npck, config.ini, Settings, npckey
IniRead, UsersToTag, config.ini, Settings, UsersToTag

Global wURL2 = wURL
Global role2 = role
Global notify = 0
Global crashed = 0
Global UsersToTag2 = UsersToTag

if !wURL2 {
MsgBox, No Webhook URL found, please add it under config.ini
ExitApp
}


SendWebhook(Color, Title, Description, Thumbnail) {
if (role2 > 0) {
role3 := "<@&" role2 ">"
} else {
role3 =
}
StringSplit, Tagging, UsersToTag2, `,
Loop, %Tagging0%
{
    role3 .= "<@" Tagging%A_Index% ">"
}
  FormatTime, CurrentTime,, MMM dd yyyy hh:mm:ss tt
  payload := "{""content"" : """ . role3 . """,""embeds"":[{""title"" : """ . Title . """, ""description"" : """ . Description . """, ""color"" : """ . Color . """, ""footer"" : { ""text"" : """ . CurrentTime . """, ""icon_url"" : ""https://i.imgur.com/E5E97dv.png"" },""thumbnail"" :{ ""url"" : """ . Thumbnail . """}}]}"
  whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  whr.Open("POST", wURL2, true)
  whr.SetRequestHeader("User-Agent", "AHK Webhook Script")
  whr.SetRequestHeader("Content-Type", "application/json")
  whr.Send(payload)
  whr.WaitForResponse()
}


Loop {
	if !WinExist("ahk_class MapleStoryClass") {
	crashed++
	}
	if (crashed = 100) {
		color := "16711680"
		title := "Client Crash Detected"
		desc := "** " user " ** Client not found"
		thumbnail := "https://i.imgur.com/E5E97dv.png"
		SendWebhook(color, title, desc, thumbnail)
	}

	if WinExist("ahk_class MapleStoryClass") {
		crashed := 0
	}

ImageSearch, FoundRuneX, FoundRuneY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\images\rune.PNG
    if (FoundRuneX) > 0 {
		notify++
		if(notify = 1) {
			color := "12058879"
			title := "Rune Detected"
			desc := "Rune spotted for **" user "**\n\n**" macrok "** - Pause/Resume\n**" jumpk "** - Jump\n**" npck "** - NPC chat"
			thumbnail := "https://i.imgur.com/WIFghZK.png"
			SendWebhook(color, title, desc, thumbnail)
			notify := 0
		}
		sleep 180000
    } else {
		notify := 0
	}
}