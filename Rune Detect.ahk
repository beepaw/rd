#SingleInstance Force
IniRead, wURL, config.ini, Settings, webhookURL
IniRead, role, config.ini, Settings, roleID
IniRead, user, config.ini, Settings, name
IniRead, macrok, config.ini, Settings, macrokey
IniRead, jumpk, config.ini, Settings, jumpkey
IniRead, npck, config.ini, Settings, npckey

Global wURL2 = wURL
Global role2 = role
Global user2 = user
global macrok2 = macrok
global jumpk2 = jumpk
global npck2 = npck

Global notify = 0
Global crashed = 0

if !wURL2 {
MsgBox, No Webhook URL found, please add it under config.ini
ExitApp
}

if (role > 0) {
role3 = "<@&%role2%>"
} else {
role3 = null
}


Loop {
FormatTime, MyTime,, MMM dd yyyy hh:mm:ss tt
postdata=
(
{
  "content": %role3%,
  "embeds": [
    {
      "title": "Rune Detected",
      "description": "Rune spotted for **%user2%**\n\n**%macrok2%** - Pause/Resume\n**%jumpk2%** - Jump\n**%npck2%** - NPC chat",
      "color": 12058879,
      "footer": {
        "text": "%MyTime%",
        "icon_url": "https://i.imgur.com/E5E97dv.png"
      },
      "thumbnail": {
        "url": "https://i.imgur.com/WIFghZK.png"
      }
    }
  ]
}
)
postdata2=
(
{
  "content": %role3%,
  "embeds": [
    {
      "title": "Client Crash Detected",
      "description": "** %user2% ** Client not found",
      "color": 16711680,
      "footer": {
        "text": "%MyTime%",
        "icon_url": "https://i.imgur.com/E5E97dv.png"
      },
      "thumbnail": {
        "url": "https://i.imgur.com/E5E97dv.png"
      }
    }
  ]
}
)

if !WinExist("ahk_class MapleStoryClass") {
crashed++
}

if (crashed = 1) {
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebRequest.Open("POST", wURL2, false)
WebRequest.SetRequestHeader("Content-Type", "application/json")
WebRequest.Send(postdata2) 
}

if WinExist("ahk_class MapleStoryClass") {
crashed := 0
}

ImageSearch, FoundRuneX, FoundRuneY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\images\rune.PNG
    if (FoundRuneX) > 0 {
		notify++
		if(notify = 1) {
			WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
			WebRequest.Open("POST", wURL2, false)
			WebRequest.SetRequestHeader("Content-Type", "application/json")
			WebRequest.Send(postdata)  
			notify := 0
		}
		sleep 120000
    } else {
		notify := 0
	}
}