;███████╗██╗      █████╗ ███████╗██╗  ██╗    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗     
;██╔════╝██║     ██╔══██╗██╔════╝██║ ██╔╝    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗    
;█████╗  ██║     ███████║███████╗█████╔╝     ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝    
;██╔══╝  ██║     ██╔══██║╚════██║██╔═██╗     ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗    
;██║     ███████╗██║  ██║███████║██║  ██╗    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║    
;╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    
; Zerker BV edition 3 curse
; QS 4000 / Heal or Silver or Jade / ToH 4000 / Atziri 3500 / Witchfire 5000
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
INGAME := false

Flask1_timer := 0
Flask2_timer := 0
Flask3_timer := 0
Flask4_timer := 0
Flask5_timer := 0
FlaskHP_timer := 0
Spacebar_timer := 0

; 1.32 = (20% quality, 12% alchemist)
; QS 4000 / Heal or Silver or Jade / ToH 4000 / Atziri 3500 / Witchfire 5000
Flask1_DURATION := 4000 * (1.32 + 0.32)
Flask2_DURATION := 4000 * 1.32 ;
Flask3_DURATION := 4000 * 1.32
Flask4_DURATION := 3500 * 1.32
Flask5_DURATION := 5000 * 1.32

;#####################################################################################

Loop 
{
	INGAME := false
	IfWinActive, Path of Exile ahk_class POEWindowClass 
	{
		pBitmapHaystack := Gdip_BitmapFromScreen(1) ;Grabing screenshot from main monitor
		Gdip_LockBits(pBitmapHaystack, 0, 0, 1920, 1080, Stride, Scan, BitmapData)

		if IsSameColors(Scan, 1441, 991, Stride, 54, 129, 37) ;checking ingame state (green shop button)
			&& !IsSameColors(Scan, 20, 394, Stride, 48, 21, 16) ;closed chat window (Local chat button enabled and shown on screen)
			&& !IsSameColors(Scan, 1504, 66, Stride, 165, 131, 71) { ;closed invenory (yellow pixels near "INVENTORY")
			INGAME := true

			if (A_TickCount - Spacebar_timer < 16000) { ; Activating flask on spacebar
				UseFlask1()
				UseFlask2()
			}

			Flask1Logic()
			Flask3Logic()
			Flask4Logic()
			Flask5Logic()

			if !IsSameColors(Scan, 98, 970, Stride, 162, 26, 37) { ;checking for 50% hp
				HealLogic()
			}
		}
		else {
			Sleep 500
		}

		;MeasureAverageColor3x3(Scan, 98, 970, Stride)

		Gdip_UnlockBits(pBitmapHaystack, BitmapData)
		Gdip_DisposeImage(pBitmapHaystack)
		Sleep 20 ;Small sleep timer in main cycle
	}
	else
		Sleep 3000 ;Waiting for game to activate
}

;#####################################################################################

UseFlask1() ; Use QS when press left mouse button
{
	global Flask1_timer, Flask1_DURATION
	if (A_TickCount - Flask1_timer > Flask1_DURATION) and GetKeyState("LButton", "P") {
		Sendinput, {1 Down}
		Sendinput, {1 Up}
		Flask1_timer := A_TickCount
	}
}

Flask1Logic() 
{
	global Flask1_timer, Flask1_DURATION
	if (A_TickCount - Flask1_timer > Flask1_DURATION) and GetKeyState("RButton", "P") {
		Sendinput, {1 Down}
		Sendinput, {1 Up}
		Flask1_timer := A_TickCount
	}
}

;#####################################################################################

UseFlask2() ; Use Silver when press left mouse button
{
	global Flask2_timer, Flask2_DURATION
	if (A_TickCount - Flask2_timer > Flask2_DURATION) and GetKeyState("LButton", "P") {
		Sendinput, {2 Down}
		Sendinput, {2 Up}
		Flask2_timer := A_TickCount
	}
}

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

Flask4Logic()
{
	global Flask4_timer, Flask4_DURATION
	if (A_TickCount - Flask4_timer > Flask4_DURATION) and GetKeyState("RButton", "P") {
        Sendinput, {4 Down}
        Sendinput, {4 Up}
	    Flask4_timer := A_TickCount
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
	UseHealFlask2()
}

;#####################################################################################

UseHealFlask2()
{
	global FlaskHP_timer, Flask2_DURATION
	if (A_TickCount - FlaskHP_timer > Flask2_DURATION) {
        Sendinput, {2 Down}
        Sendinput, {2 Up}
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

~Space::
	Spacebar_timer := A_TickCount
return

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

;====== Logout key ======
XButton1::
	run, cports.exe /close * * * * PathOfExile_x64.exe
return

;#####################################################################################

;#####################################################################################

;#####################################################################################

;#####################################################################################