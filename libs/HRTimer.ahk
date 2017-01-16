;================= high resolution timer function =================
SetHRtimer(period, TimerFunc="") {
   Static timer_id, set_period
   If period {
      set_period = period
      DllCall("winmm\timeBeginPeriod", UInt,period)
      timer_id := DllCall("winmm\timeSetEvent", UInt,period, UInt,0
                , UInt,RegisterCallback(TimerFunc,"F"), UInt,0, UInt,1)
      If (ErrorLevel OR timer_id = 0)
          MsgBox Error in timeSetEvent [%ErrorLevel%`,%timer_id%]
      Else Return
   }
   DllCall("winmm\timeKillEvent", UInt,timer_id) ; cleanup
   DllCall("winmm\timeEndPeriod", UInt,set_period)
   Return
}

GetHRresolution(byref p_min_resolution, byref p_max_resolution) {
   error := DllCall("winmm\timeGetDevCaps", Int64P,time_caps, UInt,8)
   If (ErrorLevel OR error) {
      MsgBox, [GetMinMaxResolution] EL = %ErrorLevel%
      Return 1
   }
   p_min_resolution := time_caps & 0xFFFFFFFF
   p_max_resolution := time_caps >> 32
   Return 0
}