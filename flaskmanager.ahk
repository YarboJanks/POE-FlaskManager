;███████╗██╗      █████╗ ███████╗██╗  ██╗    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗     
;██╔════╝██║     ██╔══██╗██╔════╝██║ ██╔╝    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗    
;█████╗  ██║     ███████║███████╗█████╔╝     ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝    
;██╔══╝  ██║     ██╔══██║╚════██║██╔═██╗     ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗    
;██║     ███████╗██║  ██║███████║██║  ██╗    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║    
;╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    
; Flask 1 2 5 - utility flask like quicksilver, diamond and stibnite. They will be activated by pressing/holding spacebar.
; Support different timer for every flask (4800 default for 1 2, 2000 for 5)
; Flask 3 and 4 - Divine instant life flasks
; Chat detection. Will not send 12345 to game chat Kappa
; F12 - close script
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
pBitmapNeedle := Gdip_CreateBitmapFromFile("bf6.png") ;Blade flury 6 stacks image
BF_timer := 0
Flask1_timer := 0
Flask2_timer := 0
Flask3_timer := 0
Flask4_timer := 0
Flask5_timer := 0
FlaskHP_timer := 0
Enter_key_timer := 0
;#####################################################################################

Loop 
{
	IfWinActive, Path of Exile ahk_class POEWindowClass
	{
		pBitmapHaystack := Gdip_BitmapFromScreen(1) ;Grabing screenshot from main monitor
		Gdip_LockBits(pBitmapHaystack, 0, 0, 1920, 1080, Stride, Scan, BitmapData)

		;MeasureAverageColor3x3(Scan, 1804, 1059, Stride)
		
		if IsSameColors(Scan, 1441, 991, Stride, 54, 129, 37) { ;checking ingame state 
			if !IsSameColors(Scan, 113, 1020, Stride, 83, 12, 18) { ;checking for 30% hp
				Sendinput, {4 Down}
				Sendinput, {4 Up}
				Sendinput, {1 Down}
				Sendinput, {1 Up}
				Sendinput, {2 Down}
				Sendinput, {2 Up}
				Sendinput, {3 Down}
				Sendinput, {3 Up}
				Sendinput, {5 Down}
				Sendinput, {5 Up}																
				run, cports.exe /close * * * * PathOfExile_x64.exe
			}

			Flask1Logic()
			Flask2Logic()
			Flask3Logic()
			Flask5Logic()
			BladeFlurryReleaseAt6()

			if !IsSameColors(Scan, 89, 948, Stride, 173, 24, 35) { ;checking for 60% hp
				HealLogic()
			}
			if !IsSameColors(Scan, 1804, 1059, Stride, 11, 29, 71) { ;checking for 10% mana
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

Flask1Logic() ; Basalt 5000 Base / ToH 4000 Base + 60% (20% quality, 12% alchemist, 20% druidic rite, 8% pathfinder)
{
	global Flask1_timer
	if (A_TickCount - Flask1_timer > 4000*1.6) and GetKeyState("RButton", "P") {
		Sendinput, {1 Down}
		Sendinput, {1 Up}
		Flask1_timer := A_TickCount
	}
}

;#####################################################################################

Flask2Logic() ; Atziri 3500 Base + 60% (20% quality, 12% alchemist, 20% druidic rite, 8% pathfinder) = 5600 ms
{
	global Flask2_timer
	if (A_TickCount - Flask2_timer > 3500*1.6) and GetKeyState("RButton", "P") {
		Sendinput, {2 Down}
		Sendinput, {2 Up}
		Flask2_timer := A_TickCount
	}
}

;#####################################################################################

Flask3Logic() ; Jade 4000 Base + 60% (20% quality, 12% alchemist, 20% druidic rite, 8% pathfinder) = 6400 ms
{
	global Flask3_timer
	if (A_TickCount - Flask3_timer > 4000*1.6) and GetKeyState("RButton", "P") {
		Sendinput, {3 Down}
		Sendinput, {3 Up}
		Flask3_timer := A_TickCount
	}
}

;#####################################################################################

Flask5Logic() ; witchfire 5000 Base + 60% (20% quality, 12% alchemist, 20% druidic rite, 8% pathfinder) = 8000 ms
{
	global Flask5_timer
	if (A_TickCount - Flask5_timer > 5000*1.6) and GetKeyState("RButton", "P") {
        Sendinput, {5 Down}
        Sendinput, {5 Up}
	    Flask5_timer := A_TickCount
	}	
}

;#####################################################################################

BladeFlurryReleaseAt6()
{
	global pBitmapNeedle, BF_timer
	if (A_TickCount - BF_timer > 500) {
		pBitmapHaystack := Gdip_BitmapFromScreen(1) ;Grabing screenshot from main monitor
		RET := Gdip_ImageSearch(pBitmapHaystack,pBitmapNeedle,LIST,0,60,1600,90,128,,5,0) ;limiting area to search faster
		if (RET > 0) {
			if GetKeyState("RButton", "P") {
				Sendinput, {RButton Up}
				Sendinput, {RButton Down}
			} else {
				Sendinput, {RButton Up}
			}
			BF_timer := A_TickCount
		}
		Gdip_DisposeImage(pBitmapHaystack)
	}
}

;#####################################################################################

HealLogic()
{
	UseHealFlask4()
}

;#####################################################################################

UseHealFlask4()
{
	global FlaskHP_timer
	if (A_TickCount - FlaskHP_timer > 250) and IsSameColors(Scan, 471, 1052, Stride, 144, 36, 12) { ;divine 4 flask is ready
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

	return ((r0 - r2)*(r0 - r2) + (b0 - b2)*(b0 - b2) + (g0 - g2)*(g0 - g2) < 5 * 5)
}

;#####################################################################################

RandSleep(x,y) {
	Random, rand, %x%, %y%
	Sleep %rand%
}

;#####################################################################################

~Enter:: ;Chat detection
	Enter_key_timer := A_TickCount
return

;#####################################################################################

~Q:: ;Movement skill (WB)
	if (A_TickCount - Enter_key_timer > 15000) {
		IfWinActive, Path of Exile ahk_class POEWindowClass 
		{

		}
	}
return

~LButton::
	if (A_TickCount - Enter_key_timer > 15000) {
		IfWinActive, Path of Exile ahk_class POEWindowClass 
		{
			if GetKeyState("RButton", "P") { ;BF stack fix
				Sendinput, {RButton Up}
			}
		}
	}
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