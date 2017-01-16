;   ___ _     _      _             
;  / __\ |__ (_) ___| | _____ _ __ 
; / /  | '_ \| |/ __| |/ / _ \ '__|
;/ /___| | | | | (__|   <  __/ |   
;\____/|_| |_|_|\___|_|\_\___|_|   
; FAST chicken script. Auto detect life, ES based char
; Thanks rtoqwo, Treasure_Box, alexsteh, TehCheat for help

#SingleInstance force
#Include %A_ScriptDir%\libs\classMemory.ahk
#Include %A_ScriptDir%\libs\HRTimer.ahk

;================= Checking for timer support and run as admin ================= 
If GetHRresolution(min_resolution, max_resolution) {
   MsgBox No high resolution timer is supported
   ExitApp
}
if not A_IsAdmin {
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
;================================================================================

;================= poe offsets =================
cliexe := "PathOfExile_x64.exe"

;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/Offsets.cs :	private static readonly Pattern basePtrPattern = new Pattern(new byte[]
basePtrPattern := [0x40, 0x53, 0x48, 0x83, 0xEC, 0x50, 0x48, 0xC7, 0x44, 0x24, 0x20, 0xFE, 0xFF, 0xFF, 0xFF, 0xC7, 0x44, 0x24, 0x60, 0x00, 0x00, 0x00, 0x00, 0x48, 0x8b, 0x05]

;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/Offsets.cs :	Base = m.ReadInt(m.AddressOfProcess + array[0] + 0x1A) + array[0] + 0x1E;
baseMgrOffset1 := 0x1A
baseMgrOffset2 := 0x1E

;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/RemoteMemoryObjects/TheGame.cs :       Address = m.ReadLong(Offsets.Base + m.AddressOfProcess, 0x8, 0xf8);
;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/RemoteMemoryObjects/TheGame.cs :       public IngameState IngameState => ReadObject<IngameState>(Address + 0x38);
frameBaseOffset1 := 0x8
frameBaseOffset2 := 0xf8
frameBaseOffset3 := 0x38
;================================================================================

;================= getting ingame stats =================
while WinID!=1 {
	;waiting for the game
	WinGet, WinID, List, ahk_exe %cliexe%
	Sleep, 1000
}
global poe := new _ClassMemory("ahk_exe " . cliexe, "", hProcessCopy)
PatternIsAt := poe.modulePatternScan(cliexe, basePtrPattern*)-poe.BaseAddress
baseMgrPtr := poe.read(poe.BaseAddress+PatternIsAt+baseMgrOffset1, "UInt")+PatternIsAt+baseMgrOffset2
frameBase := poe.read(poe.BaseAddress+baseMgrPtr, "Int64", frameBaseOffset1, frameBaseOffset2, frameBaseOffset3)
global IngameState := frameBase
;================================================================================

;================= start high resolution timer =================
global PlayerStats := Object()
SetHRtimer(1, "chickenTimer")	; START, 1ms timer resolution
Sleep 100000
SetHRtimer(0)			; STOP HR timer
;================================================================================

;==========================main program loop===============================
chickenTimer(uTimerID, uMsg, dwUserP, dw1P, dw2P) {
	readPlayerStats(PlayerStats)
	if (PlayerStats.isInGame){
		if (PlayerStats.maxES > 1000) {
			if (PlayerStats.es < 0.3) {
				run, cports.exe /close * * * * PathOfExile_x64.exe
			}
		} else if (PlayerStats.maxHP > 500) {
			if (PlayerStats.hp < 0.3) {
				run, cports.exe /close * * * * PathOfExile_x64.exe
			}		
		}
	}
}

;======================= read player stats ============================
readPlayerStats(byRef PlayerStats){
	;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/RemoteMemoryObjects/IngameState.cs :       public IngameData Data => ReadObject<IngameData>(Address + 0x160 + Offsets.IgsOffset);
	InGameData := poe.read(IngameState+0x160, "Int64")
	
	PlayerStats.isInGame := False
	if(InGameData > 0xffff){
		PlayerStats.isInGame := True
		
		;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/RemoteMemoryObjects/IngameData.cs :        public Entity LocalPlayer => ReadObject<Entity>(Address + 0x180);
		LocalPlayer := poe.read(InGameData+0x180, "Int64")
		
		;https://github.com/badplayerr/beta-autopot/blob/master/Autopot.ahk :         PlayerMain:=ReadMemUInt(pH,PlayerBase+4)       PlayerStatsOffset:=ReadMemUInt(pH,PlayerMain+0xC)
		LPLifeComponent := poe.read(LocalPlayer+0x8, "Int64", 0x18)
		
		;https://github.com/TehCheat/PoEHUD/tree/x64/src/Poe/Components/Life.cs :      public int CurHP => Address != 0 ? M.ReadInt(Address + 0x54) : 1;   public int CurMana => Address != 0 ? M.ReadInt(Address + 0x84) : 1;
		poe.readRaw(LPLifeComponent, LifeStructure, 0xB8)

		curHP := NumGet(LifeStructure, 0x54, "UInt")
		maxHP := NumGet(LifeStructure, 0x50, "UInt")
		curES := NumGet(LifeStructure, 0xB4, "UInt")
		maxES := NumGet(LifeStructure, 0xB0, "UInt")		
		
		if(maxHP>0 and curHP>0){
			PlayerStats.hp := (curHP*1.0)/(maxHP*1.0)
			PlayerStats.es := (curES*1.0)/(maxES*1.0)
			PlayerStats.maxHP := maxHP
			PlayerStats.maxES := maxES
		}else{
			PlayerStats.hp := 0.0
			PlayerStats.es := 0.0
			PlayerStats.maxHP := 0.0
			PlayerStats.maxES := 0.0
		}
	}
}

;====== SHOW DEBUG INFO ======
#F1::
	maxHP := PlayerStats.maxHP
	maxES := PlayerStats.maxES
	msgbox maxHP = %maxHP%, %maxES%
return

;====== CLOSE SCRIPT ======
F12::
	ExitApp
return