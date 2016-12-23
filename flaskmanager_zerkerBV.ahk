;███████╗██╗      █████╗ ███████╗██╗  ██╗    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗     
;██╔════╝██║     ██╔══██╗██╔════╝██║ ██╔╝    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗    
;█████╗  ██║     ███████║███████╗█████╔╝     ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝    
;██╔══╝  ██║     ██╔══██║╚════██║██╔═██╗     ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗    
;██║     ███████╗██║  ██║███████║██║  ██╗    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║    
;╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    
; Zerker BV edition
; 1 QS, 2 Atziri, 3 Basalt, 4 heal, 5 Witchfire/Silver/Sin's Rebirth
; ████████████████████████████████████████████████████████████████████████████████████████████████████████████

;#####################################################################################

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
#Include %A_ScriptDir%\libs\Gdip.ahk
#Include %A_ScriptDir%\libs\Gdip_ImageSearch.ahk
#SingleInstance force
SetBatchLines, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

pToken := Gdip_Startup()
pBitmapHaystack := 0
Scan := 0
Stride := 0
BitmapData := 0

Flask1_timer := 0
Flask2_timer := 0
Flask3_timer := 0
Flask4_timer := 0
Flask5_timer := 0
FlaskHP_timer := 0

Flask1_DURATION := 4000 * 1.32 ; QS 4000 + 32% (20% quality, 12% alchemist)
Flask2_DURATION := 3500 * 1.32 ; Atziri 3500 + 32% (20% quality, 12% alchemist)
Flask3_DURATION := 5000 * 1.32 ; Basalt 5000 + 32% (20% quality, 12% alchemist)
;Flask4 - Heal
Flask5_DURATION := 5000 * 1.32 ; Witchfire 5000 + 32% (20% quality, 12% alchemist)

;#####################################################################################

Loop 
{
	IfWinActive, Path of Exile ahk_class POEWindowClass 
	{
		pBitmapHaystack := Gdip_BitmapFromScreen(1) ;Grabing screenshot from main monitor
		Gdip_LockBits(pBitmapHaystack, 0, 0, 1920, 1080, Stride, Scan, BitmapData)

		;MeasureAverageColor3x3(Scan, 1504, 66, Stride)
		
		if IsIngame() {
			Flask1Logic()
			Flask2Logic()
			Flask5Logic()

			if !IsSameColors(Scan, 89, 948, Stride, 173, 24, 35) { ;checking for 60% hp
				HealLogic()
			}
		}
		else {
			Sleep 500
		}

		Gdip_UnlockBits(pBitmapHaystack, BitmapData)
		Gdip_DisposeImage(pBitmapHaystack)
		Sleep 20 ;Small sleep timer in main cycle
	}
	else
		Sleep 3000 ;Waiting for game to activate
}

;#####################################################################################

IsIngame()
{
	global Scan, Stride
	if ((Scan = 0) or (Stride = 0))
		return false
	if IsSameColors(Scan, 1441, 991, Stride, 54, 129, 37) ;checking ingame state (green shop button)
		&& !IsSameColors(Scan, 20, 394, Stride, 48, 21, 16) ;closed chat window (Local chat button enabled and shown on screen)
		&& !IsSameColors(Scan, 1504, 66, Stride, 165, 131, 71) { ;closed invenory (yellow pixels near "INVENTORY")
		return true
	}
	return false
}

;#####################################################################################

Flask1Logic()
{
	global Flask1_timer, Flask1_DURATION
	if (A_TickCount - Flask1_timer > Flask1_DURATION) and GetKeyState("RButton", "P") {
		BlockInput On
		Sendinput, {1 Down}
		Sendinput, {1 Up}
		BlockInput Off
		Flask1_timer := A_TickCount
	}
}

;#####################################################################################

Flask2Logic()
{
	global Flask2_timer, Flask2_DURATION
	if (A_TickCount - Flask2_timer > Flask2_DURATION) and GetKeyState("RButton", "P") {
		Sendinput, {2 Down}
		Sendinput, {2 Up}
		Flask2_timer := A_TickCount
	}
}

;#####################################################################################

Flask3Logic()
{
	global Flask3_timer, Flask3_DURATION
	if (A_TickCount - Flask3_timer > Flask3_DURATION) and GetKeyState("RButton", "P") {
		Sendinput, {3 Down}
		Sendinput, {3 Up}
		Flask3_timer := A_TickCount
	}
}

;#####################################################################################

UseBasalt()
{
	global Flask3_timer, Flask3_DURATION
	if (A_TickCount - Flask3_timer > Flask3_DURATION) {
		Sendinput, {3 Down}
		Sendinput, {3 Up}
		Flask3_timer := A_TickCount
	}
}

;#####################################################################################

Flask5Logic()
{
	global Flask5_timer, Flask5_DURATION
	if (A_TickCount - Flask5_timer > Flask5_DURATION) and GetKeyState("RButton", "P") {
        Sendinput, {5 Down}
        Sendinput, {5 Up}
	    Flask5_timer := A_TickCount
	}	
}

;#####################################################################################

HealLogic()
{
	UseBasalt()
	UseHealFlask4()
}

;#####################################################################################

UseHealFlask4()
{
	global FlaskHP_timer
	if (A_TickCount - FlaskHP_timer > 250) {
        Sendinput, {4 Down}
        Sendinput, {4 Up}
		FlaskHP_timer := A_TickCount
		return true
	}
	return false
}

;#####################################################################################

MeasureAverageColor3x3(Scan, x, y, Stride) ;Shows average color of 3x3 pixel box
{
	r0 := 0
	g0 := 0
	b0 := 0	

	Loop 3 {
		X_index := A_index
		Loop 3 {
			Gdip_FromARGB(Gdip_GetLockBitPixel(Scan, x - 2 + X_index, y - 2 + A_index, Stride), a1, r1, g1, b1)
			r0 := r0 + r1
			g0 := g0 + g1
			b0 := b0 + b1
		}
	}
	r0 := r0 / 9
	g0 := g0 / 9
	b0 := b0 / 9
	MsgBox %r0% %g0% %b0%
}

;#####################################################################################

IsSameColors(Scan, x, y, Stride, r2, g2, b2) {
	r0 := 0
	g0 := 0
	b0 := 0	

	Loop 3 {
		X_index := A_index
		Loop 3 {
			Gdip_FromARGB(Gdip_GetLockBitPixel(Scan, x - 2 + X_index, y - 2 + A_index, Stride), a1, r1, g1, b1)
			r0 := r0 + r1
			g0 := g0 + g1
			b0 := b0 + b1
		}
	}
	r0 := r0 / 9
	g0 := g0 / 9
	b0 := b0 / 9

	return ((r0 - r2)*(r0 - r2) + (b0 - b2)*(b0 - b2) + (g0 - g2)*(g0 - g2) < 49)
}

;#####################################################################################

RandSleep(x,y) {
	Random, rand, %x%, %y%
	Sleep %rand%
}

;#####################################################################################

~1::
	Flask1_timer := A_TickCount
return
~2::
	Flask2_timer := A_TickCount
return
~3::
	Flask3_timer := A_TickCount
return
~4::
	Flask4_timer := A_TickCount
return
~5::
	Flask5_timer := A_TickCount
return

;#####################################################################################

;====== INVITE WHISPERER ======
F4::
	BlockInput On
	SendInput ^{Enter}{Home}{Delete}/invite {Enter}{enter}{up}{up}{escape}
	BlockInput Off
	return

;====== TRADE ======
F5::
	BlockInput On
	SendInput ^{Enter}{Home}{Delete}/tradewith {Enter}{enter}{up}{up}{escape}
	BlockInput Off
	return	

;====== HIDEOUT ======
~`::
	SendInput ^{Enter}/hideout{Enter}
	return

;====== CLOSE SCRIPT ======
F12::
	Gdip_Shutdown(pToken) ;Closing handles
	ExitApp
return

;#####################################################################################

;#####################################################################################

;#####################################################################################

;#####################################################################################